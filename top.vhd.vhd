----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    12:34:36 04/04/2018 
-- Design Name: 
-- Module Name:    top- Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;    -- needed for +/- operations

-- Input/output description
entity top is
    port (
        BTN0: in std_logic;
        CLK: in std_logic;
        LED: out std_logic_vector(3 downto 0);
        D_POS: out std_logic_vector(3 downto 0);
        D_SEG: out std_logic_vector(6 downto 0)
    );
end prac8;

-- Internal structure description
architecture Behavioral of prac8 is
    -- internal signal definitions
    signal clk_500: std_logic := '0';
    signal tmp_500: std_logic_vector(11 downto 0) := x"000";    -- hexadecimal value
    signal clk_250: std_logic := '0';
    signal tmp_250: std_logic_vector(11 downto 0) := x"000";
     signal clk_10: std_logic := '0';
    signal tmp_10: std_logic_vector(11 downto 0) := x"000";
    signal dec: std_logic_vector(3 downto 0) := "0010";         -- binary value
    signal dec1: std_logic_vector(3 downto 0) := "1111"; 
   signal hex: std_logic_vector(3 downto 0) := "0010";
   
     signal hola: std_logic := '0';
   signal position: std_logic_vector(3 downto 0) := "0111";
    signal cnt: std_logic_vector(3 downto 0) := "0001";
      
   signal mask: std_logic_vector(3 downto 0) := "1100";
   signal enable: std_logic := '1';
      signal display: std_logic_vector (1 downto 0):= "00";
	  
	 signal f0: std_logic_vector(3 downto 0) := "0000";
	  signal f1: std_logic_vector(3 downto 0) := "0001";
	   signal f2: std_logic_vector(3 downto 0) := "0000";
	    signal f3: std_logic_vector(3 downto 0) := "0000";
		signal f0reserva: std_logic_vector(3 downto 0) := "0000";
		signal f1reserva: std_logic_vector(3 downto 0) := "0000";
		signal f2reserva: std_logic_vector(3 downto 0) := "0000";
		signal f3reserva: std_logic_vector(3 downto 0) := "0000";
			signal foreserva: std_logic_vector(3 downto 0) := "0000";
    
begin
    -----------------------------
    -- clock divider to 500 ms --
      process (CLK)
    begin
        if rising_edge(CLK) then
            tmp_250 <= tmp_250 + 1;
            if tmp_250 = x"4e2" then
                tmp_250 <= x"000";
                clk_250 <= not clk_250;
            end if;
        end if;
    end process;

     process (CLK)
    begin
        if rising_edge(CLK) then
            tmp_10 <= tmp_10 + 1;
            if tmp_10 = x"fff" then
                tmp_10 <= x"000";
                clk_10 <= not clk_10;
            end if;
        end if;
    end process;
    -----------------------------
    -- increment auxiliary counter every rising edge of CLK
    -- if you meet half a period of 500 ms invert clk_500
    process (CLK)
    begin
        if rising_edge(CLK) then
            tmp_500 <= tmp_500 + 1;
            if tmp_500 = x"9c4" then
                tmp_500 <= x"000";
                clk_500 <= not clk_500;
            end if;
        end if;
    end process;

    ---------------------
    -- decimal counter --
    ---------------------
--    process (clk_500)
--    begin
--        if rising_edge(clk_500) then
--            if BTN0 = '0' then      -- synchronous RESET
--                dec <= "0000";
--            else
--                dec <= dec + 1;     -- decimal counter
--                if dec >= "1001" then
--                    dec <= "0000";
--                 end if;   
--                -- ...WRITE CODE HERE...
--            end if;
--        end if;
--    end process;
--
--
--
process (clk_500)
    begin
        if rising_edge(clk_500) then
            if BTN0 = '0' then 
                dec <= "0000";
            else 
		
			-- shift register
			dec1(3 downto 1) <= dec(2 downto 0);			
			dec(0) <= dec(2) XOR dec(1) ;
			dec(3 downto 1) <= dec1(3 downto 1);

			-- representacion 
					if display= "00"  then  
						if dec(3) = '0' then
							hex <= "0000";
							position <= "0111"; 
							display <=  "01" ; 
						elsif dec(3) = '1' then	
							hex <= "0001";
							position <= "0111";
							display <= "01" ; 
					     end if ;
					end if ;
					if display= "01"  then  
						if dec(2) = '0' then
							hex <= "0000";
							position <= "1011";
							display <= "10" ;							
						elsif dec(2) = '1' then	
							hex <= "0001";
							position <= "1011";
							display <= "10" ;
					     end if ;
					end if ;
					if display= "10"  then  
						if dec(1) = '0' then
							hex <= "0000";
							position <= "1101"; 
							display <= "11" ;
						elsif dec(1) = '1' then	
							hex <= "0001";  
							position <= "1101";
							display <= "11" ;
					     end if ;
					end if ;
					if display= "11" then  
						if dec(0) = '0' then
							hex <= "0000";
							position <= "1110"; 
							display <= "00" ;
						elsif dec(0) = '1' then	
							hex <= "0001";
							position <= "1110";
							display <= "00" ;
							
					     end if ;
					end if ;
					
               

				
                 end if;   
                
            end if;
		--end if;
    end process;  

    

    --------------------------------------
    -- counter to seven-segment display --
    --------------------------------------

  D_POS <= position;
  
    with hex select                         --          0
        D_SEG <= "1111001" when "0001",     -- 1       ---
                 "0100100" when "0010",     -- 2    5 |   | 1
                 "0110000" when "0011",     -- 3       ---   <- 6
                 "0011001" when "0100",     -- 4    4 |   | 2
                 "0010010" when "0101",     -- 5       ---
                 "0000010" when "0110",     -- 6        3
                 "1111000" when "0111",     -- 7
                 "0000000" when "1000",     -- 8
                 "0011000" when "1001",     -- 9
                 "0001000" when "1010",     -- A
                 "0000011" when "1011",     -- B
                 "1000110" when "1100",     -- C
                 "0100001" when "1101",     -- D
                 "0000110" when "1110",     -- E
                 "0001110" when "1111",     -- F                                 

                 -- ...WRITE CODE HERE...
                 "1000000" when others;     -- 0

    -- only one seven-segment display is used; active low
    
    

    -----------------------------------
    -- display counter value at LEDs --
    -----------------------------------
    LED <= not dec1;
end Behavioral;


