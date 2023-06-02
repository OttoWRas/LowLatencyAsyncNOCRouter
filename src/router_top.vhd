LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE ieee.math_real.ALL;

USE work.Async_Click.ALL;
USE work.internals.ALL;
USE work.defs.ALL;
USE work.outport;
USE work.routing;

ENTITY router_top IS
    GENERIC (
        rx : unsigned(3 DOWNTO 0) := (others => '0');
        ry : unsigned(3 DOWNTO 0) := (others => '0')
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
    SIGNAL ack_inter : logic_arr := (others => '0' );
    SIGNAL data_inter : data_arr := (others => (others => '0') );

    SIGNAL req_inter_mid : logic_arr_l;
    SIGNAL req_inter_out : logic_arr_l;
    SIGNAL data_inter_mid : data_arr_l;
    SIGNAL data_inter_out : data_arr_l;
    SIGNAL ack_inter_mid : logic_arr_l;
    SIGNAL ack_inter_out : logic_arr_l;

BEGIN

    click_elems : FOR i IN 0 TO 4 GENERATE
        c : click_element PORT MAP(
            rst, ack_in(i), req_in(i), data_in(i),
            req_inter(i), data_inter(i), ack_inter(i)
        );
    END GENERATE;

    routing_block : FOR i IN 0 TO 4 GENERATE
        b : ENTITY routing GENERIC MAP(
            inport => i,
            rx => rx,
            ry => ry)
            PORT MAP(
                rst, req_inter(i), ack_inter(i), data_inter(i),
                req_inter_mid(i), data_inter_mid(i), ack_inter_mid(i) 
            );
    END GENERATE;

    outerloop : FOR i IN 0 TO 4 GENERATE
        innerloop : FOR j IN 0 TO 4 GENERATE
                A : IF (i /= j) generate
                    B : IF (i > j) generate
                        req_inter_out(j)(i-1) <= req_inter_mid(i)(j);
                        ack_inter_mid(i)(j) <= ack_inter_out(j)(i-1);
                        data_inter_out(j)(i-1) <= data_inter_mid(i)(j);
                    end generate B;
                    C : IF (i < j) generate
                        req_inter_out(j)(i) <= req_inter_mid(i)(j-1);
                        ack_inter_mid(i)(j-1) <= ack_inter_out(j)(i);
                        data_inter_out(j)(i) <= data_inter_mid(i)(j-1);
                    end generate C;
                end generate A;
        END GENERATE;
    END GENERATE;

    out_block : FOR i IN 0 TO 4 GENERATE
        o : ENTITY outport PORT MAP(
            rst, req_inter_out(i), data_inter_out(i), ack_inter_out(i),
            req_out(i), ack_out(i), data_out(i)
            );
    END GENERATE;

END ARCHITECTURE;