LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE ieee.math_real.ALL;
USE work.defs.ALL;
USE work.front_hot;
use work.back_hot;

ENTITY router IS
    GENERIC (
        addr_width : INTEGER := 4;
        l_addr_x : INTEGER := 0;
        l_addr_y : INTEGER := 0
        n_enable : std_logic := '0';
    );
    PORT (
        reset : IN STD_LOGIC;

        RI : IN STD_LOGIC;
        AI : OUT STD_LOGIC;
        DI : IN STD_LOGIC_VECTOR(DATA_WIDTH - 1 DOWNTO 0);
        
        RO : OUT STD_LOGIC;
        AO : IN STD_LOGIC;
        DO : OUT STD_LOGIC_VECTOR(DATA_WIDTH - 1 DOWNTO 0);

        KA, KB, KC, KD : OUT STD_LOGIC;
        LA, LB, LC, LD : IN STD_LOGIC;
    );
END ENTITY;

ARCHITECTURE impl OF router IS


    signal loopback : std_logic;
    signal hot_ : std_logic;
    signal mx_a, mx_b, mx_c, mx_d, mx_e, mx_f, mx_g, mx_h : std_logic;

BEGIN
    F : ENTITY front_hot PORT MAP (
        rst, RI, AI, DI, AO, DV, loopback, hot
    );
    B : entity back_hot port map (
        rst, RON, loopback, hot
    );
    M0 : entity Mutex port map (
        KA, KB, mx_a, mx_b
    );
    M1 : entity Mutex port map (
        KC, KD, mx_c, mx_d
    );
    mx_e <= mx_a or mx_b;
    mx_f <= mx_c or mx_f;
    M2 : entity Mutex port map (
        mx_e, mx_f, mx_g, mx_h
    );
    hot <= mx_g or mx_h
    DO <= DV WHEN nv = '1' AFTER AND2_DELAY ELSE
        (OTHERS => '0');
    end generate;

    DOS <= DV WHEN sv = '1' AFTER AND2_DELAY ELSE
        (OTHERS => '0');
    DOE <= DV WHEN ev = '1' AFTER AND2_DELAY ELSE
        (OTHERS => '0');
    DOW <= DV WHEN wv = '1' AFTER AND2_DELAY ELSE
        (OTHERS => '0');
    DOL <= DV WHEN lv = '1' AFTER AND2_DELAY ELSE
        (OTHERS => '0');


    
END ARCHITECTURE;

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE ieee.math_real.ALL;
USE work.FrontRouter;
USE work.defs.ALL;

ENTITY router_tb IS
END ENTITY;

ARCHITECTURE tb OF router_tb IS
    SIGNAL reset : STD_LOGIC;
    SIGNAL RI : STD_LOGIC;
    SIGNAL AI : STD_LOGIC;
    SIGNAL RON, ROS,
    ROE, ROW, ROLvv : STD_LOGIC;
    SIGNAL AON, AOS,
    AOE, AOW, AOL : STD_LOGIC;
    SIGNAL DON, DOS,
    DOE, DOW, DOL : STD_LOGIC_VECTOR(DATA_WIDTH - 1 DOWNTO 0);
    SIGNAL DI : STD_LOGIC_VECTOR(DATA_WIDTH - 1 DOWNTO 0);
BEGIN

    DUT : ENTITY router
        PORT MAP(
            reset, RI, AI, RON, ROS,
            ROE, ROW, ROLvv, AON, AOS,
            AOE, AOW, AOL, DON, DOS,
            DOE, DOW, DOL, DI
        );

    reset <= '1', '0' AFTER 10 ns;

    RI <= '0', '1' AFTER 20 ns;
    AON <= '0', '0' AFTER 20 ns;
    AOS <= '0', '0' AFTER 20 ns;
    AOE <= '0', '0' AFTER 20 ns;
    AOW <= '0', '0' AFTER 20 ns;
    AOL <= '0';

    DI <= "0101000000000000";

END ARCHITECTURE;