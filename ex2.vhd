library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

ENTITY ex2 IS
	GENERIC(
				time_m : integer := 1;
				freq_clk: integer := 1e3;
				NLED: integer := 10
	);
	PORT(
		  clk : IN STD_LOGIC;
		  speed :  IN STD_LOGIC_VECTOR(2 DOWNTO 0);
		  reverse : IN STD_LOGIC;
		  tail_size_control : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
		  led : OUT STD_LOGIC_VECTOR(NLED-1 DOWNTO 0)
	);
END ENTITY;

ARCHITECTURE arch OF ex2 IS
	COMPONENT debounce IS
		GENERIC(
				time_ms : integer := 1;
				freq_clk: integer := 1e3	     
		);
		PORT(
  		  button : in std_logic;
		  clk : in std_logic;
		  debounced_out : out std_logic
		);
	END COMPONENT;
	
SIGNAL reverse_out, sentido, rabomais, rabomenos: std_LOGIC;
SIGNAL N : integer;
BEGIN
	debounce_reverse : debounce port map(button => reverse, clk => clk, debounced_out => reverse_out);
	debounce_rabomais : debounce port map(button => tail_size_control(1), clk => clk, debounced_out => rabomais); -- tail...(1) aumenta rabo
	debounce_rabomenos : debounce port map(button => tail_size_control(0), clk => clk, debounced_out => rabomenos); -- tail...(0) diminui rabo
	
--MOVIMENTO DA TRILHA
PROCESS(clk,reverse_out, rabomais, rabomenos)
	VARIABLE speed_count : integer := to_integer(unsigned(speed));
	VARIABLE counter_max: integer := (time_m/2*speed_count+2) * (freq_clk /1e3);
	VARIABLE counter: integer := 0;
	VARIABLE sentido: STD_LOGIC := '0';
	VARIABLE vetor_leds: UNSIGNED(NLED-1 downto 0) := (others => '0');
	VARIABLE posicao : integer  range NLED-1 downto 0  := 0;
	VARIABLE tamanho_rabo: integer range NLED - 2 downto 0 := 0;
	BEGIN
	IF rising_edge(reverse_out) THEN
	  sentido := not(sentido);
	END IF;

	
	IF rising_edge(clk) THEN

		IF rabomais = '1' THEN
			IF tamanho_rabo < NLED-2 THEN
				tamanho_rabo := tamanho_rabo + 1;
			END IF;
		END IF;

		IF rabomenos = '1' THEN
			IF tamanho_rabo > 0 THEN
				tamanho_rabo := tamanho_rabo - 1;
			END IF;
		END IF;
		
		vetor_leds := (others => '0');
		vetor_leds(tamanho_rabo downto 0) := (others => '1');
		IF counter < counter_max THEN
			counter := counter + 1;	
		ELSE
			counter := 0;
			IF sentido = '0' THEN -- sentido 0: antihorario, 1: horario num vetor de leds dobrado com os lados pra baixo
					
					IF posicao = NLED-1 THEN
						posicao := 0;
					ELSE
						posicao := posicao + 1;
					END IF;
			ELSE
					
					IF posicao = 0 THEN
						posicao := NLED-1;
					else
						posicao := posicao - 1;
					END IF;
			END IF;
		END IF;
	END IF;
	led <= std_logic_vector(vetor_leds ROL posicao);
END PROCESS;

END ARCHITECTURE;