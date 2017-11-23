Library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;

Entity Calories is
Port(
	CLK,Rstb : in std_logic;
	i1s : in std_logic;
	iPush,stop : in std_logic;
	oDigit1,oDigit2,oDigit3,oDigit4 : out std_logic_vector(3 downto 0)
);
End Calories;

Architecture Behavioral of Calories is
	constant cal : integer  := 9352778; ----- cal = 65(kg) * 0.0013889(km) * 1.036 -----
	signal rCnt : integer := 0;
	signal wDigit1,wDigit2,wDigit3,wDigit4 : std_logic_vector(3 downto 0);
	signal wPush : std_logic := '0';
Begin

	oDigit1 <= wDigit1;
	oDigit2 <= wDigit2;
	oDigit3 <= wDigit3;
	oDigit4 <= wDigit4;
	
	u_Push : Process(CLK,Rstb)
	Begin
		if(Rstb='0') then
			wPush <= '0';
		elsif(rising_edge(CLK)) then
			if(stop='1') then
				wPush <= '0';
			elsif(iPush='1') then
				wPush <= not wPush;
			elsif(wDigit1=9 and wDigit2=9 and wDigit3=9 and wDigit4=9) then
				wPush <= '0';
			else
				wPush <= wPush;
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
			rCnt <= 0;
		elsif(rising_edge(CLK) and wPush='1') then
			
			---------- Digit1 ----------
			if(i1s='1' and wDigit1=9) then
				wDigit1 <= wDigit1;
			elsif(i1s='1' and wDigit2=9 and wDigit3=9 and wDigit4=9 and rCnt>=9000000) then
				wDigit1 <= wDigit1 + 1;
			else
				wDigit1 <= wDigit1;
			end if;
			
			---------- Digit2 ----------
			if(i1s='1' and wDigit1=9 and wDigit2=9) then
				wDigit2 <= wDigit2;
			elsif(i1s='1' and wDigit2=9 and wDigit3=9 and wDigit4=9 and rCnt>=9000000) then
				wDigit2 <= (others => '0');
			elsif(i1s='1' and wDigit3=9 and wDigit4=9 and rCnt>=9000000) then
				wDigit2 <= wDigit2 + 1;
			else
				wDigit2 <= wDigit2;
			end if;
			
			---------- Digit3 ----------
			if(i1s='1' and wDigit1=9 and wDigit2=9 and wDigit3=9) then
				wDigit3 <= wDigit3;
			elsif(i1s='1' and wDigit3=9 and wDigit4=9 and rCnt>=9000000) then
				wDigit3 <= (others => '0');
			elsif(i1s='1' and wDigit4=9 and rCnt>=9000000) then
				wDigit3 <= wDigit3 + 1;
			else
				wDigit3 <= wDigit3;
			end if;
			
			---------- Digit4 ----------
			if(i1s='1' and wDigit1=9 and wDigit2=9 and wDigit3=9 and wDigit4=9) then
				wDigit4 <= wDigit4;
			elsif(i1s='1' and wDigit4=9 and rCnt>=9000000) then
				wDigit4 <= (others => '0');
			elsif(i1s='1' and rCnt>=9000000) then
				wDigit4 <= wDigit4 + 1;
			else
				wDigit4 <= wDigit4;
			end if;
			
			---------- Count ----------
			if(i1s='1' and rCnt>=9000000) then
				rCnt <= rCnt + cal - 10000000;
			elsif(i1s='1') then
				rCnt <= rCnt + cal;
			else
				rCnt <= rCnt;
			end if;
		else
			wDigit1 <= wDigit1;
			wDigit2 <= wDigit2;
			wDigit3 <= wDigit3;
			wDigit4 <= wDigit4;
			rCnt <= rCnt;
		end if;
	end Process;

End Behavioral;

