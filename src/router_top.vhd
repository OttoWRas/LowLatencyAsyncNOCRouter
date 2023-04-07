LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE work.Async_Click.ALL;
USE work.internals.ALL;
USE work.defs.ALL;
USE work.outport;
USE work.routing;

ENTITY router_top IS
    GENERIC (
        rx : INTEGER := 0;
        ry : INTEGER := 0
    );
    PORT (
        rst : IN STD_LOGIC;
        req_in : IN logic_arr;
        ack_in : OUT logic_arr;
        data_in : IN data_arr;
        req_out : OUT logic_arr;
        ack_out : IN logic_arr;
        data_out : OUT data_arr
    );
END ENTITY;

ARCHITECTURE impl OF router_top IS

    SIGNAL req_inter : logic_arr;
    SIGNAL ack_inter : logic_arr;
    SIGNAL data_inter : data_arr;

    SIGNAL req_inter_mid : logic_arr_l;
    SIGNAL req_inter_out : logic_arr_l;

    SIGNAL data_inter_mid : data_arr_l;
    SIGNAL data_inter_out : data_arr_l;

BEGIN

    click_elems : FOR i IN 0 TO 4 GENERATE
        c : click_element PORT MAP(
            rst, ack_in(i), req_in(i), data_in(i),
            req_inter(i), data_inter(i), ack_inter(i)
        );
    END GENERATE;

    routing_block : FOR i IN 0 TO 4 GENERATE
        b : ENTITY routing GENERIC MAP(
            rx => rx,
            ry => ry)
            PORT MAP(
                req_inter(i), data_inter(i), req_inter_mid(i)
            );
    END GENERATE;

    outerloop : FOR i IN 0 TO 4 GENERATE
        innerloop : FOR j IN 0 TO 4 GENERATE
            req_inter_out(i)(j) <= req_inter_mid(j)(i);
        END GENERATE;
    END GENERATE;

    out_block : FOR i IN 0 TO 4 GENERATE
        o : ENTITY outport PORT MAP(
            rst, req_inter_out(i), data_inter, ack_inter,
            req_out(i), ack_out(i), data_out(i)
            );
    END GENERATE;

END ARCHITECTURE;