library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity inst_memory is
	port (
		clk : in std_logic;--falling edge
		pc : in std_logic_vector(31 downto 0);
		instruction : out std_logic_vector(15 downto 0);
      immediate : out std_logic_vector(15 downto 0)
	);
	
end inst_memory;
architecture a_inst_memory of inst_memory is
	type ram_type is array (0 to 2 ** 20 - 1) of std_logic_vector(15 downto 0);
	signal inst : std_logic_vector(15 downto 0);
   signal imm : std_logic_vector(15 downto 0);
   signal ram_data: ram_type:=(
      x"0000",
      x"0000",
      x"0100",--exception 1
      x"0000",
      x"0150",--exception 2
      x"0000",
      x"008e",
x"010e",
x"018e",
x"020e",
x"1001",
x"041b",
x"048c",
x"0008",
x"0008",
x"0008",
x"a693",
x"0818",
x"018a",
x"0008",
x"0008",
x"0008",
x"0008",
x"0008",
x"0008",
x"0008",
x"0008",
x"0008",
x"0008",
x"0418",
x"0c1a",
x"168b",
x"030e",
x"1819",
x"048c",
x"0008",
x"0008",
x"0008",
x"0008",
x"0008",
x"0008",
x"0008",
x"0008",
x"0008",
x"0008",
x"0008",
x"018a",
x"0302",
x"1b0c",
x"0188",
x"0188",
x"0188",
x"0188",

      others => (others=>'0')
  );
begin

	process (clk)
	begin
		if rising_edge(clk) then
			inst <= ram_data(to_integer(unsigned(pc)));
         imm <= ram_data(to_integer(unsigned(pc) + 1));
		end if;
	end process;
   instruction <= inst;
	immediate <= imm;

end a_inst_memory;