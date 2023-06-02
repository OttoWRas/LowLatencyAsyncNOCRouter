LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE ieee.math_real.ALL;
USE work.defs.ALL;
USE std.textio.ALL;

ENTITY dataTx IS
    GENERIC (
        file_name : STRING := "stimulus.txt"
    );

    PORT (
        rst : IN STD_LOGIC;
        req : OUT STD_LOGIC;
        ack : IN STD_LOGIC;
        data : OUT STD_LOGIC_VECTOR(DATA_WIDTH - 1 DOWNTO 0)
    );
END ENTITY;

ARCHITECTURE behav OF dataTx IS

BEGIN
    PROCESS (rst, ack)
        FILE text_file : text OPEN read_mode IS file_name;
        VARIABLE ok : BOOLEAN;
        VARIABLE text_line : line;
        VARIABLE wait_time : TIME;
        VARIABLE data_line : bit_vector(DATA_WIDTH - 1 DOWNTO 0);
    BEGIN
        IF NOT endfile(text_file) THEN
            IF rst = '1' THEN
                readline(text_file, text_line);
                read(text_line, wait_time);
                read(text_line, data_line);
                data <= To_StdLogicVector(data_line);
                req <= '0', '1' after wait_time;
            ELSIF rising_edge(ack) THEN
                readline(text_file, text_line);
                read(text_line, wait_time);
                read(text_line, data_line);
                data <= To_StdLogicVector(data_line) after wait_time;
                req <= '0' after wait_time;
            ELSIF falling_edge(ack) THEN
                readline(text_file, text_line);
                read(text_line, wait_time);
                read(text_line, data_line);
                data <= To_StdLogicVector(data_line) after wait_time;
                req <= '1' after wait_time;
            END IF;
        END IF;
    END PROCESS;
END ARCHITECTURE;

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE ieee.math_real.ALL;
USE work.defs.ALL;
USE std.textio.ALL;

ENTITY dataRX IS
    GENERIC (
        file_name : STRING := "stimulus.txt"
    );

    PORT (
        rst : IN STD_LOGIC;
        req : IN STD_LOGIC;
        ack : OUT STD_LOGIC;
        data : IN STD_LOGIC_VECTOR(DATA_WIDTH - 1 DOWNTO 0)
    );
END ENTITY;

architecture behav of dataRx is
    
    begin
        process (rst, req)
        begin
            if rst = '1' then
                ack <= '0';
            elsif rising_edge(req) then
                ack <= '1' after 25 ns;
            elsif falling_edge(req) then
                ack <= '0' after 25 ns;
            end if;
        end process;
end architecture;