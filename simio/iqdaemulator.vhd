
-- This unit is a IQDAemulator
-- The outout will be writen to a file 

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use std.textio.all;

library simio;
use simio.SIMIO_PACKAGE.all;

entity IQDAemulator is
generic ( DA_FILE : string := "UNUSED";
	  DATA_WIDTH : integer := 6 );
port (
	clk	: in std_logic;
        ce	: in std_logic;
	Iin	: in std_logic_vector(DATA_WIDTH-1 downto 0) := ( others => '0' );
	Qin	: in std_logic_vector(DATA_WIDTH-1 downto 0) := ( others => '0' ));
end IQDAemulator;
 
architecture simulation of IQDAemulator is
begin 
	 
process(clk)
variable idata:integer:=0;
FILE data_file: TEXT IS OUT DA_FILE;
variable buf:line;

begin
	if clk'event and clk='1' then
		if ce='1' then 
			idata:=CONV_INTEGER(unsigned(Iin));
			WRITE(buf,hex_to_str(idata),right,8);
			idata:=CONV_INTEGER(unsigned(Qin));
			WRITE(buf,hex_to_str(idata),right,8);
			WRITELINE(data_file,buf);
		end if;
	end if;
end process;
end simulation;


