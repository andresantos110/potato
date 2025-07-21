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
        enable_step_by_step : boolean := true;
        DEBOUNCE_CYCLES : natural := 50000
    ); port(
        clk : in std_logic;
        reset : in std_logic;
        current_pc : in std_logic_vector (31 downto 0);
        break_pc : in std_logic_vector (31 downto 0);
        step_button : inout std_logic;
        run_button : inout std_logic;
        stall : out std_logic;
        seg : out std_logic_vector(6 downto 0);
        an : out std_logic_vector(7 downto 0)   
    );
end pp_step_by_step;

architecture Behavioral of pp_step_by_step is

    signal step_button_debounced    : std_logic := '0';
    signal step_button_prev : std_logic := '0';
    
    signal run_button_debounced    : std_logic := '0';
    signal run_button_prev : std_logic := '0';
    signal run_active     : std_logic := '0';
    
    -- Step control
    signal step_request     : std_logic := '0';
    signal step_active      : std_logic := '0';
    
    type digits_array is array(7 downto 0) of std_logic_vector(3 downto 0);
    signal digits : digits_array;
    signal current_digit : integer range 0 to 7;
    signal current_seg : std_logic_vector(6 downto 0);
    signal refresh_counter : integer range 0 to 62499;
    signal current_element : std_logic_vector(3 downto 0);
    signal an_temp : std_logic_vector(7 downto 0);
    signal stall_sr : std_logic_vector(4 downto 0) := "00000";
    
    signal step_stall : std_logic := '1';
    signal run_stall : std_logic := '1';
    
begin

step_button <= 'Z';
run_button <= 'Z';

digits(0) <= current_pc(3 downto 0);
digits(1) <= current_pc(7 downto 4);
digits(2) <= current_pc(11 downto 8);
digits(3) <= current_pc(15 downto 12);
digits(4) <= current_pc(19 downto 16);
digits(5) <= current_pc(23 downto 20);
digits(6) <= current_pc(27 downto 24);
digits(7) <= current_pc(31 downto 28);

debouncer_step : entity work.pp_debouncer
port map (
    clk => clk,
    reset => reset,
    button_in => step_button,
    button_clean => step_button_debounced
);

debouncer_run : entity work.pp_debouncer
port map (
    clk => clk,
    reset => reset,
    button_in => run_button,
    button_clean => run_button_debounced
);


stall_step : process(clk)
begin
    if rising_edge(clk) then

        stall_sr(4) <= (step_button_debounced and not step_button_prev); -- new edge
        stall_sr(3) <= stall_sr(4);
        stall_sr(2) <= stall_sr(3);
        stall_sr(1) <= stall_sr(2);
        stall_sr(0) <= stall_sr(1);

        step_stall <= not (stall_sr(4) or stall_sr(3) or stall_sr(2) or
                      stall_sr(1) or stall_sr(0));

        step_button_prev <= step_button_debounced;
    end if;
end process stall_step;

stall_run : process(clk)
begin
    if rising_edge(clk) then
        if reset = '1' then
            run_button_prev <= '0';
            run_active  <= '0';
            run_stall       <= '1';
        else
            run_button_prev <= run_button_debounced;

            if run_active = '0' then
                -- Detect rising edge of button
                if run_button_debounced = '1' and run_button_prev = '0' then
                    run_stall      <= '0';  -- Release stall
                    run_active <= '1';  -- Start running
                end if;
            else
                -- While running, wait until PC hits target
                if current_pc = break_pc then
                    run_stall      <= '1';  -- Re-stall
                    run_active <= '0';  -- Reset for next button press
                end if;
            end if;
        end if;
    end if;
end process stall_run;

stall <= step_stall and run_stall;

-- 7 segment display

refresh_7seg : process(clk)
begin
    if rising_edge(clk) then
        if refresh_counter = 62499 then -- 50 MHz / 80 = 62500
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
end process refresh_7seg;

current_element <= digits(current_digit);

decode_7seg : entity work.pp_decode_7seg
port map (
    digit => current_element,
    seg(0) => current_seg(6),
    seg(1) => current_seg(5),
    seg(2) => current_seg(4),
    seg(3) => current_seg(3),
    seg(4) => current_seg(2),
    seg(5) => current_seg(1),
    seg(6) => current_seg(0)    
);

process(current_digit)
begin
    an_temp <= (others => '1');
    an_temp(current_digit) <= '0';
end process;

seg <= current_seg;
an <= an_temp;

end Behavioral;
