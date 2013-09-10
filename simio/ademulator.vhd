-- This unit will simulate a DSP
-- It will read form a file 

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;

use std.textio.all;

library simio;
use simio.SIMIO_PACKAGE.all;

entity ADemulator is
generic ( AD_FILE : string := "UNUSED";
	  DATA_WIDTH : integer := 6 );
port (
	clk	: in std_logic;
        ce	: in std_logic;
	data	: out std_logic_vector(DATA_WIDTH-1 downto 0) := ( others => '0' ));
end ADemulator;

architecture behavior of ADemulator is
signal state: integer:=0; 
constant StrLength : integer :=(DATA_WIDTH+1)/4;
begin
process( clk )
	variable buf: line ;
	variable lineno:integer:=0;
	FILE data_file: TEXT IS IN AD_FILE;
	variable dataTemp: std_logic_vector(15 downto 0):="0000000000000000";
	variable booval: boolean :=false;
	variable strData : string(StrLength downto 1);
begin
	if(AD_FILE = "UNUSED") then
		ASSERT FALSE
		REPORT "file not found!"
		SEVERITY WARNING;
	end if;
			
	if clk'event and clk='1' then
		if ce='1' then
			if NOT ENDFILE(data_file) then
				booval := true;
            			READLINE(data_file, buf);
            			lineno:=lineno+1;
            			READ(L=>buf, VALUE=>strData, good=>booval);
               			if not (booval) then
                  			ASSERT FALSE
                  			REPORT "[Line "& int_to_str(lineno) & "]:Illegal File Format! no time domain "
                  			SEVERITY ERROR;
               			end if;
               			dataTemp:=CONV_STD_LOGIC_VECTOR(hex_str_to_int(strData),16);
               			data<=dataTemp(DATA_WIDTH-1 downto 0 );	 
			else
				data	<= ( others => '0' );
			end if;
		end if;
	end if;
end process;
end behavior;               


