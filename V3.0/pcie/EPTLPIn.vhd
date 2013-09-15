---------------------------------------------------------------------------------------------------
--
-- Title       : Bus End Point Recieve to TLP interface
-- Design      : Ring Bus
-- Author      : Zhao Ming
-- Company     : a4a881d4
--
---------------------------------------------------------------------------------------------------
--
-- File        : EPTLPIn.vhd
-- Generated   : 2013/9/15
-- From        : 
-- By          : 
--
---------------------------------------------------------------------------------------------------
--
-- Description : Ring Bus End Point Recieve to TLP interface
--
-- Rev: 3.1
--
---------------------------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_signed.all;

use work.rb_config.all;

entity EPTLPIN is
	generic(
		Awidth : natural:= 64;
		Bwidth : natural:= 128;
		PCIwidth : natural:= 64;
		BUFAWidth : natural := 4;
		BUFSIZE : natural := 2**BUFAWidth
	);
	port(
		-- system interface
		clk : in STD_LOGIC;
		rst : in STD_LOGIC;
		
		-- bus interface
		rx_sop : in std_logic;
		rx: in std_logic_vector(Bwidth-1 downto 0);
		
		-- TLP interface
		clk_pci : in std_logic;
		rst_pci : in std_logic;

		trn_td : out std_logic_vector( PCIwidth-1 downto 0);
		trn_tsrc_rdy_n : out std_logic;
		trn_select_n : in std_logic;
		trn_tsof_n : in std_logic;
		trn_teof_n : in std_logic
		-- 
		completer_id_i           : in std_logic_vector(15 downto 0)
		);
end EPTLPIN;

architecture behave of EPTLPIN is

type state is (
	IDLE,
	QW0DW1,
	QWXDW0,
	QWXDW1
	);
	
type TLP is array of ( BUFSIZE*33-1 downto 0 ) of std_logic_vector( Bwidth-1 downto 0 );
--type TLPH is array of ( BUFSIZE-1 downto 0 ) of std_logic_vector( Bwidth-1 downto 0 );
signal wraddr_i, rdaddr_i : std_logic_vector( 4 downto 0 ) := (others => '0');
signal wrid_i, rdid_i : std_logic_vector( BUFAwidth-1 downto 0 ) := (others => '0');
signal tlpstate : state := IDLE;
signal TLP_i : TLP := (others =>(others => '0'));

signal lenc : std_logic_vector( len_length-1 downto 0 ) := (others => '0');
signal errcnt : std_logic_vector( 15 downto 0 ) := (others => '0');
signal hold : std_logic := '0';
begin

sopWRP:process(clk,rst)
begin
	if rst='1' then
		wraddr_i<=(others => '0');
		wrid_i<=(others => '0');
		lenc<=(others => '0');
		errcnt<=(others => '0');
	elsif rising_edge(clk) then
		if rx_sop='1' 
			and rx( command_end downto command_start )=command_write 
			then
			wraddr_i<=zeros(4 downto 0);
			TLP_i(conv_integer("100000"&wrid_i))<='0' &
                                RX_MEM_WR64_FMT_TYPE &
                                '0' &
                                Device_TC &
                                "0000" &
                                Device_TD &
                                Device_EP &
                                Device_ATTR &
                                "00" &
                                rx( len_end downto len_start )&"0000" &
                                completer_id_i &
                                Device_WR_TAG &
								"11111111" &
								rx( addr_start+Awidth-1 downto addr_start )
								;
			lenc<=rx( len_end downto len_start )-1;
			hold<='1';
		elsif lenc/=zeros( len_length-1 downto 0 ) then
			lenc<=lenc-1;
			wraddr_i<=addr_i+1;
			THP_i(conv_integer(wraddr_i&wrid_i))<=rx;
		else
			if wrid_i+1 /= rdid_i then
				wrid_i<=wrid_i+1;
			else
				errcnt<=errcnt+1;
			end if
		end if;
	end if;
end process;

sofRRP:process(clk_pci,rst_pci)
begin
	if rst_pci='1' then
		rdaddr_i<=(others => '0');
		rdid_i<=(others => '0');
		tlpstate<=IDLE;
	elsif rising_edge(clk_pci) then
		if trn_select_n='1' then
			case tlpstate is
				when IDLE =>
					if trn_tsof_n='1' then
						tlpstate<=QW0DW1;
						rdaddr_i<=(others => '0');
					end if;
				when QW0DW1 =>
						
		if rx_sop='1' 
			and rx( command_end downto command_start )=command_write 
			then
			wraddr_i<=zeros(4 downto 0);
			TLPH_i(conv_integer(wrid_i))<='0' &
                                RX_MEM_WR64_FMT_TYPE &
                                '0' &
                                Device_TC &
                                "0000" &
                                Device_TD &
                                Device_EP &
                                Device_ATTR &
                                "00" &
                                rx( len_end downto len_start )&"0000" &
                                completer_id_i &
                                Device_WR_TAG &
								"11111111" &
								rx( addr_start+Awidth-1 downto addr_start )
								;
			lenc<=rx( len_end downto len_start )-1;
			hold<='1';
		elsif lenc/=zeros( len_length-1 downto 0 ) then
			lenc<=lenc-1;
			wraddr_i<=addr_i+1;
			THPD_i(conv_integer(wrid_i&wraddr_i))<=rx;
		else
			if wrid_i+1 /= rdid_i then
				wrid_i<=wrid_i+1;
			else
				errcnt<=errcnt+1;
			end if
		end if;
	end if;
end process;

end behave;
