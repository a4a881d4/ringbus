---------------------------------------------------------------------------------------------------
--
-- Title       : Testbench for Two End Point Example for Ring Bus
-- Design      : Ring Bus
-- Author      : Zhao Ming
-- Company     : a4a881d4
--
---------------------------------------------------------------------------------------------------
--
-- File        : rbus2_tb.vhd
-- Generated   : 2013/9/10
-- From        : 
-- By          : 
--
---------------------------------------------------------------------------------------------------
--
-- Description : Testbench for Two End Point Example for Ring Bus
--               two end point
-- 
-- Rev: 3.1
--
---------------------------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

use work.contr_config.all;

entity RCBUS2_TB is
end RCBUS2_TB;

library	simio;
use simio.SIMIO_PACKAGE.all;

architecture sim of RCBUS2_TB is

component RCBUS2
	port(
		-- system
		clk : in STD_LOGIC;
		rst : in STD_LOGIC;
		
		-- CPU bus
		wr : in std_logic;
		rd : in std_logic;
		addr : in std_logic_vector( 7 downto 0 );
		Din : in std_logic_vector( 7 downto 0 );
		Dout : out std_logic_vector( 7 downto 0 );
		cpuClk : in std_logic
	);
end component;


signal clk : STD_LOGIC :='0';
signal rst : STD_LOGIC :='0';

signal dspce,dspwr,wr,cs0 : std_logic :='0';
signal w_r,rd : std_logic :='0';
signal addr : std_logic_vector( 7 downto 0 );
signal Din : std_logic_vector( 7 downto 0 );
signal Dout : std_logic_vector( 7 downto 0 );
signal cpuClk : std_logic :='0';


begin

cpu:dspemulator
	generic map( 
		DSP_INC_FILE => "rcbus2.inx",
		ABUS_WIDTH => 8,
		DBUS_WIDTH => 8 )
	port map(
		clk	=> clk,
		dspce => dspce,
        dspa => addr,
		data => din,
        wr => w_r,
		IOstb => dspwr
	);
	
cbus2:RCBUS2
	port map(
		-- system
		clk =>clk,
		rst => rst,
		
		wr => wr,
		rd => rd,
		addr => addr,
		Din => Din,
		Dout=>Dout,
		cpuClk => clk
	);
	
	wr<=(not dspwr) and (not w_r);
	rd<=(not dspwr) and w_r;
	rst <= '1', '0' after 10ns;
	clk <= not clk after 1ns;
	
end sim;
	

