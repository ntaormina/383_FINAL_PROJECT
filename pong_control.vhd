----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    21:51:18 02/18/2014 
-- Design Name: 
-- Module Name:    pong_control - Behavioral 
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

entity pong_control is
	port(
			clk		     :in std_logic;
			reset			  :in std_logic;
			up				  :in std_logic;
			down			  :in std_logic;
			switch		  :in std_logic;
			v_completed	  :in std_logic;
			ball_x		  :out unsigned(10 downto 0);
			ball_y		  :out unsigned(10 downto 0);
			paddle_y		  :out unsigned(10 downto 0)
			);
end pong_control;

architecture Behavioral of pong_control is

COMPONENT Button_logic
	port(
			clk	     :in std_logic;
			reset	     : in std_logic;
			button_in  :in std_logic;
			button_out :out std_logic
			);
END COMPONENT;

type pong_type is(moving, hit_top, hit_right, hit_bottom, hit_paddle_top, hit_paddle_bottom, lose_state);

signal state_reg, state_next: pong_type;
signal speed, paddle_next: unsigned(10 downto 0);
signal paddle_reg, ball_x_pos, ball_y_pos, ball_x_pos_next, ball_y_pos_next: unsigned(10 downto 0);
signal count_reg, count_next: unsigned(10 downto 0);
signal up_pulse, down_pulse, x_dir, x_next, y_dir, y_next, lose, lose_next: std_logic;

begin

Inst_up_Button_logic: Button_logic
	PORT MAP(
					clk => clk,
					reset => reset,
					button_in => up,
					button_out => up_pulse
				);
			
Inst_down_Button_logic: Button_logic
		PORT MAP(
						clk => clk,
						reset => reset,
						button_in => down,
						button_out => down_pulse
					);

process( clk, reset)
begin
		if( reset= '1') then
			paddle_reg <= "00010010000";
		elsif(rising_edge(clk)) then
			paddle_reg <= paddle_next;
		end if;
end process;

process(up_pulse, down_pulse, paddle_reg, paddle_next)
begin
	paddle_next <= paddle_reg;
	
	if(up_pulse = '1' and paddle_reg > 55) then
		paddle_next <= paddle_reg -10;
	elsif( down_pulse ='1' and paddle_reg < 430) then
		paddle_next <= paddle_reg+10;
	end if;
end process;

process( clk, reset)
begin
	if( reset = '1' ) then
		count_reg <= (others=>'0');
	elsif(rising_edge(clk)) then
		count_reg <= count_next;
	end if;
end process;


speed <= to_unsigned(300, 11) when switch = '1' else
												to_unsigned(550,11);

count_next <= (others=>'0') when count_reg >= speed else
											count_reg + 1 when v_completed = '1' else
											count_reg;


process(clk, reset)
	begin
		if(reset='1') then
			state_reg <= moving;
		elsif(rising_edge(clk)) then
				state_reg <= state_next;
		end if;
end process;

process(clk, reset)
begin
		if(reset ='1') then
			ball_x_pos <= "00010000000";
			ball_y_pos <= "00010100000";
		elsif(rising_edge(clk)) then
			ball_x_pos <= ball_x_pos_next;
			ball_y_pos <= ball_y_pos_next;
		end if;
end process;

process(clk, reset)
begin
	if(reset = '1') then
		x_dir <= '1';
		y_dir <= '1';
		lose <= '0';
	elsif(rising_edge(clk)) then
		x_dir <= x_next;
		y_dir <= y_next;
		lose <= lose_next;
	end if;
end process;

process( state_reg, state_next, count_next, ball_x_pos, ball_y_pos, state_reg, paddle_reg)
begin
	state_next <= state_reg;

	 if( count_next = 0) then
		case state_reg is
			when moving =>
				if(ball_x_pos - 7 = 0) then
					state_next <= lose_state;
				end if;
				if(ball_x_pos + 5 = 640) then
					state_next <= hit_right;
				end if;
				if(ball_y_pos -5 = 0) then
					state_next <= hit_top;
				end if;
				if(ball_y_pos +5 = 480) then
					state_next <= hit_bottom;
				end if;
				if(ball_x_pos - 5 = 16 and ball_y_pos > (paddle_reg - 50) and ball_y_pos < (paddle_reg) ) then
					state_next <= hit_paddle_top;
				end if;
				if(ball_x_pos - 5 = 16 and ball_y_pos > (paddle_reg) and ball_y_pos < (paddle_reg +50) ) then
					state_next <= hit_paddle_bottom;
				end if;
				
				when hit_top =>
					state_next <= moving;
				when hit_bottom =>
					state_next <= moving;
				when hit_right =>
					state_next <= moving;
				when hit_paddle_top =>
					state_next <= moving;
				when hit_paddle_bottom =>
					state_next <= moving;
				when lose_state=>
		end case;
	end if;
end process;

process(count_next, v_completed, ball_x_pos, ball_y_pos, lose)
begin
	ball_x_pos_next <= ball_x_pos;
	ball_y_pos_next <= ball_y_pos;
	
	if(count_next = 0 and v_completed ='1' and lose='0') then
		if(x_dir = '1') then ball_x_pos_next <= ball_x_pos +1;
		else ball_x_pos_next <= ball_x_pos -1;
		end if;
		if(y_dir = '1') then
			ball_y_pos_next <= ball_y_pos - 1;
		else
			ball_y_pos_next <= ball_y_pos + 1;
		end if;
	end if;
end process;

process( state_reg, ball_x_pos, ball_y_pos, state_next, count_next, lose)
begin
	x_next <= x_dir;
	y_next <= y_dir;
	lose_next <= lose;

	if(count_next = 0) then
	case state_reg is
		when moving =>
			x_next <= x_dir;
			y_next <= y_dir;
		when hit_top =>
			y_next <= '0';
		when hit_right =>
			x_next <= '0';
		when hit_bottom =>
			y_next <= '1';
		when hit_paddle_top =>
			y_next <= '0';
			x_next <= '1';
		when hit_paddle_bottom =>
			y_next <= '1';
			x_next <= '1';
		when lose_state =>
			lose_next <= '1';
			x_next <= '1';
	end case;
	end if;
end process;

paddle_y <= paddle_reg;
ball_x <= ball_x_pos;
ball_y <= ball_y_pos;
					


end Behavioral;

