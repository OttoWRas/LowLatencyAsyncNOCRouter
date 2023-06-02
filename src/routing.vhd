LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE ieee.math_real.ALL;
USE work.internals.ALL;
USE work.defs.ALL;
USE work.delay_element;
USE work.oh_4_demux;
USE work.fork;

ENTITY routing IS
    GENERIC (
        -- The internal id / position of the router
        inport : INTEGER := 0;
        rx : unsigned(3 DOWNTO 0);
        ry : unsigned(3 DOWNTO 0)
    );
    PORT (
        rst : IN STD_LOGIC;
        req_in : IN STD_LOGIC;
        ack_in : OUT STD_LOGIC;
        data_in : IN STD_LOGIC_VECTOR(DATA_WIDTH - 1 DOWNTO 0) := (others => '0');
        out_req : OUT logic_arr_s;
        out_data : OUT data_arr_s;
        out_ack : IN logic_arr_s
    );
END ENTITY;

ARCHITECTURE impl OF routing IS

    SIGNAL Xi : unsigned(3 DOWNTO 0) := (others => '0');
    SIGNAL Yi : unsigned(3 DOWNTO 0) := (others => '0');
    SIGNAL req_inter : STD_LOGIC_VECTOR(4 DOWNTO 0) := (others => '0');
    SIGNAL selector : std_logic_vector(3 downto 0);
    SIGNAL req_a, req_b : STD_LOGIC;
    SIGNAL ack_a, ack_b : STD_LOGIC;

BEGIN

    oh_dmux : ENTITY oh_4_demux PORT MAP (
        rst, req_a, data_in, ack_in,
        selector,
        out_req(0), out_data(0), out_ack(0),
        out_req(1), out_data(1), out_ack(1),
        out_req(2), out_data(2), out_ack(2),
        out_req(3), out_data(3), out_ack(3)
        );

    d : ENTITY delay_element
        GENERIC MAP(
            size => 6 -- Delay size
        )
        PORT MAP(
            req_in,
            req_a
        );

    Yi <= unsigned(data_in(7 DOWNTO 4));
    Xi <= unsigned(data_in(3 DOWNTO 0));

        NORTH_GEN : IF inport /= 0 GENERATE
            req_inter(0) <= '1' AFTER AND2_DELAY WHEN Yi > ry ELSE
            '0' AFTER AND2_DELAY;
        END GENERATE NORTH_GEN;

        EAST_GEN : IF inport /= 1 GENERATE
            req_inter(1) <= '1' AFTER AND3_DELAY WHEN (Yi = ry) AND (Xi > rx) ELSE
        '0' AFTER AND3_DELAY;
        END GENERATE EAST_GEN;

        SOUTH_GEN : IF inport /= 2 GENERATE
            req_inter(2) <= '1' AFTER AND2_DELAY WHEN Yi < ry ELSE
            '0' AFTER AND2_DELAY;
        END GENERATE SOUTH_GEN;

        WEST_GEN : IF inport /= 3 GENERATE
            req_inter(3) <= '1' AFTER AND3_DELAY WHEN (Yi = ry) AND (Xi < rx) ELSE
            '0' AFTER AND3_DELAY;
        END GENERATE WEST_GEN;

        LOCAL_GEN : IF inport /= 4 GENERATE
            req_inter(4) <= '1' AFTER AND3_DELAY WHEN (Yi = ry) AND (Xi = rx) ELSE
            '0' AFTER AND3_DELAY;
        END GENERATE LOCAL_GEN;

        COUPLE_GEN : for i in 0 to 3 generate
            M : IF (i < inport) generate
                selector(i) <= req_inter(i);
            end generate M; 
            N : IF (i >= inport) generate
                selector(i) <= req_inter(i+1);
            end generate N;
        end generate COUPLE_GEN;

END ARCHITECTURE;