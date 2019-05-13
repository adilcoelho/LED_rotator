library verilog;
use verilog.vl_types.all;
entity ex2 is
    port(
        clk             : in     vl_logic;
        speed           : in     vl_logic_vector(2 downto 0);
        reverse         : in     vl_logic;
        tail_size_control: in     vl_logic_vector(1 downto 0);
        led             : out    vl_logic_vector(9 downto 0)
    );
end ex2;
