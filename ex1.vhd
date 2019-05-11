library ieee;
use ieee.std_logic_1164.all;

ENTITY ex1 IS
	GENRERIC{
				time_ms : integer := 100;
				freq_clk: integer := 50e6
	};
	PORT{
		  button : in std_logic;
		  clk : in std_logic;
		  led : out std_logic
	};
END ENTITY;

ARCHITECTURE arch OF ex1 IS
SIGNAL counter
SIGNAL estado: std_logic := 0; 
BEGIN
	PROCESS (clk,button)
		IF rising_edge(button) and estado == 0
			counter = 0;
			estado = 1
		END IF;
		
		IF estado == 1
			counter = counter + 1;
			IF counter >= (time_ms*freq_clk/1e3)
				counter = (time_ms*freq_clk/1e3);
				IF button == '1'
					led <= '1'
				END IF;
				IF falling_edge(button)
					estado = 0;
					led <= 0
				END IF;
			END IF;
		END IF;
	END PROCESS;
	
END ARCHITECTURE;