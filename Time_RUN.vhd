Library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;

Entity Time_RUN is
Port(
	CLK,Rstb : in std_logic;
	i1s : in std_logic;
	iPush : in std_logic;
	oDigit1,oDigit2,oDigit3,oDigit4 : out std_logic_vector(3 downto 0);
	stop : out std_logic
);
End Time_RUN;

Architecture Behavioral of Time_RUN is
	signal wDigit1,wDigit2,wDigit3,wDigit4 : std_logic_vector(3 downto 0);
	signal wPush,wStop : std_logic := '0';
Begin

	oDigit1 <= wDigit1;
	oDigit2 <= wDigit2;
	oDigit3 <= wDigit3;
	oDigit4 <= wDigit4;
	
	stop <= wStop;
	
	u_Push : Process(CLK,Rstb)
	Begin
		if(Rstb='0') then
			wPush <= '0';
			wStop <= '0';
		elsif(rising_edge(CLK)) then
			if(iPush='1') then
				wPush <= not wPush;
				wStop <= '0';
			elsif(wDigit1=9 and wDigit2=9 and wDigit3=5 and wDigit4=9) then
				wPush <= '0';
				wStop <= '1';
			else
				wPush <= wPush;
				wStop <= wStop;
			end if;
		end if;
	end Process;
	
	u_Time : Process(CLK,Rstb,wPush)
	Begin
		if(Rstb='0') then
			wDigit1 <= (others => '0');
			wDigit2 <= (others => '0');
			wDigit3 <= (others => '0');
			wDigit4 <= (others => '0');
		elsif(rising_edge(CLK) and wPush='1') then
			
			---------- Digit1 ----------
			if(i1s='1' and wDigit1=9) then
				wDigit1 <= wDigit1;
			elsif(i1s='1' and wDigit2=9 and wDigit3=5 and wDigit4=9) then
				wDigit1 <= wDigit1 + 1;
			else
				wDigit1 <= wDigit1;
			end if;
			
			---------- Digit2 ----------
			if(i1s='1' and wDigit1=9 and wDigit2=9) then
				wDigit2 <= wDigit2;
			elsif(i1s='1' and wDigit2=9 and wDigit3=5 and wDigit4=9) then
				wDigit2 <= (others => '0');
			elsif(i1s='1' and wDigit3=5 and wDigit4=9) then
				wDigit2 <= wDigit2 + 1;
			else
				wDigit2 <= wDigit2;
			end if;
			
			---------- Digit3 ----------
			if(i1s='1' and wDigit1=9 and wDigit2=9 and wDigit3=5) then
				wDigit3 <= wDigit3;
			elsif(i1s='1' and wDigit3=5 and wDigit4=9) then
				wDigit3 <= (others => '0');
			elsif(i1s='1' and wDigit4=9) then
				wDigit3 <= wDigit3 + 1;
			else
				wDigit3 <= wDigit3;
			end if;
			
			---------- Digit4 ----------
			if(i1s='1' and wDigit1=9 and wDigit2=9 and wDigit3=5 and wDigit4=9) then
				wDigit4 <= wDigit4;
			elsif(i1s='1' and wDigit4=9) then
				wDigit4 <= (others => '0');
			elsif(i1s='1') then
				wDigit4 <= wDigit4 + 1;
			else
				wDigit4 <= wDigit4;
			end if;
		else
			wDigit1 <= wDigit1;
			wDigit2 <= wDigit2;
			wDigit3 <= wDigit3;
			wDigit4 <= wDigit4;
		end if;
	end Process;

End Behavioral;

