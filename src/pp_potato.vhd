-- The Potato Processor - A simple processor for FPGAs
-- (c) Kristian Klomsten Skordal 2014 - 2015 <kristian.skordal@wafflemail.net>
-- Report bugs and issues on <https://github.com/skordal/potato/issues>

library ieee;
use ieee.std_logic_1164.all;

use work.pp_types.all;
use work.pp_utilities.all;

--! @brief The Potato Processor.
--! This file provides a Wishbone-compatible interface to the Potato processor.
entity pp_potato is
	generic(
		PROCESSOR_ID           : std_logic_vector(31 downto 0) := x"00000000"; --! Processor ID.
		RESET_ADDRESS          : std_logic_vector(31 downto 0) := x"00000000"; --! Address of the first instruction to execute.
		MTIME_DIVIDER          : positive                      := 5;           --! Divider for the clock driving the MTIME counter.
		ICACHE_ENABLE          : boolean                       := TRUE;        --! Whether to enable the instruction cache.
		ICACHE_LINE_SIZE       : natural                       := 4;           --! Number of words per instruction cache line.
		ICACHE_NUM_LINES       : natural                       := 128          --! Number of cache lines in the instruction cache.
	);
	port(
		clk       : in std_logic;
		reset     : in std_logic;

		-- Interrupts:
		irq : in std_logic_vector(7 downto 0);

		-- Test interface:
		-- test_context_out : out test_context; Removed in order to use in block design.

--		-- Wishbone interface:
--		wb_adr_out : out std_logic_vector(31 downto 0);
--		wb_sel_out : out std_logic_vector( 3 downto 0);
--		wb_cyc_out : out std_logic;
--		wb_stb_out : out std_logic;
--		wb_we_out  : out std_logic;
--		wb_dat_out : out std_logic_vector(31 downto 0);
--		wb_dat_in  : in  std_logic_vector(31 downto 0);
--		wb_ack_in  : in  std_logic;


        -- AXI4 Interface
        -- Instruction Memory Master
        I_AXI_AWADDR  : out std_logic_vector(31 downto 0);
        I_AXI_AWVALID : out std_logic;
        I_AXI_AWREADY : in  std_logic;
        I_AXI_WDATA   : out std_logic_vector(31 downto 0);
        I_AXI_WSTRB   : out std_logic_vector(3 downto 0);
        I_AXI_WVALID  : out std_logic;
        I_AXI_WREADY  : in  std_logic;
        I_AXI_BRESP   : in  std_logic_vector(1 downto 0);
        I_AXI_BVALID  : in  std_logic;
        I_AXI_BREADY  : out std_logic;
        I_AXI_ARADDR  : out std_logic_vector(31 downto 0);
        I_AXI_ARVALID : out std_logic;
        I_AXI_ARREADY : in  std_logic;
        I_AXI_RDATA   : in  std_logic_vector(31 downto 0);
        I_AXI_RRESP   : in  std_logic_vector(1 downto 0);
        I_AXI_RVALID  : in  std_logic;
        I_AXI_RREADY  : out std_logic;
        
        -- Data Memory Master
        D_AXI_AWADDR  : out std_logic_vector(31 downto 0);
        D_AXI_AWVALID : out std_logic;
        D_AXI_AWREADY : in  std_logic;
        D_AXI_WDATA   : out std_logic_vector(31 downto 0);
        D_AXI_WSTRB   : out std_logic_vector(3 downto 0);
        D_AXI_WVALID  : out std_logic;
        D_AXI_WREADY  : in  std_logic;
        D_AXI_BRESP   : in  std_logic_vector(1 downto 0);
        D_AXI_BVALID  : in  std_logic;
        D_AXI_BREADY  : out std_logic;
        D_AXI_ARADDR  : out std_logic_vector(31 downto 0);
        D_AXI_ARVALID : out std_logic;
        D_AXI_ARREADY : in  std_logic;
        D_AXI_RDATA   : in  std_logic_vector(31 downto 0);
        D_AXI_RRESP   : in  std_logic_vector(1 downto 0);
        D_AXI_RVALID  : in  std_logic;
        D_AXI_RREADY  : out std_logic;
        
		
		-- Step-by-step unit signals
		current_pc : out std_logic_vector(31 downto 0);
		step_stall : in std_logic
	);
