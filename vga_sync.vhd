----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    10:35:23 02/12/2014 
-- Design Name: 
-- Module Name:    vga_sync - Behavioral 
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
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
library UNISIM;
use UNISIM.VComponents.all;

entity vga_sync is
    port ( 
			  clk 		  : in std_logic;
           reset 		  : in std_logic;
           h_sync 	  : out std_logic;
           v_sync   	  : out std_logic;
           v_completed : out std_logic;
           blank 		  : out std_logic;
           row 		  : out unsigned(10 downto 0);
           column 	  : out unsigned(10 downto 0)
     );
end vga_sync;

architecture Behavioral of vga_sync is

COMPONENT h_sync_gen
	PORT(
		clk 		 : IN std_logic;
		reset 	 : IN std_logic;
		h_sync 	 : OUT std_logic;
		blank 	 : OUT std_logic;
		completed : OUT std_logic;
		column 	 : OUT unsigned(10 downto 0)
);
END COMPONENT;

COMPONENT v_sync_gen
	PORT(
		clk 			: IN std_logic;
		reset 		: IN std_logic;
		h_blank 		: IN std_logic;
		h_completed : IN std_logic;
		v_sync 		: OUT std_logic;
		blank 		: OUT std_logic;
		completed 	: OUT std_logic;
		row			: OUT unsigned(10 downto 0)
);
END COMPONENT;

signal horiz_blank, vert_blank, completed_connector : std_logic;

begin


Inst_h_sync_gen: h_sync_gen 
	PORT MAP(
		clk => 	  	 clk,
		reset => 	 reset,
		h_sync =>	 h_sync,
		blank => 	 horiz_blank,
		completed => completed_connector,
		column => 	 column
	);	

Inst_v_sync_gen: v_sync_gen 
	PORT MAP(
		clk => 			clk,
		reset => 		reset,
		h_blank => 		horiz_blank,
		h_completed => completed_connector,
		v_sync => 		v_sync,
		blank => 		vert_blank,
		completed => 	v_completed,
		row => 			row
	);

blank <=(vert_blank or horiz_blank);

end Behavioral;