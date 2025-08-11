----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 07/21/2025 02:47:11 PM
-- Design Name: 
-- Module Name: pp_debouncer - Behavioral
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
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity pp_debouncer is
    generic (
        DEBOUNCE_CYCLES : natural := 50000  -- Adjust as needed
    );
    port (
        clk          : in  std_logic;
        reset        : in  std_logic;
        button_in    : in  std_logic;
        button_clean : out std_logic
    );
end pp_debouncer;

architecture Behavioral of pp_debouncer is
    signal button_sync      : std_logic_vector(1 downto 0) := (others => '0');
    signal debounce_counter : natural range 0 to DEBOUNCE_CYCLES-1 := 0;
    signal button_prev      : std_logic := '0';
begin

    sync_proc: process(clk)
    begin
        if rising_edge(clk) then
            button_sync(1) <= button_sync(0);
            button_sync(0) <= button_in;
        end if;
    end process sync_proc;
    
    debouncer: process(clk)
    begin
        if rising_edge(clk) then
            if reset = '1' then
                debounce_counter <= 0;
                button_clean <= '0';
            else
                -- Check for button state change
                if button_sync(1) /= button_prev then
                    button_prev <= button_sync(1);
                    debounce_counter <= 0;
                elsif debounce_counter < DEBOUNCE_CYCLES-1 then
                    debounce_counter <= debounce_counter + 1;
                else
                    button_clean <= button_prev;
                end if;
            end if;
        end if;
    end process;


end Behavioral;
