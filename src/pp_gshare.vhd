----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/31/2025 10:00:35 AM
-- Design Name: 
-- Module Name: pp_gshare - Behavioral
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


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.pp_types.all;
use work.pp_csr.all;
use work.pp_utilities.all;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity pp_gshare is
    generic (
        N : integer := 4;  -- History register size
        PHT_SIZE : integer := 16  -- Pattern History Table size (2^N)
    );
    port (
        clk : in std_logic;
        reset : in std_logic;
        
        -- Instruction Fetch (IF) signals 
        if_instruction_address : in std_logic_vector(31 downto 0); -- address of instruction from IF
        if_branch_instruction : in std_logic; -- bit that indicates if a branch instruction has entered the IF stage
        prediction : out std_logic;
        
        -- Execute (EX) signals
        ex_instruction_address : in std_logic_vector(31 downto 0); -- address of instruction from EX
        ex_branch_instruction : in std_logic; -- bit that indicates if a branch instruction has entered the EX stage
        ex_actual_taken : in std_logic; -- Branch instruction actual outcome
        flush : out std_logic
        
    );
end pp_gshare;

architecture Behavioral of pp_gshare is
    -- Global History Register
    signal GHR : std_logic_vector(N-1 downto 0) := (others => '0');

    -- Pattern History Table
    type PHT_Array is array (0 to PHT_SIZE-1) of std_logic_vector(1 downto 0);
    signal PHT : PHT_Array := (others => "10");  -- Initialize to weakly taken

    signal index : integer range 0 to PHT_SIZE-1;
    
begin

    index <= to_integer(unsigned(if_instruction_address XOR GHR)); -- Calculate index (XOR of PC and GHR)
    
    predict: process(clk)
    begin
        if rising_edge(clk) then
            if reset = '1' then
                GHR <= (others => '0');
            elsif if_branch_instruction = '1' then
                prediction <= PHT(index)(1); -- MSB of PHT entry used for prediction
            end if;
        end if;
    
    end process predict;
    
    update: process(clk)
    begin
        if rising_edge(clk) then
            if reset = '1' then
                GHR <= (others => '0');
                PHT <= (others => "10");
            elsif ex_branch_instruction = '1' then
                if ex_actual_taken = PHT(index)(1) then -- prediction was correct.
                    flush <= '0';
                else -- prediction was incorrect
                    flush <= '1';
                end if;
                if ex_actual_taken = '1' then
                    if PHT(index) /= "11" then
                        PHT(index) <= std_logic_vector(unsigned(PHT(index)) + 1);
                    end if;
                else
                    if PHT(index) /= "00" then
                        PHT(index) <= std_logic_vector(unsigned(PHT(index)) - 1);
                    end if;
                end if;
                GHR <= GHR(N-2 downto 0) & ex_actual_taken;
            end if;
        end if;   
  
    end process update;
    


end Behavioral;
