library IEEE;
use IEEE.std_logic_1164.all;
use work.defs.all;
use work.Async_Click.all;

package internals is
    type logic_arr is array (0 to 4) of std_logic;
    type data_arr is array (0 to 4) of std_logic_vector(DATA_WIDTH - 1 downto 0);
    type logic_arr_l is array (0 to 4) of logic_arr;
    type data_arr_l is array (0 to 4) of data_arr;
end package;