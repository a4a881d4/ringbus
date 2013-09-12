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
-- 		assume RAM has one clock delay from addr to data
--
-- Rev: 3.1
--
---------------------------------------------------------------------------------------------------
--
--	Todo:
--		1. add speed level to module															   
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
	signal state: natural range 0 to 4;
	
begin									

FSM:process(clk,rst)
begin
	if rst='1' then
		addr_i<=(others => '0');
		lenc<=(others => '0');
		hold<='0';
		req<='0';
		mren<='0';
		busy<='0';
		state<=outepS_idle;
	elsif rising_edge(clk) then
		case state is
			when outepS_idle =>
				if req_in='1' then
					state<=outepS_pending;
				end if;
			when outepS_pending =>
				req<='1';
				addr_i<=laddr;
				lenc<=header( len_end downto len_start )-1;
				busy<='1';
				mren<='1';
				state<=outepS_ready;
			when outepS_ready =>
				if tx_sop='1' then
					req<='0';
					addr_i<=addr_i+1;
					lenc<=lenc-1;
					hold<='1';
					state<=outepS_trans;
				end if;
			when outepS_trans =>
				if lenc/=zeros( len_length-1 downto 0 ) then
					addr_i<=addr_i+1;
					lenc<=lenc-1;
				end if;
				if lenc=zeros( len_length-1 downto 0 ) then
					hold<='0';
					busy<='0';
					if req_in='0' then
						state<=outepS_idle;
					else
						state<=outepS_pending;
					end if;
					mren<='0';
				end if;
			when outepS_end =>
			when others =>
				null;
		end case;
	end if;
end process;

maddr<=addr_i;
tx<=header when tx_sop='1' else mD;

end behave;
