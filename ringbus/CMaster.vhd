---------------------------------------------------------------------------------------------------
--
-- Title       : Controll Bus Master
-- Design      : Ring Bus
-- Author      : Zhao Ming
-- Company     : a4a881d4
--
---------------------------------------------------------------------------------------------------
--
-- File        : CMaster.vhd
-- Generated   : 2013/9/13
-- From        : 
-- By          : 
--
---------------------------------------------------------------------------------------------------
--
-- Description : Controll bus master
--
-- Rev: 3.1
--
---------------------------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

library	work;
use work.rb_config.all;

entity CMaster is
	generic( 
		Bwidth : natural := 16;
		POS : natural := 0;
		MyBus : natural := 0
		);
	port(
		-- system
		clk : in STD_LOGIC;
		rst : in STD_LOGIC;
		
		-- send to bus
		tx: out std_logic_vector(Bwidth-1 downto 0);
		Req : out std_logic;
		tx_sop : in std_logic;
		en : in std_logic;
		
		-- read from bus
		rx_sop : in std_logic;
		rx: in std_logic_vector(Bwidth-1 downto 0);
		
		-- Local Bus 
		CS : in std_logic;
		addr : in std_logic_vector(7 downto 0);
		Din : in STD_LOGIC_VECTOR(7 downto 0);
		Dout : out STD_LOGIC_VECTOR(7 downto 0);
		cpuClk : in std_logic;
		wr : in std_logic;
		rd : in std_logic
		-- 
		);
end CMaster;

architecture behave of CMaster is

signal addr_cpu : std_logic_vector( Bwidth-1 downto 0 ) := (others=>'0');
signal word3_cpu : std_logic_vector( Bwidth-1 downto 0 ) := (others=>'0');
signal cs_wr : std_logic := '0';
signal inCommand : std_logic_vector( command_end downto command_start ) := (others => '0');
signal inDBUSID : std_logic_vector( dbusid_end downto dbusid_start ) := (others => '0');
signal inAddr : std_logic_vector( daddr_end downto daddr_start ) := (others => '0');

signal inTag, returnTag, rdTag : std_logic_vector( len_length downto 0 ) := ( others=>'0' );
signal TagState : std_logic_vector( 2**len_length-1 downto 0 ) := ( others=>'0' );
signal req_cpu : std_logic := '0';
signal tstate,rstate : natural := 0;
signal busy_i : std_logic := '0';

signal tagen : std_logic := '0';
signal TagData : std_logic_vector( Bwidth-1 downto 0 ) := (others=>'0');

component AAI
	generic( 
		width : natural := 32;
		Baddr : std_logic_vector( 3 downto 0 ) := "0000"
		);
	port(
		-- system signal
		rst : in STD_LOGIC;
		
		-- CPU bus
		CS : in std_logic;
		addr : in std_logic_vector( 3 downto 0 );
		Din : in std_logic_vector( 7 downto 0 );
		cpuClk : in std_logic;
		
		Q : out std_logic_vector( width-1 downto 0 ) 
		);
end component;
begin

cs_wr <= cs and wr;

ADDR_AAI:AAI
	generic map( 
		width => Bwidth,
		Baddr => reg_Controll_ADDR
		)
	port map(
		rst => rst,
		
		CS => cs_wr,
		addr => addr,
		Din => Din,
		cpuClk => cpuClk,
		
		Q => addr_cpu 
		);

DATA_AAI:AAI
	generic map( 
		width => Bwidth,
		Baddr => reg_Controll_DATA
		)
	port map(
		rst => rst,
		
		CS => cs_wr,
		addr => addr,
		Din => Din,
		cpuClk => cpuClk,
		
		Q => word3_cpu 
		);
		
tagmem:blockdram
	generic map( 
		depth => 2**len_length,
		Dwidth => Bwidth,
		Awidth => len_length
		)
	port map(
		addra => returnTag,
		clka => clk,
		addrb => rdTag,
		clkb => clk,
		dia => rx,
		wea => tagen,
		reb => '1',
		dob => TagData
		);

