library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity pc is
  port(
     clk,rst, ex1, ex2, freeze, Cond, isLongInst : in std_logic;        -- control signals (along with pc_src)
     pc_src: in std_logic_vector(1 downto 0);
     ex1_addr: in std_logic_vector(31 downto 0);                        
     ex2_addr: in std_logic_vector(31 downto 0);    
     data_32: in std_logic_vector(31 downto 0);
     extended_Rsrc: in std_logic_vector(31 downto 0);
     next_addr : out std_logic_vector(31 downto 0)
  );
end pc;

architecture a_pc of pc is
   signal current_pc: std_logic_vector( 31 downto 0) := X"00000000";
   -- the two following signals and the portmap were used to test the pc/inst. memory integration.
   signal inst : std_logic_vector(15 downto 0);
   signal imm : std_logic_vector(15 downto 0);
begin
   inst_mem: ENTITY work.inst_memory PORT MAP (clk, current_pc, inst, imm );
  process (clk,rst)
     begin
         if rst = '1' then                    
           current_pc <= X"00000000";         -- may need to be changed to X"00000006" (exceptions)
         elsif rising_edge(clk) then
            if ex1 = '1' then
               current_pc <= ex1_addr; 
            elsif ex2 = '1' then
               current_pc <= ex2_addr;
            elsif freeze = '1' then
               current_pc <= current_pc;
            elsif Cond='1' and pc_src="01" then
               current_pc <= data_32;
            elsif Cond='1' and pc_src="10" then
               current_pc <= extended_Rsrc;
            elsif isLongInst='1' then
               current_pc <= std_logic_vector(unsigned(current_pc) + 2);
            else
               current_pc <= std_logic_vector(unsigned(current_pc) + 1);
            end if;
         end if;
  end process;
  next_addr <= current_pc;

  
end a_pc;