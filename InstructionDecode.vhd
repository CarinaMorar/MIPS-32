----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/11/2022 10:17:18 PM
-- Design Name: 
-- Module Name: InstructionDecode - Behavioral
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
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity InstructionDecode is
 Port (
      clk: in STD_LOGIC;
            en : in STD_LOGIC;    
            Instr : in STD_LOGIC_VECTOR(12 downto 0);
            WD : in STD_LOGIC_VECTOR(15 downto 0);
            RegWrite : in STD_LOGIC;
            RegDst : in STD_LOGIC;
            ExtOp : in STD_LOGIC;
            RD1 : out STD_LOGIC_VECTOR(15 downto 0);
            RD2 : out STD_LOGIC_VECTOR(15 downto 0);
            Ext_Imm : out STD_LOGIC_VECTOR(15 downto 0);
            func : out STD_LOGIC_VECTOR(2 downto 0);
            sa : out STD_LOGIC        
);
end InstructionDecode;

architecture Behavioral of InstructionDecode is
signal wa: STD_LOGIC_VECTOR (2 downto 0);

type reg_array is array (0 to 7) of STD_LOGIC_VECTOR (15 downto 0);
signal reg_file: reg_array := (others=>x"0000");--initial pun 0 peste tot

begin

process(RegDst)--MUX-ul acela mic e aici
begin
    if RegDst = '1' then
        wa <= Instr(6 downto 4);
    else
        wa <= Instr(9 downto 7);
    end if;
end process;

--partea de scriere(care e sincrona) in RF e acoperita aici
process(clk)
begin
    if rising_edge(clk) then
        if RegWrite = '1' then
            reg_file(conv_integer(wa)) <= wd;
        end if;
    end if;
end process;

--partea de citire in RF e acoperita aici
RD1 <= reg_file(conv_integer(Instr(12 downto 10)));
RD2 <= reg_file(conv_integer(Instr(9 downto 7)));


func <= Instr(2 downto 0);
sa <= Instr(3);

process(ExtOp)--aici stabilim cn e ExtImm
begin
    if ExtOp = '1' then
        Ext_Imm <= "11111111" & Instr(7 downto 0);
    else
        Ext_Imm <= "00000000" & Instr(7 downto 0);
     end if;
end process;


end Behavioral;