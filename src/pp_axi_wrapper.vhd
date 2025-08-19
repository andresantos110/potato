----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 08/19/2025 01:30:56 PM
-- Design Name: 
-- Module Name: pp_axi_wrapper - Behavioral
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

use work.pp_types.all;
use work.pp_utilities.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity pp_axi_wrapper is
    port (
        clk   : in std_logic;
        reset : in std_logic;

        -- CPU side
        m_axi_out : in  axi4lite_master_outputs;
        m_axi_in  : out axi4lite_master_inputs;

        -- Vivado AXI interface (to connect in block design)
        M_AXI_AWADDR  : out std_logic_vector(31 downto 0);
        M_AXI_AWVALID : out std_logic;
        M_AXI_AWREADY : in  std_logic;
        M_AXI_WDATA   : out std_logic_vector(31 downto 0);
        M_AXI_WSTRB   : out std_logic_vector(3 downto 0);
        M_AXI_WVALID  : out std_logic;
        M_AXI_WREADY  : in  std_logic;
        M_AXI_BRESP   : in  std_logic_vector(1 downto 0);
        M_AXI_BVALID  : in  std_logic;
        M_AXI_BREADY  : out std_logic;
        M_AXI_ARADDR  : out std_logic_vector(31 downto 0);
        M_AXI_ARVALID : out std_logic;
        M_AXI_ARREADY : in  std_logic;
        M_AXI_RDATA   : in  std_logic_vector(31 downto 0);
        M_AXI_RRESP   : in  std_logic_vector(1 downto 0);
        M_AXI_RVALID  : in  std_logic;
        M_AXI_RREADY  : out std_logic
    );
end entity;

architecture behaviour of pp_axi_wrapper is
begin

    M_AXI_AWADDR  <= m_axi_out.AWADDR;
    M_AXI_AWVALID <= m_axi_out.AWVALID;
    M_AXI_WDATA   <= m_axi_out.WDATA;
    M_AXI_WSTRB   <= m_axi_out.WSTRB;
    M_AXI_WVALID  <= m_axi_out.WVALID;
    M_AXI_BREADY  <= m_axi_out.BREADY;
    M_AXI_ARADDR  <= m_axi_out.ARADDR;
    M_AXI_ARVALID <= m_axi_out.ARVALID;
    M_AXI_RREADY  <= m_axi_out.RREADY;

    m_axi_in.AWREADY <= M_AXI_AWREADY;
    m_axi_in.WREADY  <= M_AXI_WREADY;
    m_axi_in.BRESP   <= M_AXI_BRESP;
    m_axi_in.BVALID  <= M_AXI_BVALID;
    m_axi_in.ARREADY <= M_AXI_ARREADY;
    m_axi_in.RDATA   <= M_AXI_RDATA;
    m_axi_in.RRESP   <= M_AXI_RRESP;
    m_axi_in.RVALID  <= M_AXI_RVALID;
    
end architecture;
