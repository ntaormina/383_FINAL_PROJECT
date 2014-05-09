----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    17:14:50 02/13/2014 
-- Design Name: 
-- Module Name:    pixel_gen - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
library UNISIM;
use UNISIM.VComponents.all;

entity pixel_gen is

    port ( row     : in unsigned(10 downto 0);
           column  : in unsigned(10 downto 0);
           blank   : in std_logic;
			  voltage : in std_logic_vector (7 downto 0);
			  switch1  : in std_logic;
			  switch2  : in std_logic;
			  switch3  : in std_logic;
			  switch4  : in std_logic;
			  x_comp  : in unsigned (10 downto 0);
           r       : out std_logic_vector(7 downto 0);
           g       : out std_logic_vector(7 downto 0);
           b       : out std_logic_vector(7 downto 0)
			  );

end pixel_gen;

architecture Behavioral of pixel_gen is

signal voltage_sig : std_logic_vector(10 downto 0);
signal voltage_num, voltage_point : unsigned(10 downto 0);
signal logic_anal_sig : std_logic;

begin
	
	process(column, row, blank, voltage_sig, voltage_num, voltage, logic_anal_sig, switch1, switch2, switch3, switch4)
	begin
		r <= (others=>'0');
		g <= (others=>'0');
		b <= (others=>'0');
		
		voltage_sig <= "000" & voltage;
		voltage_num <= unsigned(voltage_sig);
		voltage_point <= voltage_num;
		
		if( voltage_num > 128 ) then
			logic_anal_sig <= '1';
		else
			logic_anal_sig <= '0';
		end if;
									
		
		if (blank = '0') then
			if (switch1 = '1') then
				
				if(((row > ( 390 - voltage_point )) and (row < ( 400 - voltage_point ))) and ((column > x_comp -30) and (column < x_comp + 30)) )then
					r <= (others=>'0');
					g <= (others=>'1');
					b <= (others=>'0');		
				end if;
			end if;
			if(switch2 = '1') then
			
				if( logic_anal_sig = '1' ) then

					if( (row > 95) and (row <  105 ) and ((column > x_comp -30) and (column < x_comp + 30))) then
						r <= (others=>'0');
						g <= (others=>'1');
						b <= (others=>'0');
					end if;
					
					if( (row > 220 and row < 260 ) and (column > 315 and column < 325) ) then
						r <= (others=>'1');
						g <= (others=>'1');
						b <= (others=>'1');
					end if;					
				
				else
				
					if( row > 375 and row < 385 and ((column > x_comp -30) and (column < x_comp + 30))) then
						r <= (others=>'0');
						g <= (others=>'1');
						b <= (others=>'0');
					end if;
					
					if( (row > 220 and row < 260 ) and (column > 305 and column < 335) ) then
						r <= (others=>'1');
						g <= (others=>'1');
						b <= (others=>'1');
					end if;
					
					if( (row > 230 and row < 250 ) and (column > 315 and column < 325) ) then
						r <= (others=>'0');
						g <= (others=>'0');
						b <= (others=>'0');
					end if;
				end if;
			end if;	
			if(switch3 = '1') then
			
				if( logic_anal_sig = '1' ) then

						r <= (others=>'0');
						g <= (others=>'1');
						b <= (others=>'0');
						
						if( (row > 200 and row < 280 ) and (column > 305 and column < 315) ) then
							r <= (others=>'1');
							g <= (others=>'0');
							b <= (others=>'0');
						end if;
						
						if( (row > 200 and row < 280 ) and (column > 325 and column < 335) ) then
							r <= (others=>'1');
							g <= (others=>'0');
							b <= (others=>'0');
						end if;
					
						if( (row > 235 and row < 245 ) and (column > 315 and column < 325) ) then
							r <= (others=>'1');
							g <= (others=>'0');
							b <= (others=>'0');
						end if;
					
					
				
				else
						r <= (others=>'1');
						g <= (others=>'0');
						b <= (others=>'0');
						
						if( (row > 210 and row < 270 ) and (column > 305 and column < 315) ) then
							r <= (others=>'0');
							g <= (others=>'1');
							b <= (others=>'0');
						end if;
					
						if( (row > 260 and row < 270 ) and (column > 315 and column < 335) ) then
							r <= (others=>'0');
							g <= (others=>'1');
							b <= (others=>'0');
						end if;					
					
				end if;
			end if;
			if( switch4 = '1') then
				if(((row > ( 390 - voltage_point )) ))  then
					r <= (others=>'0');
					g <= (others=>'1');
					b <= (others=>'0');		
				end if;
			
			end if;
				
			if( row > 465 or row < 15 or column < 20 or column > 620 )then
				r <= (others=>'1');
				g <= (others=>'1');
				b <= (others=>'1');
			end if;		

			
		else
			r <= (others=>'0');
			g <= (others=>'0');
			b <= (others=>'0');
		end if;
						

end process;
end Behavioral;

