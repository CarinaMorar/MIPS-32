----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/04/2022 02:36:46 PM
-- Design Name: 
-- Module Name: SSD - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
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
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity SSD is
    Port ( clk : in STD_LOGIC;
           cnt : in STD_LOGIC_VECTOR (15 downto 0);
           cat : out STD_LOGIC_VECTOR (6 downto 0);
           an : out STD_LOGIC_VECTOR (3 downto 0));
end SSD;

architecture Behavioral of SSD is
signal count: std_logic_vector(15 downto 0):= x"0000";
signal sel: std_logic_vector(1 downto 0);
signal numCurent: std_logic_vector(3 downto 0);

begin
num: process(clk) --numarator
begin
if rising_edge(clk) then
count <= count + 1;
end if;
end process;

sel <= count(15 downto 14);

anodSel : process(sel)
begin
case sel is
when "00" => an <="0111"; numCurent <= cnt(15 downto 12);
when "01" => an <="1011"; numCurent <= cnt(11 downto 8);
when "10" => an <="1101"; numCurent <= cnt(7 downto 4);
when "11" => an <="1110"; numCurent <= cnt(3 downto 0);
when others => an<="XXXX";
end case;
end process;

numAfis : process(numCurent) --numarul ce se afiseaza pe segment
begin
case numCurent is
when "0000" => cat <= "1000000"; --0
when "0001" => cat <= "1111001"; --1
when "0010" => cat <= "0100100"; --2
when "0011" => cat <= "0110000"; --3
when "0100" => cat <= "0011001";
when "0101" => cat <= "0010010";
when "0110" => cat <= "0000010";
when "0111" => cat <= "1111000";
when "1000" => cat <= "0000000";
when "1001" => cat <= "0010000"; --9
when "1010" => cat <= "0001000"; --A
when "1011" => cat <= "0000011"; --B
when "1100" => cat <= "1000110";
when "1101" => cat <= "0100001";
when "1110" => cat <= "0000110";
when "1111" => cat <= "0001110"; --F
when others => cat <= "XXXXXXX";
end case;
end process;


end Behavioral;
