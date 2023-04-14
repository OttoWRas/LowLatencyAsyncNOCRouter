LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE ieee.math_real.ALL;
LIBRARY STD;
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

BEGIN
    
    DUT : ENTITY router_top PORT MAP(
        rst => rst,
        req_in => req_in,
        data_in => data_in,
        ack_out => ack_out
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

    data_in(0) <= "0011001000001111";
    data_in(1) <= "0010011000001111";
    data_in(2) <= "0010011000001111";
    data_in(3) <= "0100001000001111";
    data_in(4) <= "0000001100001111";

END ARCHITECTURE;