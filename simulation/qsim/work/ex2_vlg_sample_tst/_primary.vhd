library verilog;
use verilog.vl_types.all;
entity ex2_vlg_sample_tst is
    port(
        clk             : in     vl_logic;
        reverse         : in     vl_logic;
        speed           : in     vl_logic_vector(2 downto 0);
        tail_size_control: in     vl_logic_vector(1 downto 0);
        sampler_tx      : out    vl_logic
    );
end ex2_vlg_sample_tst;
