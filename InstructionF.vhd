----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/11/2022 05:26:13 PM
-- Design Name: 
-- Module Name: InstructionF - Behavioral
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

entity InstructionF is
 Port ( 
        JumpAdr : in STD_LOGIC_VECTOR (15 downto 0);
        BranchAdr : in STD_LOGIC_VECTOR (15 downto 0);
        Jump : in STD_LOGIC;
        PCSrc : in STD_LOGIC;
        CLK : in STD_LOGIC;
        RESET : in STD_LOGIC;
        EN : in STD_LOGIC;
        Instruction : out STD_LOGIC_VECTOR (15 downto 0);
        NextInstruction : out STD_LOGIC_VECTOR (15 downto 0)      
 );
end InstructionF;

architecture Behavioral of InstructionF is

type ROM_type is array (0 to 255) of STD_LOGIC_VECTOR (15 downto 0);

--signal ROM: ROM_TYPE := (
--b"000_011_010_001_0_000",--add $1 $3 $2    
--b"000_010_101_100_0_001",--sub $4 $2 $5    
--b"000_011_000_111_1_100",--sll $7 $3 1     
--b"000_010_000_110_1_101",--srl $6 $2 1     
--b"000_111_001_011_0_010",--and $3 $7 $2    
--b"000_001_010_011_0_011",--or $3 $1 $2     

--b"000_001_010_011_0_011",--sra $3 $1 2    
--b"000_110_101_010_0_111",-- nor $2 $6 $5  

--b"001_000_010_0000001",-- addi $2 $0 1     
--b"010_010_110_0000010",-- lw $6 $2 2       
--b"011_011_010_0000001",-- sw $2 $3 1        
--b"100_101_000_0000010",-- beq $0 $5 2    

--b"101_011_001_0000100",-- ori $1 $3 4      
--b"110_101_010_0000001",-- subi $2 $5 1    
--b"111_0000000000001",-- j 1              
--others => x"0000");


signal ROM: ROM_TYPE := (
0 => b"001_000_001_0001010", 		--addi $1 $0 10      208A
1 => b"001_000_010_0000000", 		--addi $2 $0 0       2100
2 => b"001_000_011_0000010",		--addi $3 $0 2       2182
3 => b"000_010_001_010_0_000",		--add $2 $2 $1       08A0
4 => b"000_001_011_001_0_001", 		--sub $1 $1 $3       0591
5 => b"100_000_001_0000010",		--beq $1 $0 2        8082
6 => b"111_0000000000100", 			--j 4                E004
7 => b"011_100_010_0000000", 		--sw $2 0($4)        7100
8 => b"010_101_010_0000000", 		--lw $2 0($5)        5500
others => x"0000");

signal PCIn: STD_LOGIC_VECTOR (15 downto 0);
signal PCOut: STD_LOGIC_VECTOR (15 downto 0);
signal MUXBranch: STD_LOGIC_VECTOR (15 downto 0);

begin
process(EN, RESET, CLK)
begin 
 if (RESET = '1') then 
       PCOut <= x"0000";
   else if (EN = '1' and rising_edge(CLK)) then 
       PCOut <= PCIn;
       end if;
   end if;
end process;

Instruction <= ROM(conv_integer(PCOut));
NextInstruction <= PCOut + 1;

MUXBranch <= (PCOut + 1) when PCSrc = '0' else BranchAdr;
PCIn <= MUXBranch when Jump = '0' else JumpAdr;

end Behavioral;
