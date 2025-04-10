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

    signal index : integer range 0 to PHT_SIZE-1;
    signal if_immediate: std_logic_vector(31 downto 0);
    
    signal wait_cycle : std_logic;

begin

    index <= to_integer(unsigned(if_instruction_address(3 downto 0) XOR GHR)); -- Calculate index (XOR of PC and GHR)
    
    gshare: process(clk)
    begin
        if rising_edge(clk) then
            pc_ready <= '0';
            if reset = '1' then
                    GHR <= (others => '0');
                    PHT <= (others => "10");
                    wait_cycle <= '1';
                    out_pc <= RESET_ADDRESS;
            end if;
            if enable = '1' then
                pc_ready <= '0';
                if if_instruction(6 downto 2) = b"11000" then -- branch instruction on IF
                    if PHT(index)(1) = '1' then -- predict TAKEN
                         out_pc <= std_logic_vector(unsigned(if_instruction_address) + unsigned(if_immediate));
                    else -- predict NOT taken
                         out_pc <= std_logic_vector(unsigned(if_instruction_address) + 4);   
                    end if;
                    pc_ready <= '1';
                    end if;
                end if;
            end if;
            if ex_branch = BRANCH_CONDITIONAL then      
                if ex_actual_taken = PHT(index)(1) then -- prediction was correct.
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
  
    end process gshare;

    immediate_decoder: entity work.pp_imm_decoder
    port map(
        instruction => if_instruction(31 downto 2),
        immediate => if_immediate
    );


end Behavioral;
