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
-- Rev: 3.0
--
---------------------------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;
use work.rb_config.all;

entity BUSCONTROLLER is
	generic( 
		Slot	:	integer	:= 17;
		Bwidth:	integer	:= 64;
		Num : integer := 3
		);
	port(
		sync : in STD_LOGIC;
		clk : in STD_LOGIC;
		rst : in STD_LOGIC;
		fin: in std_logic;
		D : in STD_LOGIC_VECTOR(Bwidth-1 downto 0);
		Q : out STD_LOGIC_VECTOR(Bwidth-1 downto 0);
		fout : out std_logic
		);
end BUSCONTROLLER;

architecture behave of BUSCONTROLLER is
	signal counter : integer := 0;
	signal inDBUS, outDBUS : std_logic_vector( 2 downto 0 ) := (others => '0');
	signal inAddr, outAddr : std_logic_vector( 4 downto 0 ) := (others => '0');
	signal inUsed, outUsed : std_logic := '0';
	signal inCommand,outCommand : std_logic_vector( 6 downto 0 ) := (others => '0');
begin


inUsed<=D(0);
inCommand<=D( 7 downto 1 );
inAddr <= D(4 downto 0);
inDBus <= D(7 downto 5);
outAddr<=inAddr;
outCommand<=inCommand;

busCheck:process( fin, inUsed,inAddr,inDBus )
begin
	if fin='1' then
		if inUsed='1' then
			if inDBus/="000" then
				outDBus<=(others => '0');
				outUsed<='0';
			elsif inAddr>Num then
				outDBus<=(others => '0');
				outUsed<='0';
			else
				outDBus<=inDBus;
				outUsed<=inUsed;
			end if;
		else
			outDBus<=inDBus;
			outUsed<=inUsed;
		end if;
	else
		outDBus<=inDBus;
		outUsed<=inUsed;
	end if;
end process;

flag:process(clk,rst)
begin
	if rst='1' then
		counter<=0;
		fout<='0';
		Q<=(others => '0');
	elsif rising_edge(clk) then
		if sync='1' or counter=Slot-1 then
			fout<='1';
			counter<=0;
			Q(0)<=outUsed;
			Q(7 downto 1)<=outCommand;
			Q(4 downto 0)<=outAddr;
			Q(7 downto 5)<=outDBus;
			Q(Bwidth-1 downto 8)<=D(Bwidth-1 downto 8);
		else
			fout<='0';
			counter<=counter+1;
			Q<=D;
		end if;
		
	end if;
end process;

end behave;