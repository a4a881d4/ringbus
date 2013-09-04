---------------------------------------------------------------------------------------------------
--
-- Title       : Bus Controller
-- Design      : Ring Bus
-- Author      : Zhao Ming
-- Company     : a4a881d4
--
---------------------------------------------------------------------------------------------------
--
-- File        : buscontroller.vhd
-- Generated   : 2013/9/4
-- From        : 
-- By          : 
--
---------------------------------------------------------------------------------------------------
--
-- Description : Ring bus controller
--
---------------------------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity BUSCONTROLLER is
	generic( 
		CSlot	:	integer	:= 2;
		DSlot : integer	:= 34;
		Bwidth:	integer	:= 64;
		Res: integer := 36 -- Res >= 1
		);
	port(
		sync : in STD_LOGIC;
		clk : in STD_LOGIC;
		rst : in STD_LOGIC;
		Cfin : in std_logic;
		Ufin : in std_logic;
		D : in STD_LOGIC_VECTOR(Bwidth-1 downto 0);
		Q : out STD_LOGIC_VECTOR(Bwidth-1 downto 0);
		Cfout : out std_logic;
		Ufout : out std_logic;
		busErr : out std_logic;
		errCode : out std_logic_vector( 3 downto 0 );
		errState : out std_logic_vector( Bwidth-1 downto 0 )
		);
end BUSCONTROLLER;

architecture behave of BUSCONTROLLER is 

component ShiftReg is
	generic(
		width	: integer;
		depth	: integer
		);
	port(
		clk	: in std_logic;
		ce	: in std_logic;
		D	: in std_logic_vector(width-1 downto 0);
		Q	: out std_logic_vector(width-1 downto 0) := ( others => '0' );
		S	: out std_logic_vector(width-1 downto 0)
		);

	constant BudLength : integer := CSlot+Slot;
	signal couter : integer := 0;
	signal delayin : std_logic_vector(Dwidth+2 downto 0) := ( others => '0' );
	signal delayout : std_logic_vector(Dwidth+2 downto 0) := ( others => '0' );
	
begin

delayBlock : ShiftReg 
	generic map(
		width => Dwidth+2,
		depth => Res-1
		)
	port map(
		clk => clk,
		ce => 1,
		D => delayin,
		Q => delayout
		)
		
Ufout<=delayout(Dwidth+1);
Cfout<=delayout(Dwidth);
Q<=delayout(Dwidth-1 downto 0);

flag:process(clk,rst)
begin
	if rst='1' then
		counter<=0;
		Cf<='0';
		Uf<='0';
		busErr<='0';
		errCode<=(others => '0');
		errState<=(others => '0');
	elsif rising_edge(clk) then
		if sync='1' or counter=BusLength-1 then
			counter<=0;
			Cf<='1';
				
end behave;

