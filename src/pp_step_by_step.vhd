----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 06/10/2025 11:32:25 AM
-- Design Name: 
-- Module Name: pp_step_by_step - Behavioral
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

entity pp_step_by_step is
    generic(
        enable_step_by_step : boolean := false;
        DEBOUNCE_CYCLES : natural := 50000
    ); port(
        clk : in std_logic;
        reset : in std_logic;
        current_pc : in std_logic_vector (31 downto 0);
        step_button : in std_logic;
        stall : out std_logic;
        seg : out std_logic_vector(6 downto 0);
        an : out std_logic_vector(7 downto 0)   
    );
end pp_step_by_step;

architecture Behavioral of pp_step_by_step is
    -- Button synchronization registers
    signal button_sync      : std_logic_vector(2 downto 0) := (others => '0');
    
    -- Debounce counter
    signal debounce_counter : natural range 0 to DEBOUNCE_CYCLES-1 := 0;
    signal button_clean     : std_logic := '0';
    signal button_prev      : std_logic := '0';
    
    -- Step control
    signal step_request     : std_logic := '0';
    signal step_active      : std_logic := '0';
    
    type digits_array is array(7 downto 0) of std_logic_vector(3 downto 0);
    signal digits : digits_array;
    signal current_digit : integer range 0 to 7;
    signal current_seg : std_logic_vector(6 downto 0);
    signal refresh_counter : integer range 0 to 6249;
    signal current_element : std_logic_vector(3 downto 0);
    
begin

digits(0) <= current_pc(3 downto 0);
digits(1) <= current_pc(7 downto 4);
digits(2) <= current_pc(11 downto 8);
digits(3) <= current_pc(15 downto 12);
digits(4) <= current_pc(19 downto 16);
digits(5) <= current_pc(23 downto 20);
digits(6) <= current_pc(27 downto 24);
digits(7) <= current_pc(31 downto 28);

sync_proc: process(clk)
begin
    if rising_edge(clk) then
        button_sync <= button_sync(1 downto 0) & step_button;
    end if;
end process;

debouncer: process(clk)
begin
    if rising_edge(clk) then
        if reset = '1' then
            debounce_counter <= 0;
            button_clean <= '0';
        else
            -- Check for button state change
            if button_sync(2) /= button_prev then
                button_prev <= button_sync(2);
                debounce_counter <= 0;
            elsif debounce_counter < DEBOUNCE_CYCLES-1 then
                debounce_counter <= debounce_counter + 1;
            else
                button_clean <= button_prev;
            end if;
        end if;
    end if;
end process;

-- Stall signal generation
stall <= '1' when (enable_step_by_step = true and step_active = '0') else '0';

-- 7 segment display

process(clk)
begin
    if rising_edge(clk) then
        if refresh_counter = 6249 then -- 50 MHz / 8000 = 6250
            refresh_counter <= 0;
            if current_digit = 7 then
                current_digit <= 0;
            else
                current_digit <= current_digit + 1;
            end if;
        else
            refresh_counter <= refresh_counter + 1;
        end if;
    end if;
end process;

current_element <= digits(current_digit);

decode_7seg : entity work.pp_decode_7seg
port map (
    digit => current_element,
    seg => current_seg
);

seg <= current_seg;
an <= (others => '1');
an(current_digit) <= '0';  -- Active low digit select

end Behavioral;
