----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    19:37:28 02/13/2014 
-- Design Name: 
-- Module Name:    h_sync_gen - Behavioral 
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

entity h_sync_gen is
    port ( clk		   : in std_logic;
           reset     : in std_logic;
           h_sync    : out std_logic;
           blank     : out std_logic;
           completed : out std_logic;
           column    : out unsigned(10 downto 0)
     );
end h_sync_gen;


architecture Behavioral of h_sync_gen is

	type h_sync_type is (active_video, front_porch, sync_pulse, back_porch, completed_state);
	signal count_reg, count_next: unsigned(10 downto 0);
	signal state_reg, state_next: h_sync_type;

begin

	process(clk, reset)
	begin	

		if(reset = '1') then
			state_reg <= active_video;
		elsif (rising_edge(clk)) then
			state_reg <= state_next;
		end if;	

	end process;	
	
	process(count_reg, state_reg)
	begin

		state_next <= state_reg;

		case state_reg is
			when active_video=>
				if(count_reg = 640) then
					state_next <= front_porch;	
				end if;	
			when front_porch=>
				if(count_reg = 14) then
					state_next <= sync_pulse;	
				end if;	
			when sync_pulse=>
				if(count_reg = 96) then
					state_next <= back_porch;	
				end if;	
			when back_porch=>
				if(count_reg = 45) then
					state_next <= completed_state;	
				end if;	
			when completed_state=>	
				state_next <= active_video;

		end case;
	end process;	
	
	process(clk, reset)
	begin

		if (reset = '1') then
			count_reg <= (others => '0');
		elsif (rising_edge(clk)) then
			count_reg <= count_next;
		end if;
	end process;

	process(count_reg, state_reg)
	begin
		if(state_reg /= state_next) then
			count_next <= "00000000000";	
		else
			count_next <= count_reg + "00000000001" ;

		end if;	
	end process;
	
	process(state_next, count_next)
	begin

		h_sync <= '1';
		blank <= '1';
		completed <= '0';
		column <= (others =>'0');
		case state_next is
			when active_video=>
				column <= count_next;
				blank <= '0';
			when front_porch=>
			when sync_pulse=>
				h_sync <= '0';
			when back_porch=>
			when completed_state=>
				completed <= '1';
		end case;
	end process;	


end Behavioral;

