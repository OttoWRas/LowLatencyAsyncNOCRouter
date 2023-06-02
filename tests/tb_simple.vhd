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

ENTITY tb_simple IS
END ENTITY;

ARCHITECTURE impl OF tb_simple IS

    SIGNAL rst : STD_LOGIC;
    SIGNAL req_in : logic_arr := (others => '0');
    SIGNAL data_in : data_arr := (others => (others => '0'));
    SIGNAL data_out : data_arr := (others => (others => '0'));
    SIGNAL data_trimmed : data_arr := (others => (others => '0'));
    SIGNAL ack_out : logic_arr := (others => '0');
    SIGNAL ack_in : logic_arr := (others => '0');
    SIGNAL req_out : logic_arr := (others => '0');

BEGIN
        DUT : ENTITY router_top 
        generic map (
            rx => to_unsigned(1, 4),
            ry => to_unsigned(1, 4)
        )
        PORT MAP(
            rst => rst,
            req_in => req_in,
            data_in => data_in,
            ack_out => ack_out,
            ack_in => ack_in,
            req_out => req_out,
            data_out => data_out
        );
    
    data_trimmed(0) <= "00000000" & data_out(0)(DATA_WIDTH - 1 DOWNTO 8);
    data_trimmed(1) <= "00000000" & data_out(1)(DATA_WIDTH - 1 DOWNTO 8);
    data_trimmed(2) <= "00000000" & data_out(2)(DATA_WIDTH - 1 DOWNTO 8);
    data_trimmed(3) <= "00000000" & data_out(3)(DATA_WIDTH - 1 DOWNTO 8);
    data_trimmed(4) <= "00000000" & data_out(4)(DATA_WIDTH - 1 DOWNTO 8);

    TX : entity dataTx generic map (
        file_name => "simple_stimulus.txt"
    ) port map (
        rst, req_in(0), ack_in(0), data_in(0)
    );
    gen_loop_generateName : for i in 0 to 4 generate
        RX : entity dataRX port map (
            rst, req_out(i), ack_out(i), data_out(i)
        );
    end generate;
    
    rst <= '1', '0' AFTER 5 ns, '1' AFTER 500 ns;

END ARCHITECTURE;