LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE ieee.math_real.ALL;
USE std.textio.ALL;
USE work.internals.ALL;
USE work.defs.ALL;
USE work.router_top;
USE work.dataTx;
USE work.dataRx;

ENTITY tb_performance IS
END ENTITY;

ARCHITECTURE impl OF tb_performance IS

    type logic_arr_l is array (0 to 2) of logic_arr;
    type data_arr_l is array (0 to 2) of data_arr;

    SIGNAL rst : STD_LOGIC;
    SIGNAL req_in : logic_arr_l := (others => (others => '0') );
    SIGNAL data_in : data_arr_l := (others => (others => (others => '0')) );
    SIGNAL data_out : data_arr_l := (others => (others => (others => '0')) );
    SIGNAL ack_out : logic_arr_l := (others => (others => '0') );
    SIGNAL ack_in : logic_arr_l := (others => (others => '0') );
    SIGNAL req_out : logic_arr_l := (others => (others => '0') );

BEGIN
    LINK1 : ENTITY router_top
        GENERIC MAP(
            rx => to_unsigned(1, 4),
            ry => to_unsigned(1, 4)
        )
        PORT MAP(
            rst => rst,
            req_in => req_in(0),
            data_in => data_in(0),
            ack_out => ack_out(0),
            ack_in => ack_in(0),
            req_out => req_out(0),
            data_out => data_out(0)
        );
    DUT : ENTITY router_top
        GENERIC MAP(
            rx => to_unsigned(2, 4),
            ry => to_unsigned(1, 4)
        )
        PORT MAP(
            rst => rst,
            req_in => req_in(1),
            data_in => data_in(1),
            ack_out => ack_out(1),
            ack_in => ack_in(1),
            req_out => req_out(1),
            data_out => data_out(1)
        );
    LINK2 : ENTITY router_top
        GENERIC MAP(
            rx => to_unsigned(3, 4),
            ry => to_unsigned(1, 4)
        )
        PORT MAP(
            rst => rst,
            req_in => req_in(2),
            data_in => data_in(2),
            ack_out => ack_out(2),
            ack_in => ack_in(2),
            req_out => req_out(2),
            data_out => data_out(2)
        );

    req_in(1)(3) <=  req_out(0)(1);
    data_in(1)(3) <= data_out(0)(1);
    ack_out(0)(1) <= ack_in(1)(3);

    req_in(2)(3) <=  req_out(1)(1);
    data_in(2)(3) <= data_out(1)(1);
    ack_out(1)(1) <= ack_in(2)(3);

    TX : ENTITY dataTx GENERIC MAP (
        file_name => "performance_stimulus.txt"
        ) PORT MAP (
        rst, req_in(0)(3), ack_in(0)(3), data_in(0)(3)
        );
    RX : ENTITY dataRX PORT MAP (
        rst, req_out(2)(1), ack_out(2)(1), data_out(2)(1)
    );

    rst <= '1', '0' AFTER 5 ns, '1' AFTER 500 ns;

END ARCHITECTURE;