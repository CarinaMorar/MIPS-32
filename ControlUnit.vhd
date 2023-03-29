----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/12/2022 12:43:38 AM
-- Design Name: 
-- Module Name: ControlUnit - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity ControlUnit is
Port (
          instr: in STD_LOGIC_VECTOR (15 downto 0);
          RegDst: out STD_LOGIC ;
          ExtOp: out STD_LOGIC ;
          ALUSrc: out STD_LOGIC;
          Branch: out STD_LOGIC;
          Jump: out STD_LOGIC ;
          ALUOp: out STD_LOGIC_VECTOR (2 downto 0);
          MemWrite: out STD_LOGIC;
          MemtoReg: out STD_LOGIC;
          RegWrite: out STD_LOGIC);
end ControlUnit;

architecture Behavioral of ControlUnit is
signal funct:STD_LOGIC_VECTOR( 2 downto 0);
begin
  process(instr)
  begin
      case instr(15 downto 13) is
          when "000" => RegDst <= '1';ExtOp<='0';AluSrc<='0'; --tip R
          Branch<='0';Jump<='0'; MemWrite <= '0'; MemtoReg <= '0'; RegWrite <= '1';
          when "001" =>  RegDst <= '0';ExtOp<='1';AluSrc<='1'; --addi
           Branch<='0';Jump<='0'; MemWrite <= '0'; MemtoReg <= '0'; RegWrite <= '1';
          when "010" => RegDst <= '0';ExtOp<='0';AluSrc<='1'; --lw
           Branch<='0';Jump<='0'; MemWrite <= '0'; MemtoReg <= '1'; RegWrite <= '1';
          when "011" =>  RegDst <= '0';ExtOp<='1';AluSrc<='1'; --sw
           Branch<='0';Jump<='0'; MemWrite <= '1'; MemtoReg <= '0'; RegWrite <= '1';
          when "100" => RegDst <= '0';ExtOp<='1';AluSrc<='0'; --beq
           Branch<='1';Jump<='0'; MemWrite <= '0'; MemtoReg <= '0'; RegWrite <= '0';
          when "101" => RegDst <= '0';ExtOp<='1';AluSrc<='1'; --andi
            Branch<='0';Jump<='0'; MemWrite <= '0'; MemtoReg <= '0'; RegWrite <= '1';
          when "110" =>  RegDst <= '0';ExtOp<='0';AluSrc<='1'; --ori
            Branch<='0';Jump<='0'; MemWrite <= '0'; MemtoReg <= '0'; RegWrite <= '1';
          when "111" =>  RegDst <= '0';ExtOp<='0';AluSrc<='0'; --jump
            Branch<='0';Jump<='1'; MemWrite <= '0'; MemtoReg <= '0'; RegWrite <= '0';
      end case;
  end process;
  
   funct<=instr(2 downto 0);
  process(instr,funct)
      begin
          case instr(15 downto 13) is
              when "000" => 
                  case funct is
                     when "000" => ALUOp <= "000"; -- add
                        when "001" => ALUOp <= "001"; -- sub
                        when "010" => ALUOp <= "010"; -- or
                        when "011" => ALUOp <= "011"; -- and
                        when "100" => ALUOp <= "100"; -- sll
                        when "101" => ALUOp <= "101"; -- xor
                        when "110" => ALUOp <= "110"; -- srl
                        when "111" => ALUOp <= "111"; -- nor
                  end case;
              when "001" => ALUOp <= "000"; -- addi
              when "010" => ALUOp <= "000"; -- lw(tot un add)
              when "011" => ALUOp <= "000"; -- sw(tot un add)
              when "100" => ALUOp <= "001"; -- beq( un sub)
              when "101" => ALUOp <= "011"; 
              when "110" => ALUOp <= "010"; 
              when "111" => ALUOp <= "000"; 
          end case;
      end process;
  

end Behavioral;