---------------------------------------------------------------------------------------------------
--
-- Title       : rb_config
-- Design      : ring bus
-- Author      : Zhao Ming
-- Company     : a4a881d4
--
---------------------------------------------------------------------------------------------------
--
-- File        : rb_config.vhd
-- Generated   : 2013/9/4
-- From        : 
-- By          : 
--
---------------------------------------------------------------------------------------------------
--
-- Description : ring bus constant
--
---------------------------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

package rb_config is  
	
	constant errBusLength	: std_logic_vector( 2 downto 0 )	:= "001";	  	-- Bus Length != Slot
	constant errIllegalAddress	:std_logic_vector( 2 downto 0 )	:= "010"; -- Illegal Bus address 
	
--	constant Slot : integer := 17;
	constant Bwidth : integer := 64;
--	constant Num : integer := 2;
	
	type busgroup is array( natural range<> ) of STD_LOGIC_VECTOR(Bwidth-1 downto 0);
	
end rb_config;


package body rb_config is  	

end rb_config;