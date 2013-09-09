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
-- Rev: 3.1
--
---------------------------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.all;

package rb_config is
	
	constant errBusLength		: std_logic_vector( 2 downto 0 )	:= "001";	-- Bus Length != Slot
	constant errIllegalAddress	: std_logic_vector( 2 downto 0 )	:= "010";	-- Illegal Bus address 

	constant zeros				: std_logic_vector( 255 downto 0 ) :=(others=>'0');	
	constant ones				: std_logic_vector( 255 downto 0 ) :=(others=>'1');

	constant command_length		: natural := 4;
	constant addr_length		: natural := 6;
	constant busid_length		: natural := 6;
	constant tag_length			: natural := 8;
	constant len_length			: natural := 8;
	
	constant command_idle		: std_logic_vector( command_length-1 downto 0 )	:= zeros( command_length-1 downto 0 );
	constant command_write		: std_logic_vector( command_length-1 downto 0 )	:= "1000";

	constant Slot				: natural := 33;

	constant command_start		: natural := 0;
	constant command_end		: natural := used_flag_pos+command_length;
	
	constant daddr_start		: natural := 4;
	constant daddr_end			: natural := daddr_start+addr_length-1;

	constant dbusid_start		: natural := daddr_end+1;
	constant dbusid_end			: natural := daddr_end+busid_length;

	-- only used for 128 bit Bus
	constant tag_start			: natural := 16;
	constant tag_end			: natural := tag_start+tag_length-1;

	constant len_start			: natural := 24;
	constant len_end			: natural := len_start+len_length-1;

	constant addr_start			: natural := 64;
	--
	
	type busgroup is array( natural range<> ) of STD_LOGIC_VECTOR( natural range<> );
	
end rb_config;

