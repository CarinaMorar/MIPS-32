----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/04/2022 02:36:46 PM
-- Design Name: 
-- Module Name: test_env - Behavioral
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

entity test_env is
    Port ( clk : in STD_LOGIC;
           btn : in STD_LOGIC_VECTOR (4 downto 0);
           sw : in STD_LOGIC_VECTOR (15 downto 0);
           led : out STD_LOGIC_VECTOR (15 downto 0);
           an : out STD_LOGIC_VECTOR (3 downto 0);
           cat : out STD_LOGIC_VECTOR (6 downto 0));
end test_env;

architecture Behavioral of test_env is

component MPG is
    Port ( btn : in STD_LOGIC;
           clk : in STD_LOGIC;
           en : out STD_LOGIC);
end component;

component SSD is
    Port ( clk : in STD_LOGIC;
           cnt : in STD_LOGIC_VECTOR (15 downto 0);
           cat : out STD_LOGIC_VECTOR (6 downto 0);
           an : out STD_LOGIC_VECTOR (3 downto 0));
end component;

--component ALU is
    --Port ( input : in STD_LOGIC_VECTOR (7 downto 0);
     --      sel : in STD_LOGIC_VECTOR (1 downto 0);
     --      output: out std_logic_vector(15 downto 0));
--end component;

component InstructionF is
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
end component;

component InstructionDecode is
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
end component;

component ControlUnit is
Port (    instr: in STD_LOGIC_VECTOR (15 downto 0);
          RegDst: out STD_LOGIC ;
          ExtOp: out STD_LOGIC ;
          ALUSrc: out STD_LOGIC;
          Branch: out STD_LOGIC;
          Jump: out STD_LOGIC ;
          ALUOp: out STD_LOGIC_VECTOR (2 downto 0);
          MemWrite: out STD_LOGIC;
          MemtoReg: out STD_LOGIC;
          RegWrite: out STD_LOGIC);
end component;

component ALUComp is
 Port ( RD1 : in STD_LOGIC_VECTOR (15 downto 0);
          RD2 : in STD_LOGIC_VECTOR (15 downto 0);
          ALUSrc : in STD_LOGIC;
          Ext_Imm : in STD_LOGIC_VECTOR (15 downto 0);
          sa : in STD_LOGIC;
          func : in STD_LOGIC_VECTOR (2 downto 0);
          ALUOp : in STD_LOGIC_VECTOR (2 downto 0);
          Zero : inout STD_LOGIC;
          Lower: out STD_LOGIC;
          ALURes: inout STD_LOGIC_VECTOR(15 downto 0));
end component;

signal en:STD_LOGIC;
signal cnt:STD_LOGIC_VECTOR(15 downto 0);
signal start:STD_LOGIC_VECTOR(7 downto 0);
signal output1:STD_LOGIC_VECTOR(15 downto 0);

--IF
signal jumpAdr:STD_LOGIC_VECTOR(15 downto 0);
signal rst:STD_LOGIC;
signal instr:STD_LOGIC_VECTOR(15 downto 0);
signal nextInstr:STD_LOGIC_VECTOR(15 downto 0);

signal digits:STD_LOGIC_VECTOR(15 downto 0);

--ID
signal Pcinc,sum,RD1,RD2,ext_imm,ext_func,ext_sa: STD_LOGIC_VECTOR(15 downto 0);
signal func : STD_LOGIC_VECTOR(2 downto 0);
signal sa : STD_LOGIC;

--UC
signal RegDst: STD_LOGIC;
signal ExtOp: STD_LOGIC;
signal RegWrite: STD_LOGIC;
signal ALUOp: STD_LOGIC_VECTOR(2 downto 0);
signal MemtoReg: STD_LOGIC;
signal MemWrite: STD_LOGIC;
signal ALUSrc : STD_LOGIC;
signal Branch : STD_LOGIC;
signal Jump : STD_LOGIC;



type ROM_type is array(0 to 255) of STD_LOGIC_VECTOR (15 downto 0);
--signal ROM: ROM_type :=(x"0123",x"1457",x"789A", others=>x"0012");
--signal R_D : std_logic_vector (15 downto 0);


begin
--mapari 
mpg1 : MPG port map (btn(0),clk,en);
mpg2 : MPG port map (btn(1),clk,rst);
--ssd1 : SSD port map (clk,output1,cat,an);
instrF : InstructionF port map (x"0012",x"0013",'0','0',clk,rst,en,instr,NextInstr);
instrD : InstructionDecode port map(clk,en,instr(12 downto 0),x"0004",RegWrite,RegDst,ExtOp,RD1,RD2,ext_imm,func,sa);
contrU : ControlUnit port map(instr,RegDst,ExtOp,ALUSrc,Branch,Jump,ALUOp,MemWrite,MemtoReg,RegWrite);

--alu1: ALU port map (start,cnt,output1);

--R_D<=ROM(conv_integer(cnt));

--process(clk,sw)
--begin
--led<=sw;
--if rising_edge(clk) then
--    if en='1' then
--        if sw(15)='1' then
--        cnt<=cnt +1;
--        elsif sw(15)='0' then
--        cnt<=cnt-1;
--        end if;
--    end if;
--end if;
--end process;

with sw(2 downto 0) select
digits<= instr when "000",
        nextInstr when "001",
      --  rd1 when "010",
      --  rd2 when "011",
      --  ALUOut when "100",
      --  Ext_Imm when "101",
      --  MemData when "110",
      --BranchAddress when "111",
      -- WriteData when "111",
        (others => 'X') when others;
         display : SSD port map (clk,digits,cat,an);


led(10 downto 0)<= ALUOp & RegDst & ExtOp & ALUSrc & Branch & Jump & MemWrite &MemtoReg & RegWrite; 

end Behavioral;
