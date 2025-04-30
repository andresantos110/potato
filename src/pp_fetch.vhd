-- The Potato Processor - A simple processor for FPGAs
-- (c) Kristian Klomsten Skordal 2014 - 2015 <kristian.skordal@wafflemail.net>
-- Report bugs and issues on <https://github.com/skordal/potato/issues>

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.pp_constants.all;

--! @brief Instruction fetch unit.
entity pp_fetch is
	generic(
		RESET_ADDRESS : std_logic_vector(31 downto 0)
	);
	port(
		clk    : in std_logic;
		reset  : in std_logic;

		-- Instruction memory connections:
		imem_address : out std_logic_vector(31 downto 0);
		imem_data_in : in  std_logic_vector(31 downto 0);
		imem_req     : out std_logic;
		imem_ack     : in  std_logic;

		-- Control inputs:
		stall     : in std_logic;
		flush     : in std_logic;
		jump      : in std_logic;
		exception : in std_logic;
		
		branch_target : in std_logic_vector(31 downto 0);
		evec          : in std_logic_vector(31 downto 0);
		branch_ready  : in std_logic;
		branch_pc     : in std_logic_vector(31 downto 0);

		-- Outputs to the instruction decode unit:
		instruction_data    : out std_logic_vector(31 downto 0);
		instruction_address : out std_logic_vector(31 downto 0);
		instruction_ready   : out std_logic
	);
end entity pp_fetch;

architecture behaviour of pp_fetch is
	signal pc           : std_logic_vector(31 downto 0);
	signal pc_next      : std_logic_vector(31 downto 0);
	signal cancel_fetch : std_logic;
	signal immediate_value : std_logic_vector(31 downto 0);
	
begin

	imem_address <= pc_next when cancel_fetch = '0' else pc;

	instruction_data <= imem_data_in;
	instruction_ready <= imem_ack and (not stall) and (not cancel_fetch);
	instruction_address <= pc;
	
	request_instr: process(imem_data_in, branch_ready, reset)
	begin
	    imem_req <= not reset;
        if imem_data_in(6 downto 2) = b"11000" then
                imem_req <= branch_ready;
        end if;
	end process request_instr;

	set_pc: process(clk)
	begin
		if rising_edge(clk) then
			if reset = '1' then
				pc <= RESET_ADDRESS;
				cancel_fetch <= '0';
			else
				if (exception = '1' or jump = '1' or branch_ready = '1') and imem_ack = '0' then
					cancel_fetch <= '1';
					pc <= pc_next;
				elsif cancel_fetch = '1' and imem_ack = '1' then
					cancel_fetch <= '0';
				else
					pc <= pc_next;
				end if;
			end if;
		end if;
	end process set_pc;


	calc_next_pc: process(reset, stall, jump, exception, imem_ack, branch_target, branch_ready, branch_pc, evec, pc, cancel_fetch, immediate_value, imem_data_in)
	begin   
		if exception = '1' then
			pc_next <= evec;
		elsif jump = '1' then
			pc_next <= branch_target;
	    elsif branch_ready = '1' then
	        pc_next <= branch_pc;
		elsif imem_ack = '1' and stall = '0' and cancel_fetch = '0' then
			pc_next <= std_logic_vector(unsigned(pc) + 4);
		else
			pc_next <= pc;
		end if;
	end process calc_next_pc;
		
	


end architecture behaviour;
