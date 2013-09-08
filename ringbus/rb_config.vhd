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
	
	constant errBusLength		: std_logic_vector( 2 downto 0 )	:= "001";	-- Bus Length != Slot
	constant errIllegalAddress	: std_logic_vector( 2 downto 0 )	:= "010";	-- Illegal Bus address 

	constant command_length		: natural := 7;
	constant addr_length		: natural := 5;
	constant busid_length		: natural := 3;
	constant tag_length			: natural := 8;
	constant len_length			: natural := 8;
	
	constant command_read		: std_logic_vector( command_length-1 downto 0 )	:= "0000001";
	constant command_write		: std_logic_vector( command_length-1 downto 0 )	:= "1000000";
	constant command_complete	: std_logic_vector( command_length-1 downto 0 )	:= "1000001";

	constant Slot				: natural := 17;
	constant Bwidth				: natural := 128;
	
	constant zeros				: std_logic_vector( Bwidth-1 downto 0 ) :=(others=>'0');	
	constant ones				: std_logic_vector( Bwidth-1 downto 0 ) :=(others=>'1');

	constant used_flag_pos		: natural := 0;
	
	constant command_start		: natural := used_flag_pos+1;
	constant command_end		: natural := used_flag_pos+command_length;
	
	constant daddr_start		: natural := 8;
	constant daddr_end			: natural := daddr_start+addr_length-1;

	constant dbusid_start		: natural := daddr_end+1;
	constant dbusid_end			: natural := daddr_end+busid_length;

	constant saddr_start		: natural := 16;
	constant saddr_end			: natural := saddr_start++addr_length-1;

	constant sbusid_start		: natural := saddr_end+1;
	constant sbusid_end			: natural := saddr_end+busid_length;

	constant tag_start			: natural := 24;
	constant tag_end			: natural := tag_start+tag_length-1;

	constant len_start			: natural := 28;
	constant len_end			: natural := len_start+len_length-1;

	constant addr_start			: natural := 64;

	type busgroup is array( natural range<> ) of STD_LOGIC_VECTOR(Bwidth-1 downto 0);
	
end rb_config;

