LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE ieee.math_real.ALL;
USE work.internals.ALL;
USE work.defs.ALL;
USE work.delay_element;

ENTITY routing IS
    GENERIC (
        -- The internal id / position of the router
        rx : INTEGER := 0;
        ry : INTEGER := 0
    );
    PORT (
        req_in : IN STD_LOGIC;
        data_in : IN STD_LOGIC_VECTOR(DATA_WIDTH - 1 DOWNTO 0);
        req_out : OUT logic_arr
    );
END ENTITY;

ARCHITECTURE impl OF routing IS

    SIGNAL Xi : unsigned(3 DOWNTO 0);
    SIGNAL Yi : unsigned(3 DOWNTO 0);
    SIGNAL req_inter : logic_arr;
    SIGNAL req_d : STD_LOGIC;

BEGIN

    delay : entity delay_element
        GENERIC MAP(
            size => 4-- Delay  size
        )
        PORT MAP(
            d => req_in,
            z => req_d
        );

    Xi <= unsigned(data_in(7 DOWNTO 4));
    Yi <= unsigned(data_in(3 DOWNTO 0));

    req_inter(0) <= '1' AFTER AND2_DELAY WHEN Xi < rx ELSE
    '0' AFTER AND2_DELAY;
    req_inter(1) <= '1' AFTER AND2_DELAY WHEN Xi > rx ELSE
    '0' AFTER AND2_DELAY;
    req_inter(2) <= '1' AFTER AND3_DELAY WHEN (Xi = rx) AND (Yi > ry) ELSE
    '0' AFTER AND3_DELAY;
    req_inter(3) <= '1' AFTER AND3_DELAY WHEN (Xi = rx) AND (Yi < ry) ELSE
    '0' AFTER AND3_DELAY;
    req_inter(4) <= '1' AFTER AND3_DELAY WHEN (Xi = rx) AND (Yi = ry) ELSE
    '0' AFTER AND3_DELAY;

    req : FOR i IN 0 TO 4 GENERATE
        req_out(i) <= req_d AND req_inter(i);
    END GENERATE;

END ARCHITECTURE;