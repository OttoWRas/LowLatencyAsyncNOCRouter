library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;
use work.Async_Click.all;
use work.internals.all;
use work.defs.all;

entity routing is
    generic (
        -- The internal id / position of the router
        rx : INTEGER := 0;
        ry : INTEGER := 0
    );
    port (
        req_in : in std_logic;
        data_in : IN std_logic_vector(DATA_WIDTH - 1 DOWNTO 0);
        req_out : OUT logic_arr
    );
end entity;

architecture impl of routing is
    
    signal Xi : unsigned(3 downto 0);
    signal Yi : unsigned(3 DOWNTO 0);

    begin
        
    Xi <= unsigned(data_in(7 DOWNTO 4));
    Yi <= unsigned(data_in(3 DOWNTO 0));

    req_out(0) <= req_in WHEN Xi < rx ELSE '0' AFTER AND2_DELAY ;
    req_out(1) <= req_in WHEN Xi > rx ELSE '0' AFTER AND2_DELAY ;
    req_out(2) <= req_in WHEN (Xi = rx) AND (Yi > ry) ELSE '0' AFTER AND2_DELAY ;
    req_out(3) <= req_in WHEN (Xi = rx) AND (Yi < ry) ELSE '0' AFTER AND2_DELAY ;
    req_out(4) <= req_in WHEN (Xi = rx) AND (Yi = ry) ELSE '0' AFTER AND2_DELAY ;
    
end architecture;