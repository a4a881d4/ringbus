
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;

use std.textio.all;

package SIMIO_PACKAGE is

component dspemulator
generic ( DSP_INC_FILE 	: string 	:= "UNUSED";
	  ABUS_WIDTH 	: integer 	:= 16;
	  DBUS_WIDTH	: integer	:= 16 );
port (
	clk	: in std_logic;
        dspce	: out std_logic;
	dspa	: out std_logic_vector( ABUS_WIDTH-1 downto 0);
	data	: out std_logic_vector( DBUS_WIDTH-1 downto 0);
        wr	: out std_logic;
	IOstb 	: out std_logic);
end component ;
component probe 
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
end component;
	
component ADemulator
generic ( AD_FILE : string := "UNUSED";
	  DATA_WIDTH : integer := 6 );
port (
	clk	: in std_logic;
        ce	: in std_logic;
	data	: out std_logic_vector(DATA_WIDTH-1 downto 0));
end component ;
	
component DAemulator
generic ( DA_FILE : string := "UNUSED";
	  DATA_WIDTH : integer := 6 );
port (
	clk	: in std_logic;
        ce	: in std_logic;
	data	: in std_logic_vector(DATA_WIDTH-1 downto 0));
end component ;

component IQADemulator
generic ( AD_FILE : string := "UNUSED";
	  DATA_WIDTH : integer := 6 );
port (
	clk	: in std_logic;
        ce	: in std_logic;
	Iout	: out std_logic_vector(DATA_WIDTH-1 downto 0);
	Qout	: out std_logic_vector(DATA_WIDTH-1 downto 0));
end component ;
	
component IQDAemulator
generic ( DA_FILE : string := "UNUSED";
	  DATA_WIDTH : integer := 6 );
port (
	clk	: in std_logic;
        ce	: in std_logic;
	Iin	: in std_logic_vector(DATA_WIDTH-1 downto 0);
	Qin	: in std_logic_vector(DATA_WIDTH-1 downto 0));
end component ;

function int_to_str( value : integer ) return string;
function hex_str_to_int( str : string ) return integer;
function hex_to_str( value : integer ) return string;
procedure Shrink_line(L : inout LINE; pos : in integer);
		
end SIMIO_PACKAGE;

package body SIMIO_PACKAGE is

function int_to_str( value : integer ) return string is
    variable ivalue,index : integer;
    variable digit : integer;
    variable line_no: string(8 downto 1) := "        ";
    begin
    ivalue := value;
    index := 1;
    while (ivalue > 0 ) loop
       digit := ivalue MOD 10;
       ivalue := ivalue/10;
       case digit is
           when 0 =>        line_no(index) := '0';
           when 1 =>        line_no(index) := '1';
           when 2 =>        line_no(index) := '2';
           when 3 =>        line_no(index) := '3';
           when 4 =>        line_no(index) := '4';
           when 5 =>        line_no(index) := '5';
           when 6 =>        line_no(index) := '6';
           when 7 =>        line_no(index) := '7';
           when 8 =>        line_no(index) := '8';
           when 9 =>        line_no(index) := '9';
           when others =>   ASSERT FALSE
              REPORT "Illegal number!"
              SEVERITY ERROR;
       end case;
       index := index + 1;
    end loop;
    return line_no;
end;

function hex_str_to_int( str : string ) return integer is
    variable len : integer := str'length;
    variable ivalue : integer := 0;
    variable digit : integer;
    begin
    for i in len downto 1 loop
       case str(i) is
          when '0' =>	digit := 0;
          when '1' =>       digit := 1;
          when '2' =>           digit := 2;
          when '3' =>             digit := 3;
          when '4' =>             digit := 4;
          when '5' =>             digit := 5;
          when '6' =>             digit := 6;
          when '7' =>             digit := 7;
          when '8' =>             digit := 8;
          when '9' =>             digit := 9;
          when 'A' =>             digit := 10;
          when 'a' =>             digit := 10;
          when 'B' =>             digit := 11;
          when 'b' =>             digit := 11;
          when 'C' =>             digit := 12;
          when 'c' =>             digit := 12;
          when 'D' =>             digit := 13;
          when 'd' =>             digit := 13;
          when 'E' =>             digit := 14;
          when 'e' =>             digit := 14;
          when 'F' =>             digit := 15;
          when 'f' =>             digit := 15;
          when others=>
           ASSERT FALSE
           REPORT "Illegal character "&  str(i) & "in Intel Hex File! "
           SEVERITY ERROR;
   end case;
   ivalue := ivalue * 16 + digit;
   end loop;
   return ivalue;
end;

function hex_to_str( value : integer ) return string is
    variable ivalue,index : integer;
    variable digit : integer;
    variable line_no: string(8 downto 1) := "        ";
    begin
    ivalue := value;
    index := 1;
    while ( index<=8 ) loop
       digit := ivalue MOD 16;
       ivalue := ivalue/16;
       case digit is
           when 0 =>
              line_no(index) := '0';
           when 1 =>
              line_no(index) := '1';
           when 2 =>
              line_no(index) := '2';
           when 3 =>
              line_no(index) := '3';
           when 4 =>
              line_no(index) := '4';
           when 5 =>
              line_no(index) := '5';
           when 6 =>
              line_no(index) := '6';
           when 7 =>
              line_no(index) := '7';
           when 8 =>
              line_no(index) := '8';
           when 9 =>
              line_no(index) := '9';
           when 10 =>
              line_no(index) := 'A';
           when 11 =>
              line_no(index) := 'B';
           when 12 =>
              line_no(index) := 'C';
           when 13 =>
              line_no(index) := 'D';
           when 14 =>
              line_no(index) := 'E';
           when 15 =>
              line_no(index) := 'F';
           when others =>
              ASSERT FALSE
              REPORT "Illegal number!"
              SEVERITY ERROR;
       end case;
       index := index + 1;
    end loop;
    return line_no;
end;

procedure Shrink_line(L : inout LINE; pos : in integer)  is
	   subtype nstring is string(1 to pos);
	   variable stmp : nstring;
begin
       if pos >= 1 then
           read(l,stmp);
       end if;
end;


    
end SIMIO_PACKAGE;

