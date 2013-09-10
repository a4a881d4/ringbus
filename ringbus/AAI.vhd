---------------------------------------------------------------------------------------------------
--
-- Title       : auto add cpu interface
-- Design      : Ring Bus
-- Author      : Zhao Ming
-- Company     : a4a881d4
--
---------------------------------------------------------------------------------------------------
--
-- File        : AAI.vhd
-- Generated   : 2013/9/5
-- From        : 
-- By          : 
--
---------------------------------------------------------------------------------------------------
--
-- Description : auto add cpu interface
--
-- Rev: 3.1
--
---------------------------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

use work.dma_config.all;

entity AAI is
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
end AAI;

architecture behave of AAI is

signal start : natural range 0 to width-1;
signal D : std_logic_vector( 127 downto 0 );

begin
writeP:process( cpuClk, rst )
begin
	if rst='1' then
		D<=( others=>'0' );
		start<=0;
	elsif rising_edge(cpuClk) then
		if CS='1' then
			if addr=reg_RESET then
				start<=0;
			elsif addr=Baddr then
				D( start+7 downto start )<=Din;
				start<=start+8;
			end if;
		end if;
	end if;
end process;

Q<=D(width-1 downto 0 );

end behave;

	
