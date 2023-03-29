----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/12/2022 10:57:27 PM
-- Design Name: 
-- Module Name: ALUComp - Behavioral
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

entity ALUComp is
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
end ALUComp;

architecture Behavioral of ALUComp is

signal ALUCtrl : STD_LOGIC_VECTOR(2 downto 0);
signal muxOut: STD_LOGIC_VECTOR(15 downto 0);
signal auxALURes: STD_LOGIC_VECTOR(15 downto 0);

begin

process (ALUOp, func, sa)
begin 
    case ALUOp is
        when "000" => ---tip R
            if (func = "000") then
                     ALUCtrl <= "000"; 
            end if;
            if (func = "001") then
                    ALUCtrl <= "001";    
            end if;
            if (func = "010") then 
                    ALUCtrl <= "010";   
            end if;
            if (func = "011") then 
                    ALUCtrl <= "011";   
            end if;
            if (func = "100") then 
                    ALUCtrl <= "100";   
            end if;
            if (func = "101") then 
                    ALUCtrl <= "101";   
            end if;
            if (func = "110") then 
                    ALUCtrl <= "110";   
            end if;
            if (func = "111") then 
                    ALUCtrl <= "111";   
            end if;
         when "001" => ALUCtrl <= "000";   
         when "010" => ALUCtrl <= "000";   
         when "011" => ALUCtrl <= "000";   
         when "100" => ALUCtrl <= "001";   
         when "101" => ALUCtrl <= "110";   
         when "110" => ALUCtrl <= "001";   
         when others => ALUCtrl <= "000";
    end case;

end process;

muxOut <= RD2 when ALUSrc = '0' else Ext_Imm;

process (ALUCtrl, muxOut, RD1, auxALURes)
begin 
    case ALUCtrl is 
        when "000" => auxALURes <= RD1 + muxOut;
        when "001" => auxALURes <= RD1 - muxOut;
        when "010" => auxALURes <= RD1(14 downto 0) & "0";
        when "011" => auxALURes <= "0" & RD1(15 downto 1);
        when "100" => auxALURes <= RD1 and muxOut;
        when "101" => auxALURes <= RD1 xor muxOut; 
        when "110" => auxALURes <= RD1 - muxOut;
        when "111" => auxALURes <= RD1(7 downto 0) * muxOut(7 downto 0);
     end case;
     
     ALURes <= auxALURes;
end process;

process(RD1, muxOut, zero)
begin
    if RD1 = muxOut then
        zero <= '1';
    else zero <= '0';
    end if;
end process;

Lower <= '1' when auxALURes < x"0000" else '0';

end Behavioral;
