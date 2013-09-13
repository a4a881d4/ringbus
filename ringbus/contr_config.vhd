---------------------------------------------------------------------------------------------------
--
-- Title       : contr_config
-- Design      : ring bus
-- Author      : Zhao Ming
-- Company     : a4a881d4
--
---------------------------------------------------------------------------------------------------
--
-- File        : contr_config.vhd
-- Generated   : 2013/9/10
-- From        : 
-- By          : 
--
---------------------------------------------------------------------------------------------------
--
-- Description : controll reg config
--
-- Rev: 3.1
--
---------------------------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.all;

package contr_config is
	
	constant reg_Controll_RESET		: std_logic_vector( 3 downto 0 )	:= "0000";
	constant reg_Controll_START		: std_logic_vector( 3 downto 0 )	:= "1111";
	
	constant reg_Controll_ADDR		: std_logic_vector( 3 downto 0 )	:= "0001";
	constant reg_Controll_DATA		: std_logic_vector( 3 downto 0 )	:= "0010";
	
	constant reg_Controll_BADDR		: std_logic_vector( 3 downto 0 )	:= "0100";
	constant reg_Controll_BID		: std_logic_vector( 3 downto 0 )	:= "0101";
	constant reg_Controll_Command	: std_logic_vector( 3 downto 0 )	:= "1000";
	constant reg_Controll_Tag		: std_logic_vector( 3 downto 0 )	:= "1001";
	constant reg_Controll_rdTag		: std_logic_vector( 3 downto 0 )	:= "1010";
	
	--
	constant reg_Controll_TagState	: std_logic_vector( 3 downto 0 )	:= "1111";
	constant reg_Controll_Busy		: std_logic_vector( 3 downto 0 )	:= "0000";
	constant reg_Controll_TagData	: std_logic_vector( 3 downto 0 )	:= "0001";
	
	

end contr_config;

