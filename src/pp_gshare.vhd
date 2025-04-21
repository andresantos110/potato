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
        PHT_SIZE : integer := 16;  -- Pattern History Table size (2^N)
        RESET_ADDRESS : std_logic_vector(31 downto 0)
    );
    port (
        clk : in std_logic;
        reset : in std_logic;
        enable : in std_logic;
        
        -- Instruction Fetch (IF) signals 
        if_instruction_address : in std_logic_vector(31 downto 0); -- address of instruction from IF
        if_instruction : in std_logic_vector(31 downto 0); -- instruction from IF
        pc_ready : out std_logic;
        out_pc : out std_logic_vector(31 downto 0);
        
        -- Execute (EX) signals
        ex_instruction_address : in std_logic_vector(31 downto 0); -- address of instruction from EX
        ex_immediate : in std_logic_vector(31 downto 0);
        ex_branch : in branch_type; -- variable that indicates a conditional branch instruction is in the EX stage
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

    signal if_index : integer range 0 to PHT_SIZE-1;
    signal ex_index : integer range 0 to PHT_SIZE-1;
    signal if_immediate: std_logic_vector(31 downto 0);
    
--    signal pc_add_if : std_logic;
--    signal pc_add_ex : std_logic;
--    signal pc_next_if : std_logic;
--    signal pc_next_ex : std_logic;

begin

    if_index <= to_integer(unsigned(if_instruction_address(3 downto 0) XOR GHR)); -- Calculate index for prediction(XOR of PC and GHR)
    ex_index <= to_integer(unsigned(ex_instruction_address(3 downto 0) XOR GHR)); -- Calculate index for prediction(XOR of PC and GHR)
    if_immediate <= (31 downto 12 => if_instruction(31)) & if_instruction(7) & if_instruction(30 downto 25) & if_instruction(11 downto 8) & '0'; -- decode immediate
    
    gshare: process(clk)
    begin
        if rising_edge(clk) then
            pc_ready <= '0';
            flush <= '0';
            if reset = '1' then
                    GHR <= (others => '0');
                    PHT <= (others => "10");
                    out_pc <= RESET_ADDRESS;
            end if;
            if enable = '1' then
                pc_ready <= '0';
                if if_instruction(6 downto 2) = b"11000" then -- branch instruction on IF - predict
                    if PHT(if_index)(1) = '1' then -- predict TAKEN
                         out_pc <= std_logic_vector(unsigned(if_instruction_address) + unsigned(if_immediate));
                    else -- predict NOT taken
                         out_pc <= std_logic_vector(unsigned(if_instruction_address) + 4);   
                    end if;
                    pc_ready <= '1';
                end if;
            end if;
            if ex_branch = BRANCH_CONDITIONAL then -- branch condition on ex - update
                if ex_actual_taken = PHT(ex_index)(1) then -- prediction was correct.
                    flush <= '0';
                else -- prediction was incorrect
                    if ex_actual_taken = '1' then -- missed predict not taken, must jump to branch target
                        out_pc <= std_logic_vector(unsigned(ex_instruction_address) + unsigned(ex_immediate));
                    else -- missed predict taken, must jump to pc_branch + 4
                        out_pc <= std_logic_vector(unsigned(ex_instruction_address) + 4);
                    end if;
                    pc_ready <= '1';
                    flush <= '1';
                end if;
                if ex_actual_taken = '1' then -- update PHT
                    if PHT(ex_index) /= "11" then
                        PHT(ex_index) <= std_logic_vector(unsigned(PHT(ex_index)) + 1);
                    end if;
                else
                    if PHT(ex_index) /= "00" then
                        PHT(ex_index) <= std_logic_vector(unsigned(PHT(ex_index)) - 1);
                    end if;
                end if;
                GHR <= GHR(N-2 downto 0) & ex_actual_taken;
            end if;
        end if;   
  
    end process gshare;
    
--    predict : process (enable)
--    begin
--        if enable = '1' then
--            if if_instruction(6 downto 2) = b"11000" then -- branch instruction on IF - predict
--                if PHT(if_index)(1) = '1' then -- predict TAKEN
--                     pc_add_if <= '1';
--                else -- predict NOT taken
--                     pc_next_if <= '1'; 
--                end if;
--            end if;
--         else
--            pc_add_if <= '0';
--            pc_next_if <= '0'; 
--         end if;
    
--    end process predict;
    
--    update : process (ex_branch)
--    begin
--        if ex_branch = BRANCH_CONDITIONAL then -- branch condition on ex - update
--            if ex_actual_taken = PHT(ex_index)(1) then -- prediction was correct.
--                flush <= '0';
--            else -- prediction was incorrect
--                if ex_actual_taken = '1' then -- missed predict not taken, must jump to branch target
--                    pc_add_ex <= '1';
--                else -- missed predict taken, must jump to pc_branch + 4
--                    pc_next_ex <= '1'; 
--                end if;
--                flush <= '1';
--            end if;
--            if ex_actual_taken = '1' then -- update PHT
--                if PHT(ex_index) /= "11" then
--                    PHT(ex_index) <= std_logic_vector(unsigned(PHT(ex_index)) + 1);
--                end if;
--            else
--                if PHT(ex_index) /= "00" then
--                    PHT(ex_index) <= std_logic_vector(unsigned(PHT(ex_index)) - 1);
--                end if;
--            end if;
--            GHR <= GHR(N-2 downto 0) & ex_actual_taken;
--        else
--            pc_add_ex <= '0';
--            pc_next_ex <= '0';
            
--        end if;
    
--    end process update;
    
--    calculate_pc : process (clk)
--    begin
--        if pc_add_if = '1' then
--            out_pc <= std_logic_vector(unsigned(if_instruction_address) + unsigned(if_immediate));
--            pc_ready <= '1';
--        elsif pc_next_if = '1' then
--            out_pc <= std_logic_vector(unsigned(if_instruction_address) + 4);
--            pc_ready <= '1';
--        elsif pc_add_ex = '1' then
--            out_pc <= std_logic_vector(unsigned(ex_instruction_address) + unsigned(ex_immediate));
--            pc_ready <= '1';
--        elsif pc_next_ex = '1' then
--            out_pc <= std_logic_vector(unsigned(ex_instruction_address) + 4);
--            pc_ready <= '1';
--        else
--            pc_ready <= '0';
--        end if;
    
    
--    end process calculate_pc;

end Behavioral;
