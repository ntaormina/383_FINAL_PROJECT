----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    21:50:17 02/20/2014 
-- Design Name: 
-- Module Name:    Button_logic - Behavioral 
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

entity Button_logic is
	Port( clk		  : in STD_LOGIC;
			reset 	  : in STD_LOGIC;
			button_in  : in STD_LOGIC;
			button_out : out STD_LOGIC
			);
end Button_logic;

architecture Behavioral of Button_logic is

type button_type is (waiting, press, depress);
signal button_reg, button_next : button_type;
signal button, button_next_sig : std_logic;
signal count, count_next : unsigned(19 downto 0);

begin

process( clk, reset, button_next, count)
begin
	if(reset = '1') then
		count <= to_unsigned(0,20);
	elsif(rising_edge(clk)) then
		count <= count_next;
	end if;
	
	if( button_next = press) then
		count_next <= count + 1;
	else
			count_next <= to_unsigned(0,20);
	end if;
	
end process;

process(clk, reset)
begin
	if( reset ='1') then
		button_reg <= waiting;
	elsif( rising_edge(clk)) then
		button_reg <= button_next;
	end if;
end process;	

process(count, button_reg, button_in)
begin

	button_next <= button_reg;
	
	case button_reg is
		when waiting =>
			if( button_in = '1' ) then
				button_next <= press;
			end if;
		when press =>
			if(count > 55000 and button_in = '0') then
				button_next <= depress;
			end if;
		when depress =>
				button_next <= waiting;
	end case;
end process;

process(button_reg)
begin
case button_reg is
	when waiting =>
		button_next_sig <= '0';
	when press => 
		button_next_sig <= '0';
	when depress =>
		button_next_sig <= '1';
end case;
end process;

button_out <= button_next_sig;
end Behavioral;

