----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    10:03:23 02/12/2014 
-- Design Name: 
-- Module Name:    atlys_lab_video - Behavioral 
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
use IEEE.NUMERIC_STD.ALL;
library UNISIM;
use UNISIM.VComponents.all;


entity atlys_lab_video is
    port (
             clk : in std_logic; -- 100 MHz
             reset : in std_logic;
				 up : in std_logic;
				 switch1 : in std_logic;
				 switch2 : in std_logic;
				 switch3 : in std_logic;
				 switch4 : in std_logic;
				 down : in std_logic;
				 adc_in : in std_logic_vector(7 downto 0);
             tmds : out std_logic_vector(3 downto 0);
             tmdsb : out std_logic_vector(3 downto 0)
         );


end atlys_lab_video;



architecture Mordan of atlys_lab_video is


	
COMPONENT pixel_gen
	PORT(
		row     : IN unsigned(10 downto 0);
		column  : IN unsigned(10 downto 0);
		blank   : IN std_logic;
		x_comp  : IN unsigned(10 downto 0);
		voltage : IN std_logic_vector(7 downto 0);
		switch1  : IN std_logic;
		switch2  : IN std_logic;
		switch3  : IN std_logic;
		switch4  : IN std_logic;
		r 		  : OUT std_logic_vector(7 downto 0);
		g 		  : OUT std_logic_vector(7 downto 0);
		b       : OUT std_logic_vector(7 downto 0)
		);
END COMPONENT;

COMPONENT vga_sync
	PORT(
		clk         : IN std_logic;
		reset       : IN std_logic;
		h_sync      : OUT std_logic;
		v_sync      : OUT std_logic;
		v_completed : OUT std_logic;
		blank       : OUT std_logic;
		row		   : OUT unsigned(10 downto 0);
		column 		: OUT unsigned(10 downto 0)
	);
END COMPONENT;

COMPONENT pong_control 
	port(
			clk		     :in std_logic;
			reset			  :in std_logic;
			v_completed	  :in std_logic;
			x_pos 		  :out unsigned(10 downto 0)
			);
END COMPONENT;


signal row_connector, column_connector, x_pos_sig : unsigned(10 downto 0);

signal red_sig, green_sig, blue_sig : std_logic_vector(7 downto 0);
signal voltage_sig : unsigned (7 downto 0);
signal completed_connector, pixel_clk, serialize_clk, serialize_clk_n, h_sync_sig, v_sync_sig, v_completed, blank_sig, red_s, green_s, blue_s, clock_s:std_logic;
begin

    -- Clock divider - creates pixel clock from 100MHz clock
    inst_DCM_pixel: DCM
    generic map(
                   CLKFX_MULTIPLY => 2,
                   CLKFX_DIVIDE => 8,
                   CLK_FEEDBACK => "1X"
               )
    port map(
                clkin => clk,
                rst => reset,
                clkfx => pixel_clk
            );

    -- Clock divider - creates HDMI serial output clock
    inst_DCM_serialize: DCM
    generic map(
                   CLKFX_MULTIPLY => 10, -- 5x speed of pixel clock
                   CLKFX_DIVIDE => 8,
                   CLK_FEEDBACK => "1X"
               )
    port map(
                clkin => clk,
                rst => reset,
                clkfx => serialize_clk,
                clkfx180 => serialize_clk_n
            );


    -- TODO: VGA component instantiation
	Inst_vga_sync: vga_sync PORT MAP(
		clk => pixel_clk,
		reset => reset,
		h_sync => h_sync_sig,
		v_sync => v_sync_sig,
		v_completed => completed_connector,
		blank => blank_sig,
		row => row_connector,
		column => column_connector
);

    -- TODO: Pixel generator component instantiation
	Inst_pixel_gen: pixel_gen PORT MAP(
	row => row_connector,
	column => column_connector,
	blank => blank_sig,
	voltage => adc_in,
	switch1 => switch1,
	switch2 => switch2,
	switch3 => switch3,
	switch4 => switch4,
	x_comp => x_pos_sig,
	r => red_sig,
	g => green_sig,
	b => blue_sig
);

	Inst_pong_control: pong_control PORT MAP(
		clk => pixel_clk,
		reset => reset,
		v_completed => completed_connector,
		x_pos => x_pos_sig
		);
		
    -- Convert VGA signals to HDMI (actually, DVID ... but close enough)
    inst_dvid: entity work.dvid
    port map(
                clk => serialize_clk,
                clk_n => serialize_clk_n,
                clk_pixel => pixel_clk,
                red_p => red_sig,
                green_p => green_sig,
                blue_p => blue_sig,
                blank => blank_sig,
                hsync => h_sync_sig,
                vsync => v_sync_sig,
                -- outputs to TMDS drivers
                red_s => red_s,
                green_s => green_s,
                blue_s => blue_s,
                clock_s => clock_s
            );

    -- Output the HDMI data on differential signalling pins
    OBUFDS_blue : OBUFDS port map
        ( O => TMDS(0), OB => TMDSB(0), I => blue_s );
    OBUFDS_red : OBUFDS port map
        ( O => TMDS(1), OB => TMDSB(1), I => green_s );
    OBUFDS_green : OBUFDS port map
        ( O => TMDS(2), OB => TMDSB(2), I => red_s );
    OBUFDS_clock : OBUFDS port map
        ( O => TMDS(3), OB => TMDSB(3), I => clock_s );

end Mordan;

