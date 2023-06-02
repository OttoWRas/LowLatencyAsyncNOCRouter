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

ENTITY router_top_tb IS
END ENTITY;

ARCHITECTURE impl OF router_top_tb IS

    type logic_arr_l is array (0 to 3) of logic_arr;
    type data_arr_l is array (0 to 3) of data_arr;

    SIGNAL rst : STD_LOGIC;
    SIGNAL req_in : logic_arr_l := (others => (others => '0') );
    SIGNAL data_in : data_arr_l := (others => (others => (others => '0')) );
    SIGNAL data_out : data_arr_l := (others => (others => (others => '0')) );
    SIGNAL ack_out : logic_arr_l := (others => (others => '0') );
    SIGNAL ack_in : logic_arr_l := (others => (others => '0') );
    SIGNAL req_out : logic_arr_l := (others => (others => '0') );

BEGIN

    gen_network : for i in 0 to 3 generate
        DUT : ENTITY router_top 
        generic map (
            rx => to_unsigned(i mod 4, 4),
            ry => to_unsigned(i / 2, 4)
        )
        PORT MAP(
            rst => rst,
            req_in => req_in(i),
            data_in => data_in(i),
            ack_out => ack_out(i),
            ack_in => ack_in(i),
            req_out => req_out(i),
            data_out => data_out(i)
        );
    end generate;
    
    TX : entity dataTx generic map (
        file_name => "stimulus.txt"
    ) port map (
        rst, req_in(3)(0), ack_out(3)(0), data_in(3)(0)
    );

    RX : entity dataRX port map (
        rst, req_out(1)(3), ack_in(1)(3), data_out(1)(3)
    );

    req_in(3)(1) <=  req_out(1)(0);
    data_in(3)(1) <= data_out(1)(0);
    ack_in(3)(1) <= ack_out(1)(0);

    req_in(1)(0) <=  req_out(3)(1);
    data_in(1)(0) <= data_out(3)(1);
    ack_in(1)(0) <= ack_out(3)(1);

    req_in(2)(2) <= req_out(0)(0);
    data_in(2)(2) <= data_out(0)(0);
    ack_in(2)(2) <= ack_out(0)(0);

    req_in(0)(0) <= req_out(2)(2);
    data_in(0)(0) <= data_out(2)(2);
    ack_in(0)(0) <= ack_out(2)(2);

    req_in(0)(1) <= req_out(2)(3);
    data_in(0)(1) <= data_out(2)(3);
    ack_in(0)(1) <= ack_out(2)(3);

    req_in(2)(3) <= req_out(0)(1);
    data_in(2)(3) <= data_out(0)(1);
    ack_in(2)(3) <= ack_out(0)(1);

    req_in(3)(3) <= req_out(1)(2);
    data_in(3)(3) <= data_out(1)(2);
    ack_in(3)(3) <= ack_out(1)(2);

    req_in(1)(2) <= req_out(3)(3);
    data_in(1)(2) <= data_out(3)(3);
    ack_in(1)(2) <= ack_out(3)(3);

    rst <= '1', '0' AFTER 5 ns, '1' AFTER 500 ns;

END ARCHITECTURE;