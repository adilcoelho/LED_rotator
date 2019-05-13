library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

ENTITY ex2 IS
	GENERIC(
				time_m : integer := 10000;
				freq_clk: integer := 50
	);
	PORT(
		  clk : IN STD_LOGIC;
		  speed :  IN STD_LOGIC_VECTOR(2 DOWNTO 0);
		  reverse : IN STD_LOGIC;
		  tail_size_control : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
		  led : OUT STD_LOGIC_VECTOR(9 DOWNTO 0)
	);
END ENTITY;

ARCHITECTURE arch OF ex2 IS
	COMPONENT debounce IS
		GENERIC(
				time_ms : integer := 100;
				freq_clk: integer := 50e6	     
		);
		PORT(
  		  button : in std_logic;
		  clk : in std_logic;
		  debounced_out : out std_logic
		);
	END COMPONENT;
	
SIGNAL reverse_out, sentido, rabo, rastro: std_LOGIC;
SIGNAL N : integer;
BEGIN
	debounce_reverse : debounce port map(button => reverse, clk => clk, debounced_out => reverse_out);
	debounce_rabo : debounce port map(button => tail_size_control(1), clk => clk, debounced_out => rabo);
	debounce_rastro : debounce port map(button => tail_size_control(0), clk => clk, debounced_out => rastro);
	
--MOVIMENTO DA TRILHA
PROCESS(clk,reverse_out, rabo, rastro)
	VARIABLE speed_count : integer := to_integer(unsigned'('0' & speed(0))) + to_integer(unsigned'('0' & speed(1))) + to_integer(unsigned'('0' & speed(2)));
	VARIABLE counter_max: integer := (time_m/2*speed_count+2) * (freq_clk /1e3);
	VARIABLE counter: integer := 0;
	VARIABLE sentido: std_LOGIC := '0';
	VARIABLE led_out : STD_LOGIC_VECTOR(9 DOWNTO 0):= "0000000001";
	VARIABLE N : integer := 4;
	BEGIN
	IF rising_edge(reverse_out) THEN
	  sentido := not(sentido);
	END IF;
	
	IF clk'event and clk = '1' THEN
		IF counter < counter_max THEN
			counter := counter + 1;	
		ELSE
			counter := 0;
			IF sentido = '0' THEN
					If led_out(N) = '1' THEN
						led_out(N downto 1) := led_out(N-1 downto 0);
						led_out(0) := '1';
					ELSE
						led_out(N downto 1) := led_out(N-1 downto 0);
						led_out(0) := '0';
					END IF;
				
			ELSE
					If led_out(0) = '1' THEN
						led_out(N-1 downto 0) := led_out(N downto 1);
						led_out(N) := '1';
					ELSE
						led_out(N-1 downto 0) :=  led_out(N downto 1);
						led_out(N) :=  '0';
					END IF;
			END IF;
		END IF;
	END IF;
	led <= led_out;
END PROCESS;

END ARCHITECTURE;