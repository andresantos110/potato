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
        
        -- Execute (EX) signals
        ex_instruction_address : in std_logic_vector(31 downto 0); -- address of instruction from EX
        ex_immediate : in std_logic_vector(31 downto 0);
        ex_branch : in branch_type; -- variable that indicates a conditional branch instruction is in the EX stage
        ex_actual_taken : in std_logic; -- Branch instruction actual outcome
        
        -- Outputs
        pc_ready : out std_logic;
        out_pc : out std_logic_vector(31 downto 0);
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
    signal if_instruction_offset: std_logic_vector(31 downto 0);
    
    type state_type is (IDLE, PREDICT, UPDATE, INCORRECT_NOT_TAKEN, INCORRECT_TAKEN);
    signal current_state, next_state : state_type;

begin

    if_instruction_offset <= std_logic_vector(unsigned(if_instruction_address) - 4);
    if_index <= to_integer(unsigned(if_instruction_offset(3 downto 0) XOR GHR)); -- Calculate index for prediction(XOR of PC and GHR)
    ex_index <= to_integer(unsigned(ex_instruction_address(3 downto 0) XOR GHR)); -- Calculate index for prediction(XOR of PC and GHR)
    if_immediate <= (31 downto 12 => if_instruction(31)) & if_instruction(7) & if_instruction(30 downto 25) & if_instruction(11 downto 8) & '0'; -- decode immediate
    
    process(clk)
    begin
        if reset = '1' then
            GHR <= (others => '0');
            current_state <= IDLE;     
        elsif rising_edge(clk) then
            current_state <= next_state;  
            if current_state = UPDATE then
                GHR <= GHR(N-2 downto 0) & ex_actual_taken;
            end if;
            
        end if;
    end process;
    
    process(current_state, enable, ex_instruction_address, if_instruction,
            ex_actual_taken, reset)
    begin
        if reset = '1' then
            PHT <= (others => "10");  -- Reset to weakly taken
            out_pc <= RESET_ADDRESS;
        end if;
        -- Default outputs
        next_state <= current_state;
        out_pc <= (others => '0');
        pc_ready <= '0';
        flush <= '0';
        
        case current_state is
            when IDLE =>
                pc_ready <= '0';
                flush <= '0';
                if enable = '1' and if_instruction(6 downto 2) = b"11000" then
                    next_state <= PREDICT;
                end if;
                
            when PREDICT =>
                if PHT(if_index)(1) = '1' then
                    -- Predict taken
                    out_pc <= std_logic_vector(unsigned(if_instruction_offset) + unsigned(if_immediate));
                    pc_ready <= '1';
                else
                    -- Predict not taken
                    out_pc <= std_logic_vector(unsigned(if_instruction_offset) + 4);
                    pc_ready <= '1';
                end if;
                next_state <= UPDATE;
                
--                if ex_branch = BRANCH_CONDITIONAL then
--                    next_state <= UPDATE;
--                else
--                    next_state <= IDLE;
--                end if;
                
            when UPDATE =>
                if ex_actual_taken /= PHT(ex_index)(1) then
                    -- Misprediction
                    if ex_actual_taken = '1' then
                        next_state <= INCORRECT_TAKEN;
                    else
                        next_state <= INCORRECT_NOT_TAKEN;
                    end if;
                else
                    -- Correct prediction
                    next_state <= IDLE;
                end if;
                
                -- Update PHT
                if ex_actual_taken = '1' and PHT(ex_index) /= "11" then
                    PHT(ex_index) <= std_logic_vector(unsigned(PHT(ex_index)) + 1);
                elsif ex_actual_taken = '0' and PHT(ex_index) /= "00" then
                    PHT(ex_index) <= std_logic_vector(unsigned(PHT(ex_index)) - 1);
                end if;
                
            when INCORRECT_NOT_TAKEN =>
                out_pc <= std_logic_vector(unsigned(ex_instruction_address) + unsigned(ex_immediate));
                pc_ready <= '1';
                flush <= '1';
                next_state <= IDLE;
                
            when INCORRECT_TAKEN =>
                out_pc <= std_logic_vector(unsigned(ex_instruction_address) + 4);
                pc_ready <= '1';
                flush <= '1';
                next_state <= IDLE;
                
        end case;
    end process;
    
end Behavioral;
