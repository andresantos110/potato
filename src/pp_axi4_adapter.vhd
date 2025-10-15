----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 08/18/2025 03:54:32 PM
-- Design Name: 
-- Module Name: pp_axi4_adapter - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

use work.pp_types.all;
use work.pp_utilities.all;

entity pp_axi4_adapter is
	port(
		clk   : in std_logic;
		reset : in std_logic;

		-- Processor data memory signals:
		signal mem_address   : in  std_logic_vector(31 downto 0);
		signal mem_data_in   : in  std_logic_vector(31 downto 0); -- Data in from the bus
		signal mem_data_out  : out std_logic_vector(31 downto 0); -- Data out to the bus
		signal mem_data_size : in  std_logic_vector( 1 downto 0);
		signal mem_read_req  : in  std_logic;
		signal mem_read_ack  : out std_logic;
		signal mem_write_req : in  std_logic;
		signal mem_write_ack : out std_logic;

		-- AXI interface:
		axi_inputs  : in axi4lite_master_inputs;
		axi_outputs : out axi4lite_master_outputs
	);
end pp_axi4_adapter;

architecture Behavioral of pp_axi4_adapter is

  type states is (
    IDLE,
    WRITE_ADDR, WRITE_DATA, WRITE_RESP,
    READ_ADDR, READ_RESP
  );
  signal state : states;
  
  signal mem_r_ack : std_logic;

begin


  mem_write_ack <= '1' when state = WRITE_RESP and axi_inputs.BVALID = '1' else '0';
  mem_read_ack  <= mem_r_ack;

  axi_fsm: process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        state <= IDLE;

        -- default reset values
        axi_outputs.AWVALID <= '0';
        axi_outputs.WVALID  <= '0';
        axi_outputs.BREADY  <= '0';
        axi_outputs.ARVALID <= '0';
        axi_outputs.RREADY  <= '0';

        mem_r_ack <= '0';

      else
        case state is

          when IDLE =>
            mem_r_ack <= '0';

            if mem_write_req = '1' then
              -- Prepare write address + data
              axi_outputs.AWADDR  <= mem_address;
              axi_outputs.AWVALID <= '1';
              axi_outputs.WDATA   <= mem_data_in;
              axi_outputs.WSTRB   <= wb_get_data_sel(mem_data_size, mem_address);
              axi_outputs.WVALID  <= '1';
              axi_outputs.BREADY  <= '1';
              state <= WRITE_ADDR;

            elsif mem_read_req = '1' then
              -- Prepare read address
              axi_outputs.ARADDR  <= mem_address;
              axi_outputs.ARVALID <= '1';
              axi_outputs.RREADY  <= '1';
              state <= READ_ADDR;
            end if;

          -- -----------------------
          -- WRITE SEQUENCE
          -- -----------------------
          when WRITE_ADDR =>
            if axi_inputs.AWREADY = '1' then
              axi_outputs.AWVALID <= '0'; -- address accepted
              state <= WRITE_DATA;
            end if;

          when WRITE_DATA =>
            if axi_inputs.WREADY = '1' then
              axi_outputs.WVALID <= '0'; -- data accepted
              state <= WRITE_RESP;
            end if;

          when WRITE_RESP =>
            if axi_inputs.BVALID = '1' then
              axi_outputs.BREADY <= '0';
              mem_write_ack <= '1';
              state <= IDLE;
            end if;

          -- -----------------------
          -- READ SEQUENCE
          -- -----------------------
          when READ_ADDR =>
            if axi_inputs.ARREADY = '1' then
              axi_outputs.ARVALID <= '0'; -- address accepted
              state <= READ_RESP;
            end if;

          when READ_RESP =>
            if axi_inputs.RVALID = '1' then
              mem_data_out <= axi_inputs.RDATA;
              axi_outputs.RREADY <= '0';
              mem_r_ack <= '1';
              state <= IDLE;
            end if;

        end case;
      end if;
    end if;
  end process axi_fsm;


end Behavioral;
