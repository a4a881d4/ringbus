---------------------------------------------------------------------------------------------------
--
-- Title       : Two End Point Example for Ring Bus
-- Design      : Ring Bus
-- Author      : Zhao Ming
-- Company     : a4a881d4
--
---------------------------------------------------------------------------------------------------
--
-- File        : rbus2.vhd
-- Generated   : 2013/9/7
-- From        : 
-- By          : 
--
---------------------------------------------------------------------------------------------------
--
-- Description : Ring bus example
--               two end point
-- 
-- Rev: 3.0
--
---------------------------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

use work.rb_config.all;


entity RBUS2 is
	port(
		-- system
		clk : in STD_LOGIC;
		rst : in STD_LOGIC;
		
		-- tx
		tx : in busgroup( 1 downto 0);
		Req : in std_logic_vector( 1 downto 0);
		tx_sop : out std_logic_vector( 1 downto 0);
		
		-- rx
		rx_sop : out std_logic_vector( 1 downto 0);
		rx: out busgroup( 1 downto 0)
		);
end RBUS2;

architecture behave of RBUS2 is
	

component RBUS is
	generic( 
		Slot	:	integer	:= 17;
--		Bwidth:	integer	:= 64;
		Num : integer := 3
		);
	port(
		-- system
		sync : in STD_LOGIC;
		clk : in STD_LOGIC;
		rst : in STD_LOGIC;
		
		-- tx
		tx : in busgroup( Num-1 downto 0);
		Req : in std_logic_vector( Num-1 downto 0);
		tx_sop : out std_logic_vector( Num-1 downto 0);
		
		-- rx
		rx_sop : out std_logic_vector( Num-1 downto 0);
		rx: out busgroup( Num-1 downto 0)
		);
end component;


begin

bus2:RBUS 
	generic map( 
		Slot	=>17,
--		Bwidth=>64,
		Num=>2
		)
	port map(
		-- system
		sync =>'0',
		clk => clk,
		rst => rst,
		
		-- tx
		tx => tx,
		Req => Req,
		tx_sop => tx_sop,
		
		-- rx
		rx_sop => rx_sop,
		rx => rx
		);

end behave;