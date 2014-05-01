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
			  ball_x	 : in unsigned (10 downto 0);
			  ball_y	 : in unsigned (10 downto 0);
			  paddle_y: in unsigned (10 downto 0);
           r       : out std_logic_vector(7 downto 0);
           g       : out std_logic_vector(7 downto 0);
           b       : out std_logic_vector(7 downto 0)
			  );

end pixel_gen;

architecture Behavioral of pixel_gen is

begin

	process(column, row, blank)
	begin
		r <= (others=>'0');
		g <= (others=>'0');
		b <= (others=>'0');
		
		if (blank = '0') then
			if( column > (ball_x - 5) and column < (ball_x + 5 ) and row > (ball_y - 5) and row < (ball_y + 5 ))then
				r <= (others=>'1');
				g <= (others=>'0');
				b <= (others=>'0');
			end if;
			if( column > 0 and column < 15 and row > (paddle_y - 50) and row < (paddle_y + 50)) then
				r <= (others=>'0');
				g <= (others=>'1');
				b <= (others=>'0');
			end if;
			if( column > 230 and column < 246 and row > 150 and row < 276) then
				r <= (others=>'0');
				g <= (others=>'0');
				b <= (others=>'1');
			end if;
			if( column > 264 and column < 281 and row > 150 and row < 276) then
				r <= (others=>'0');
				g <= (others=>'0');
				b <= (others=>'1');	
			end if;
			if( column > 244 and column < 276 and row > 150 and row < 176) then
				r <= (others=>'0');
				g <= (others=>'0');
				b <= (others=>'1');
			end if;
			if( column > 244 and column < 276 and row > 200 and row < 226) then
				r <= (others=>'0');
				g <= (others=>'0');
				b <= (others=>'1');
			end if;
			if( column > 309 and column < 361 and row > 200 and row < 226) then
				r <= (others=>'0');
				g <= (others=>'0');
				b <= (others=>'1');
			end if;
			if( column > 309 and column < 326 and row > 224 and row < 325) then
				r <= (others=>'0');
				g <= (others=>'0');
				b <= (others=>'1');
			end if;
			if(column > 324 and column < 351 and row > 249 and row < 266) then
				r <= (others=>'0');
				g <= (others=>'0');
				b <= (others=>'1');
			end if;
		else
			r <= (others=>'0');
			g <= (others=>'0');
			b <= (others=>'0');
		end if;
						

end process;
end Behavioral;

