LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE ieee.math_real.ALL;
USE std.textio.ALL;
USE work.internals.ALL;
USE work.defs.ALL;
USE work.router_top;
ENTITY router_top_tb IS
END ENTITY;

ARCHITECTURE impl OF router_top_tb IS

    SIGNAL rst : STD_LOGIC;
    SIGNAL req_in : logic_arr;
    SIGNAL data_in : data_arr;
    SIGNAL ack_out : logic_arr;
    SIGNAL ack_in : logic_arr;

BEGIN

    DUT : ENTITY router_top PORT MAP(
        rst => rst,
        req_in => req_in,
        data_in => data_in,
        ack_out => ack_out,
        ack_in => ack_in
        );

    rst <= '1', '0' AFTER 5 ns;
    req_in(0) <= '0', '1' AFTER 25 ns;
    req_in(1) <= '0';
    req_in(2) <= '0';
    req_in(3) <= '0';
    req_in(4) <= '0';

    ack_out(0) <= '0';
    ack_out(1) <= '0';
    ack_out(2) <= '0';
    ack_out(3) <= '0';
    ack_out(4) <= '0';

    --data_in(0) <= "0011001000001111";
    data_in(1) <= "0010011000001111";
    data_in(2) <= "0010011000001111";
    data_in(3) <= "0100001000001111";
    data_in(4) <= "0000001100001111";

    PROC_SEQUENCER : PROCESS
        FILE text_file : text OPEN read_mode IS "stimulus.txt";
        VARIABLE ok : BOOLEAN;
        VARIABLE ack : STD_LOGIC;
        VARIABLE text_line : line;
        VARIABLE wait_time : TIME;
        VARIABLE data : bit_vector(DATA_WIDTH - 1 DOWNTO 0);
    BEGIN
        IF NOT endfile(text_file) THEN
        --IF (ack_in(0) /= ack) THEN
            readline(text_file, text_line);
            read(text_line, wait_time);
            read(text_line, data);

            IF text_line.ALL'length = 0 OR text_line.ALL(1) = '#' THEN
            END IF;
            data_in(0) <= To_StdLogicVector(data);
            WAIT FOR wait_time;
        --END IF;
        WAIT FOR 2 ns;
    END IF;
END PROCESS;
END ARCHITECTURE;