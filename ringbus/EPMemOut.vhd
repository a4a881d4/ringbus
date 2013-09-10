---------------------------------------------------------------------------------------------------
--
-- Title       : Bus End Point Send from Mem
-- Design      : Ring Bus
-- Author      : Zhao Ming
-- Company     : a4a881d4
--
---------------------------------------------------------------------------------------------------
--
-- File        : EPMemOut.vhd
-- Generated   : 2013/9/9
-- From        : 
-- By          : 
--
---------------------------------------------------------------------------------------------------
--
-- Description : Ring bus end point Send from Mem
--
-- Rev: 3.1
--
---------------------------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_signed.all;

use work.rb_config.all;

entity EPMEMOUT is
	generic(
		Awidth : natural;
		Bwidth : natural
	);
	port(
		-- system interface
		clk : in STD_LOGIC;
		rst : in STD_LOGIC;
		
		-- bus interface
		tx_sop : in std_logic;

		Req : out std_logic;
		tx: out std_logic_vector(Bwidth-1 downto 0);
		
		-- Mem interface
		mD : in STD_LOGIC_VECTOR( Bwidth-1 downto 0 );
		
		mAddr : out std_logic_vector( Awidth-1 downto 0 );
		mren : out STD_LOGIC;
		
		-- Local Bus interface
		header : in STD_LOGIC_VECTOR( Bwidth-1 downto 0 );
		laddr : in std_logic_vector( Awidth-1 downto 0 );
		Req_in : in std_logic;  
		
		busy : out std_logic
		);
end EPMEMOUT;

architecture behave of EPMEMOUT is

	signal addr_i : std_logic_vector( Awidth-1 downto 0 ) := (others => '0');
	signal lenc : std_logic_vector( len_length-1 downto 0 ) := (others => '0');
	signal hold : std_logic := '0';
	signal req_p: std_logic := '0';
	signal req_d1:std_logic := '0';
begin

reqP:process(clk,rst)
begin
	if rst='1' then
		req_p<='0';
	elsif rising_edge(clk) then
		req_d1<=req_in;
		if req_d1='0' and req_in='1' then
			req_p<='1';
		else
			req_p<='0';
		end if;
	end if;
end process;
		
sopP:process(clk,rst)
begin
	if rst='1' then
		addr_i<=(others => '0');
		lenc<=(others => '0');
		hold<='0';
		req<='0';
		mren<='0';
		busy<='0';
	elsif rising_edge(clk) then
		if req_p='1' then
			req<='1';
			addr_i<=laddr;
			mren<='1';
			lenc<=header( len_end downto len_start )-1;
			hold<='0';
			busy<='1';
		elsif tx_sop='1' then
			req<='0';
			addr_i<=addr_i+1;
			lenc<=lenc-1;
			hold<='1';
		elsif lenc/=zeros( len_length-1 downto 0 ) 
			and hold='1'
			then
			addr_i<=addr_i+1;
			lenc<=lenc-1;
		elsif lenc=zeros( len_length-1 downto 0 ) then
			hold<='0';
			mren<='0';
			busy<='0';
		end if;
	end if;
end process;

maddr<=addr_i;
tx<=header when tx_sop='1' else mD;

end behave;