cpuwriteP:process( cpuClk, rst )
begin
	if rst='1' then
		inAddr<=( others=>'0' );
		inDBUSID<=( others=>'0' );
		inCommand<=( others=>'0' );
		inTag<=( others=>'0' );
		rdTag<=( others=>'0' );
		req_cpu<='0';
	elsif rising_edge(cpuClk) then
		if cs_wr='1' then
			case addr is
				when reg_Controll_BADDR =>
					inAddr<=Din( addr_length-1 downto 0 );
				when reg_Controll_BID =>
					inDBUSID<=Din( busid_length-1 downto 0 );
				when reg_Controll_Tag =>
					inTag<=Din( len_length-1 downto 0 );
				when reg_Controll_rdTag =>
					rdTag<=Din( len_length-1 downto 0 );
				when reg_Controll_Command =>
					inCommand<=Din( command_length-1 downto 0 );
				when reg_START => 
					req_cpu<='1';
				when others =>	
					null;
			end case;
		end if;
		if rd='1' then
			
		if req_cpu='1' then
			req_cpu<='0';
		end if;
	end if;
end process;				

FSMT:process(clk,rst)
begin
	if rst='1' then
		tstate<=state_IDLE;
		req<='0';
		busy_i<='0';
		tx <= zeros( Bwidth-1 downto 0 );
	elsif rising_edge(clk) then
		case state is
			when state_IDLE =>
				if req_cpu='1' then
					tstate<=state_LOADING;
					busy_i<='1';
				else
					busy_i<='0';
				end if;
				req<='0';
			when state_LOADING =>
				tx( comand_end downto command_start )<=inCommand;
				tx( dbusid_end downto dbusid_start )<=inDBUSID;
				tx( daddr_end downto daddr_start )<=inAddr;
				tx( len_end downto len_start ) <= zeros(len_end downto len_start)+2;
				req<='1';
				tstate<=state_SENDING;
			when state_SENDING =>
				if en='1' and tx_sop='1' then
					tx<=addr_cpu;
					tstate<=state_ADDR;
					req<='0';
				end if;
			when state_ADDR =>
				if inCommand=command_write then
					tx<=word3_cpu;
				else
					tx( comand_end downto command_start )<=command_complete;
					tx( dbusid_end downto dbusid_start )<=zeros( dbusid_end downto dbusid_start )+MyBUSID;
					tx( daddr_end downto daddr_start )<=zeros( daddr_end downto daddr_start )+POS;
					tx( len_end downto len_start )<=inTag;
				end if;
				tstate<=state_IDLE;
				busy_i<='0';
			when others =>
				req<='0';
				tstate<=state_IDLE;
		end case;
	end if;
end process;						 

FSMR:process(clk,rst)
begin
	if rst='1' then
		rstate<=state_IDLE;
		returnTag<=( others=>'0' );
		tagen<='0';
	elsif rising_edge(clk) then
		case rstate is
			when state_IDLE =>
				if rx_sop='1' then
					rstate<=state_ADDR;
					tagen<='0';
				end if;
				tagen<='0'
			when state_ADDR =>
				returnTag<=rx( len_end downto len_start );
				tagen<='1';
				rstate<=state_IDLE;
			when others =>
				rstate<=state_IDLE;
		end case;
	end if;
end process;						 


rdP:process(rd,addr,cs,rdTag)
begin
	if rd='1' and cs='1' then
		case addr is
			when reg_Controll_Busy =>
				Dout(0)<=busy_i;
				Dout( Bwidth-1 downto 0 )<=(others=>'Z');
			when reg_Controll_TagState =>
				Dout(0)<=TagState(rdTag);
				Dout( Bwidth-1 downto 0 )<=(others=>'Z');
			when reg_Controll_TagData =>
				Dout<=TagData;
			when others =>
				Dout<=(others=>'Z');
		end case;
	end if;
end process;
end behave;