end entity pp_potato;

architecture behaviour of pp_potato is

	-- Instruction memory signals:
	signal imem_address : std_logic_vector(31 downto 0);
	signal imem_data    : std_logic_vector(31 downto 0);
	signal imem_req, imem_ack : std_logic;

	-- Data memory signals:
	signal dmem_address   : std_logic_vector(31 downto 0);
	signal dmem_data_in   : std_logic_vector(31 downto 0);
	signal dmem_data_out  : std_logic_vector(31 downto 0);
	signal dmem_data_size : std_logic_vector( 1 downto 0);
	signal dmem_read_req  : std_logic;
	signal dmem_read_ack  : std_logic;
	signal dmem_write_req : std_logic;
	signal dmem_write_ack : std_logic;

--	-- Wishbone signals:
--	signal icache_inputs, dmem_if_inputs   : wishbone_master_inputs;
--	signal icache_outputs, dmem_if_outputs : wishbone_master_outputs;

--    -- Arbiter signals:
--	signal m1_inputs, m2_inputs   : wishbone_master_inputs;
--	signal m1_outputs, m2_outputs : wishbone_master_outputs;

begin

	processor: entity work.pp_core
		generic map(
			PROCESSOR_ID => PROCESSOR_ID,
			RESET_ADDRESS => RESET_ADDRESS
		) port map(
			clk => clk,
			reset => reset,
			imem_address => imem_address,
			imem_data_in => imem_data,
			imem_req => imem_req,
			imem_ack => imem_ack,
			dmem_address => dmem_address,
			dmem_data_in => dmem_data_in,
			dmem_data_out => dmem_data_out,
			dmem_data_size => dmem_data_size,
			dmem_read_req => dmem_read_req,
			dmem_read_ack => dmem_read_ack,
			dmem_write_req => dmem_write_req,
			dmem_write_ack => dmem_write_ack,
			test_context_out => open,
			irq => irq,
			step_stall => step_stall
		);

    current_pc <= imem_address;
    
--	icache_enabled: if ICACHE_ENABLE
--	generate
--		icache: entity work.pp_icache
--			generic map(
--				LINE_SIZE => ICACHE_LINE_SIZE,
--				NUM_LINES => ICACHE_NUM_LINES
--			) port map(
--				clk => clk,
--				reset => reset,
--				mem_address_in => imem_address,
--				mem_data_out => imem_data,
--				mem_read_req => imem_req,
--				mem_read_ack => imem_ack,
--				wb_inputs => icache_inputs,
--				wb_outputs => icache_outputs
--			);

--		icache_inputs <= m1_inputs;
--		m1_outputs <= icache_outputs;

--		dmem_if_inputs <= m2_inputs;
--		m2_outputs <= dmem_if_outputs;
--	end generate icache_enabled;

--	icache_disabled: if not ICACHE_ENABLE
--	generate
--		imem_if: entity work.pp_wb_adapter
--			port map(
--				clk => clk,
--				reset => reset,
--				mem_address => imem_address,
--				mem_data_in => (others => '0'),
--				mem_data_out => imem_data,
--				mem_data_size => (others => '0'),
--				mem_read_req => imem_req,
--				mem_read_ack => imem_ack,
--				mem_write_req => '0',
--				mem_write_ack => open,
--				wb_inputs => icache_inputs,
--				wb_outputs => icache_outputs
--			);

--		dmem_if_inputs <= m1_inputs;
--		m1_outputs <= dmem_if_outputs;

--		icache_inputs <= m2_inputs;
--		m2_outputs <= icache_outputs;
--	end generate icache_disabled;

