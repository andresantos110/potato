


library ieee;
use ieee.std_logic_1164.all;

use work.pp_types.all;
use work.pp_constants.all;
use work.pp_utilities.all;
use work.pp_csr.all;

entity tb_gshare is
end entity tb_gshare;

architecture testbench of tb_gshare is

	signal clk : std_logic := '0';
	constant clk_period : time := 10 ns;

    signal reset : std_logic := '1';
    
        -- Instruction Fetch (IF) signals 
    signal if_instruction_address : std_logic_vector(31 downto 0) := (others => '0'); -- address of instruction from IF
    signal if_instruction : std_logic_vector(31 downto 0) := (others => '0'); -- instruction from IF
    signal gshare_enabled : std_logic;
    signal out_pc : std_logic_vector(31 downto 0);
    
    -- Execute (EX) signals
    signal ex_instruction_address : std_logic_vector(31 downto 0) := (others => '0'); -- address of instruction from EX\
    signal ex_immediate : std_logic_vector(31 downto 0) := (others => '0');
    signal ex_branch : branch_type := BRANCH_NONE; -- variable that indicates a conditional branch instruction is in the EX stage
    signal ex_actual_taken : std_logic := '1'; -- Branch instruction actual outcome
    signal flush : std_logic;

begin
    	   
    gsh: entity work.pp_gshare
		port map(
    	       clk => clk,
    	       reset => reset,
    	       if_instruction_address => if_instruction_address,
    	       if_instruction => if_instruction,
    	       gshare_enabled => gshare_enabled,
    	       out_pc => out_pc,
    	       ex_instruction_address => ex_instruction_address,
    	       ex_immediate => ex_immediate,
    	       ex_branch => ex_branch,
    	       ex_actual_taken => ex_actual_taken,
    	       flush => flush
    	   );
    	   
    clock: process
	begin
		clk <= '1';
		wait for clk_period / 2;
		clk <= '0';
		wait for clk_period / 2;
	end process clock;
	
	
    stimulus: process
	begin
	    wait for clk_period * 2;
		reset <= '0';
		-- test predictions
		if_instruction_address <= X"ffff81a0";
		if_instruction <= B"00000000001000001100100001100011"; -- blt x2, x1, 8
		wait for clk_period * 2;
		
		if_instruction <= B"00000000000000000000000000000000";
		wait for clk_period * 2;
		
		-- test update 
		ex_instruction_address <= X"ffff81a0";
		ex_immediate <= B"00000000000000000000000000000100";
		ex_branch <= BRANCH_CONDITIONAL;
		ex_actual_taken <= '1';
		wait for clk_period * 2;
		
		ex_branch <= BRANCH_NONE;
		wait for clk_period * 2;
		
		wait;
	end process stimulus;

end architecture testbench;