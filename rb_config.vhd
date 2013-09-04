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
	
	constant errBusLength	: std_logic_vector	:= "001";	  	-- Bus Length != DSlot+CSlot
	constant errIllegalAddress	std_logic_vector	:= "010"; -- Illegal Bus address 
	constant idle std_logic_vector := x"ffffffff";
	
	constant ones	: std_logic_vector(m-1 downto 0)	:= (others => '1');
	
end rb_config;


package body rs_config is  	
	

end rb_config;
