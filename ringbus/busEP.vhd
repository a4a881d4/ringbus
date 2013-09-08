---------------------------------------------------------------------------------------------------
--
-- Title       : Bus End Point
-- Design      : Ring Bus
-- Author      : Zhao Ming
-- Company     : a4a881d4
--
---------------------------------------------------------------------------------------------------
--
-- File        : busEP.vhd
-- Generated   : 2013/9/5
-- From        : 
-- By          : 
--
---------------------------------------------------------------------------------------------------
--
-- Description : Ring bus end point
--
---------------------------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;
use work.rb_config.all;

entity BUSEP is
	generic( 
		Slot	:	integer	:= 17;
		Bwidth:	integer	:= 64;
		POS : integer := 1
		);
	port(
		-- send to bus
		tx: in std_logic_vector(Bwidth-1 downto 0);
		Req : in std_logic;
		tx_sop : out std_logic;
		-- read from bus
		rx_sop : out std_logic;
		rx: out std_logic_vector(Bwidth-1 downto 0);
		
		-- Ring Bus internal signal
		clk : in STD_LOGIC;
		rst : in STD_LOGIC;
		fin : in std_logic;
		D : in STD_LOGIC_VECTOR(Bwidth-1 downto 0);
		Q : out STD_LOGIC_VECTOR(Bwidth-1 downto 0);
		fout : out std_logic
		-- 
		);
end BUSEP;

architecture behave of BUSEP is
	signal inDBUS : std_logic_vector( 2 downto 0 ) := (others => '0');
	signal inAddr : std_logic_vector( 4 downto 0 ) := (others => '0');
	signal inUsed : std_logic := '0';
	signal hold : std_logic := '0';
	signal tx_sop_i : std_logic := '0';
	signal rx_sop_i : std_logic := '0';

begin

inUsed<=D(0);
inAddr <= D(4 downto 0);
inDBus <= D(7 downto 5);
tx_sop<=tx_sop_i;
rx_sop<=rx_sop_i;

rx<=D;

usedP:process(fin,inDBus,inAddr,inUsed,Req)
begin
	if fin='1' then 
		if inDBus="000" and inAddr=POS and inUsed='1' then 
			rx_sop_i<='1';
		else
			rx_sop_i<='0';
		end if;
		if Req='1' and (inUsed='0' or rx_sop_i='1') then
			tx_sop_i<='1';
		else
			tx_sop_i<='0';
		end if;
	else
		tx_sop_i<='0';
		rx_sop_i<='0';
	end if;
end process;

busP:process(clk,rst)
begin
	if rst='1' then
		Q<=(others => '0');
		hold<='0';
		fout<='0';
	elsif rising_edge(clk) then
		if fin='1' then
			if tx_sop_i='1' then
				Q<=tx;
			elsif rx_sop_i='1' then
				Q(0)<='0';
				Q(BWIDTH-1 downto 1)<=D(BWIDTH-1 downto 1);
			else
				Q<=D;
			end if;
			if tx_sop_i='1' then
				hold<='1';
			else
				hold<='0';
			end if;
		elsif hold='1' then
			Q<=tx;
		end if;
		fout<=fin;
	end if;
end process;	
			
end behave;
