library verilog;
use verilog.vl_types.all;
entity ex2 is
    port(
        clk             : in     vl_logic;
        operation       : in     vl_logic_vector(2 downto 0);
        number          : in     vl_logic_vector(3 downto 0);
        ssd_saida       : out    vl_logic_vector(27 downto 0)
    );
end ex2;
