library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity EX_Stage is
    port(
        -- ID/EX buffer
        ID_EX: in std_logic_vector (127 downto 0);
        --EX/MEM buffer
        EX_MEM: out std_logic_vector (127 downto 0);
    );
end EX_Stage;
