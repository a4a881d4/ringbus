-- This unit will simulate a DSP
-- It will read form a file 

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;

use std.textio.all;

library simio;
use simio.SIMIO_PACKAGE.all;

entity dspemulator is
	generic ( DSP_INC_FILE : string := "UNUSED" ;
		ABUS_WIDTH 	: integer 	:= 16;
		DBUS_WIDTH	: integer	:= 16 );
	port (  clk	: in std_logic;
		dspce	: out std_logic;
		dspa	: out std_logic_vector( ABUS_WIDTH-1 downto 0 ) := ( others => '0' );
		data	: out std_logic_vector( DBUS_WIDTH-1 downto 0 ) := ( others => '0' );
		wr		: out std_logic;
		IOstb 	: out std_logic );
end dspemulator;

architecture behavior of dspemulator is
	signal state: integer:=0;
begin
	process( clk )
		variable buf: line ;
		variable lineno:integer:=0;
		FILE data_file: TEXT IS IN DSP_INC_FILE;
		variable counter : integer:=0;
		variable itime : integer:=-1;
		variable init: boolean := false;
		variable onwork: boolean := false;
		variable wrinc: boolean := false;
		variable wrTemp: std_logic :='0';
		variable dataBeRead	: std_logic_vector(DBUS_WIDTH - 1 downto 0)	:= (others => '0');
		variable dataTemp	: std_logic_vector(DBUS_WIDTH - 1 downto 0)	:= (others => '0');
		variable booval: boolean :=false;
		--	variable strTime,strData,strAddress : string(4 downto 1);
		variable strTime	: string(4 downto 1);
		variable strData	: string((DBUS_WIDTH - 1)/4 + 1 downto 1);
		variable strAddress : string((ABUS_WIDTH - 1)/4 + 1 downto 1);
		variable dspaTemp	: std_logic_vector(ABUS_WIDTH - 1 downto 0)	:= (others => '0');
		variable dspceTemp: std_logic:='0';
		
	begin
		if NOT( init ) then
			counter:=0;
			init:=true;	
			onwork:=false;
			state<=4;
			IOstb<='1';
		end if;
		if(DSP_INC_FILE = "UNUSED") then
			ASSERT FALSE
			REPORT "file not found!"
			SEVERITY WARNING;
		end if;
		
		if clk'event and clk='1' then
			counter:=counter+1;
			if itime = counter then
				onwork:=true;
				state<=0;
			end if;
			if itime < counter-5  then
				state<=4;
			end if;
			case state is
				when 0 =>
				dspceTemp:='1';
				dataTemp:=dataBeRead;
				wrTemp:='0';
				state<=state+1;
				when 1 =>
				if wrinc then
					wrTemp:='1';
				end if;
				state<=state+1;
				when 2 =>	
				IOstb<='0';
				state<=state+1;
				when 3 =>
				IOstb<='1';
				state<=state+1;
				when 4 =>
				wrTemp:='0';
				wrinc:=false;
				onwork:=false; 
				dspaTemp:=conv_std_logic_vector(0,ABUS_WIDTH);
				if NOT ENDFILE(data_file) then
					booval := true;
					READLINE(data_file, buf);
					lineno:=lineno+1;
					if (buf(buf'LOW) = 'W') then
						wrinc:=true;
					end if;
					shrink_line(buf, 1);
					READ(L=>buf, VALUE=>strTime, good=>booval);
					if not (booval) then
						ASSERT FALSE
						REPORT "[Line "& int_to_str(lineno) & "]:Illegal File Format! no time domain "
						SEVERITY ERROR;
					end if;
					itime:=itime+hex_str_to_int(strTime);
					shrink_line(buf, 1);   
					READ(L=>buf, VALUE=>strAddress, good=>booval);
					if not (booval) then
						ASSERT FALSE
						REPORT "[Line "& int_to_str(lineno) & "]:Illegal File Format! no write data domain"
						SEVERITY ERROR;
					end if;
					dspatemp:=CONV_STD_LOGIC_VECTOR(hex_str_to_int(strAddress),ABUS_WIDTH);
					if wrinc then
						shrink_line(buf, 1);
						READ(L=>buf, VALUE=>strData, good=>booval);
						if not (booval) then
							ASSERT FALSE
							REPORT "[Line "& int_to_str(lineno) & "]:Illegal File Format! no write data domain"
							SEVERITY ERROR;
						end if;
						dataBeRead:=CONV_STD_LOGIC_VECTOR(hex_str_to_int(strData),DBUS_WIDTH);
					end if;
				end if;
				state <=state+1;
				when others =>
				null;
			end case;
			dspce<=dspceTemp;
			dspa<=dspaTemp(ABUS_WIDTH-1 downto 0 );
			wr<=not wrTemp;
			data<=dataTemp(DBUS_WIDTH-1 downto 0 );
		end if;
	end process;
end behavior;               

