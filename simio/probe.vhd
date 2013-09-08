
-- This unit is a probe
-- The outout will be writen to a file 
-- signal1, signal2, signal3, signal4
-- and so on

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use std.textio.all;

library simio;
use simio.SIMIO_PACKAGE.all;

entity probe is
generic ( PROBE_FILE : string := "UNUSED"; 
	  SIGNAL1_WIDTH	: NATURAL:=6;
	  SIGNAL1_MASK	: integer:=0;
	  SIGNAL1_TRG	: integer:=0;
	  SIGNAL2_WIDTH	: NATURAL:=6;
	  SIGNAL2_MASK	: integer:=0;
	  SIGNAL2_TRG	: integer:=0;
	  SIGNAL3_WIDTH	: NATURAL:=6;
	  SIGNAL3_MASK	: integer:=0;
	  SIGNAL3_TRG	: integer:=0;
	  SIGNAL4_WIDTH	: NATURAL:=6;
	  SIGNAL4_MASK	: integer:=0;
	  SIGNAL4_TRG	: integer:=0);
port (
	  clk		: in std_logic;
	  signal1	: in std_logic_vector(SIGNAL1_WIDTH-1 downto 0);
	  signal2	: in std_logic_vector(SIGNAL2_WIDTH-1 downto 0);
	  signal3	: in std_logic_vector(SIGNAL3_WIDTH-1 downto 0);
	  signal4	: in std_logic_vector(SIGNAL4_WIDTH-1 downto 0));
end probe;
 
architecture simulation of probe is
begin 
	 
process(clk)
variable init:boolean:=false;
variable lineno:integer:=0;
variable idata:integer:=0;
variable v1mask,v1trg: std_logic_vector( SIGNAL1_WIDTH-1 downto 0);
variable v2mask,v2trg: std_logic_vector( SIGNAL2_WIDTH-1 downto 0);
variable v3mask,v3trg: std_logic_vector( SIGNAL3_WIDTH-1 downto 0);
variable v4mask,v4trg: std_logic_vector( SIGNAL4_WIDTH-1 downto 0);
FILE data_file: TEXT IS OUT PROBE_FILE;
variable buf:line;

begin
	v1mask:=CONV_STD_LOGIC_VECTOR(SIGNAL1_MASK,SIGNAL1_WIDTH);
	v1trg:=CONV_STD_LOGIC_VECTOR(SIGNAL1_TRG,SIGNAL1_WIDTH);
	v2mask:=CONV_STD_LOGIC_VECTOR(SIGNAL2_MASK,SIGNAL2_WIDTH);
	v2trg:=CONV_STD_LOGIC_VECTOR(SIGNAL2_TRG,SIGNAL2_WIDTH);
	v3mask:=CONV_STD_LOGIC_VECTOR(SIGNAL3_MASK,SIGNAL3_WIDTH);
	v3trg:=CONV_STD_LOGIC_VECTOR(SIGNAL3_TRG,SIGNAL3_WIDTH);
	v4mask:=CONV_STD_LOGIC_VECTOR(SIGNAL4_MASK,SIGNAL4_WIDTH);
	v4trg:=CONV_STD_LOGIC_VECTOR(SIGNAL4_TRG,SIGNAL4_WIDTH);
	
	if clk'event and clk='1' then
		if (signal1 and v1mask)=v1trg and 
			(signal2 and v2mask)=v2trg and
			(signal3 and v3mask)=v3trg and
			(signal4 and v4mask)=v4trg then
			idata:=CONV_INTEGER(unsigned(signal1));
			WRITE(buf,hex_to_str(idata),right,8);
			idata:=CONV_INTEGER(unsigned(signal2));
			WRITE(buf,hex_to_str(idata),right,8);
			idata:=CONV_INTEGER(unsigned(signal3));
			WRITE(buf,hex_to_str(idata),right,8);
			idata:=CONV_INTEGER(unsigned(signal4));
			WRITE(buf,hex_to_str(idata),right,8);
			WRITELINE(data_file,buf);
		end if;
	end if;
end process;
end simulation;