--	dmem_if: entity work.pp_wb_adapter
--		port map(
--			clk => clk,
--			reset => reset,
--			mem_address => dmem_address,
--			mem_data_in => dmem_data_out,
--			mem_data_out => dmem_data_in,
--			mem_data_size => dmem_data_size,
--			mem_read_req => dmem_read_req,
--			mem_read_ack => dmem_read_ack,
--			mem_write_req => dmem_write_req,
--			mem_write_ack => dmem_write_ack,
--			wb_inputs => dmem_if_inputs,
--			wb_outputs => dmem_if_outputs
--		);

--	arbiter: entity work.pp_wb_arbiter
--		port map(
--			clk => clk,
--			reset => reset,
--			m1_inputs => m1_inputs,
--			m1_outputs => m1_outputs,
--			m2_inputs => m2_inputs,
--			m2_outputs => m2_outputs,
--			wb_adr_out => wb_adr_out,
--			wb_sel_out => wb_sel_out,
--			wb_cyc_out => wb_cyc_out,
--			wb_stb_out => wb_stb_out,
--			wb_we_out => wb_we_out,
--			wb_dat_out => wb_dat_out,
--			wb_dat_in => wb_dat_in,
--			wb_ack_in => wb_ack_in
--		);

    imem_if: entity work.pp_axi4_adapter
    		port map(
			clk => clk,
			reset => reset,
			mem_address => dmem_address,
			mem_data_in => dmem_data_out,
			mem_data_out => dmem_data_in,
			mem_data_size => dmem_data_size,
			mem_read_req => dmem_read_req,
			mem_read_ack => dmem_read_ack,
			mem_write_req => dmem_write_req,
			mem_write_ack => dmem_write_ack,
			M_AXI_AWADDR => I_AXI_AWADDR,
			M_AXI_AWVALID => I_AXI_AWVALID,
			M_AXI_AWREADY => I_AXI_AWREADY,
			M_AXI_WDATA => I_AXI_WDATA,
			M_AXI_WSTRB => I_AXI_WSTRB,
			M_AXI_WVALID => I_AXI_WVALID,
			M_AXI_WREADY => I_AXI_WREADY,
			M_AXI_BRESP => I_AXI_BRESP,
			M_AXI_BVALID => I_AXI_BVALID,
			M_AXI_BREADY => I_AXI_BREADY,
			M_AXI_ARADDR => I_AXI_ARADDR,
			M_AXI_ARVALID => I_AXI_ARVALID,
			M_AXI_ARREADY => I_AXI_ARREADY,
			M_AXI_RDATA => I_AXI_RDATA,
			M_AXI_RRESP => I_AXI_RRESP,
			M_AXI_RVALID => I_AXI_RVALID,
			M_AXI_RREADY => I_AXI_RREADY 
		);

    dmem_if: entity work.pp_axi4_adapter
    		port map(
			clk => clk,
			reset => reset,
			mem_address => dmem_address,
			mem_data_in => dmem_data_out,
			mem_data_out => dmem_data_in,
			mem_data_size => dmem_data_size,
			mem_read_req => dmem_read_req,
			mem_read_ack => dmem_read_ack,
			mem_write_req => dmem_write_req,
			mem_write_ack => dmem_write_ack,
			M_AXI_AWADDR => D_AXI_AWADDR,
			M_AXI_AWVALID => D_AXI_AWVALID,
			M_AXI_AWREADY => D_AXI_AWREADY,
			M_AXI_WDATA => D_AXI_WDATA,
			M_AXI_WSTRB => D_AXI_WSTRB,
			M_AXI_WVALID => D_AXI_WVALID,
			M_AXI_WREADY => D_AXI_WREADY,
			M_AXI_BRESP => D_AXI_BRESP,
			M_AXI_BVALID => D_AXI_BVALID,
			M_AXI_BREADY => D_AXI_BREADY,
			M_AXI_ARADDR => D_AXI_ARADDR,
			M_AXI_ARVALID => D_AXI_ARVALID,
			M_AXI_ARREADY => D_AXI_ARREADY,
			M_AXI_RDATA => D_AXI_RDATA,
			M_AXI_RRESP => D_AXI_RRESP,
			M_AXI_RVALID => D_AXI_RVALID,
			M_AXI_RREADY => D_AXI_RREADY 
		);
		
		
end architecture behaviour;
