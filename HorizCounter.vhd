----------------------------------------------------------------------------------

-- Engineer: C2C Taormina

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

entity pong_control is
	port(
			clk		     :in std_logic;
			reset			  :in std_logic;			
			v_completed	  :in std_logic;
			x_pos 		  :out unsigned(10 downto 0)
			);
end pong_control;

architecture Behavioral of pong_control is

signal count_reg, count_next, x_counter: unsigned(10 downto 0);
signal count_reg_1, count_next_1: unsigned(21 downto 0);


begin



process( clk, reset)
begin
	if( reset = '1' ) then
		count_reg <= (others=>'0');
	elsif(rising_edge(clk)) then
		count_reg <= count_next;
	end if;
end process;




count_next <= (others=>'0') when count_reg >= to_unsigned(620,11) else
											count_reg + 1 when v_completed = '1' else
											count_reg;
											
							

x_pos <= count_next;

end Behavioral;

