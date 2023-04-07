LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE work.Async_Click.ALL;
USE work.internals.ALL;
USE work.defs.ALL;

ENTITY outport IS
    PORT (
        rst : IN STD_LOGIC;
        req_in : IN logic_arr;
        data_in : IN data_arr;
        ack_in : OUT logic_arr;
        req_out : OUT STD_LOGIC;
        ack_out : IN STD_LOGIC;
        data_out : OUT STD_LOGIC_VECTOR(DATA_WIDTH - 1 DOWNTO 0)
    );
END ENTITY;

ARCHITECTURE impl OF outport IS

    SIGNAL arb_r1 : STD_LOGIC;
    SIGNAL arb_a1 : STD_LOGIC;
    SIGNAL arb_d1 : STD_LOGIC_VECTOR(DATA_WIDTH - 1 DOWNTO 0);

    SIGNAL arb_r2 : STD_LOGIC;
    SIGNAL arb_a2 : STD_LOGIC;
    SIGNAL arb_d2 : STD_LOGIC_VECTOR(DATA_WIDTH - 1 DOWNTO 0);

BEGIN
    arb_1 : arbiter PORT MAP(
        rst, req_in(0), data_in(0), ack_in(0),
        req_in(1), data_in(1), ack_in(1),
        arb_r1, arb_d1, arb_a1

    );

    arb_2 : arbiter PORT MAP(
        rst, req_in(2), data_in(2), ack_in(2),
        req_in(3), data_in(3), ack_in(3),
        arb_r2, arb_d2, arb_a2
    );

    arb_3 : arbiter PORT MAP(
        rst, arb_r1, arb_d1, arb_a1,
        arb_r2, arb_d2, arb_a2,
        req_out, data_out, ack_out
    );
END ARCHITECTURE;