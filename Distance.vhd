Library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;

Entity Distance is
Port(
	CLK,Rstb : in std_logic;
	i1s : in std_logic;
	iPush,stop : in std_logic;
	oLED : out std_logic_vector(7 downto 0)
);
End Distance;

Architecture Behavioral of Distance is
	constant speed : integer := 13889; ----- Speed 1.3889 m/s -----
	signal rCnt : integer := 0;
	signal wDist : std_logic_vector(7 downto 0);
	signal wPush : std_logic := '0';
Begin

	oLED <= wDist;
	
	u_Push : Process(CLK,Rstb)
	Begin
		if(Rstb='0') then
			wPush <= '0';
		elsif(rising_edge(CLK)) then
			if(stop='1') then
				wPush <= '0';
			elsif(iPush='1') then
				wPush <= not wPush;
			else
				wPush <= wPush;
			end if;
		end if;
	end Process;
	
	u_Dist : Process(CLK,Rstb,wPush)
	Begin
		if(Rstb='0') then
			wDist <= (others => '0');
			rCnt <= 0;
		elsif(rising_edge(CLK) and wPush='1') then
			
			---------- Count Distances ----------
			if(i1s='1' and rCnt>=500000) then
				rCnt <= rCnt + speed - 500000;
			elsif(i1s='1') then
				rCnt <= rCnt + speed;
			else
				rCnt <= rCnt;
			end if;
			
			---------- Assign LED 50 m/LED ----------
			if(i1s='1' and rCnt>=500000 and wDist="11111111") then
				wDist <= (0 => '1',others => '0');
			elsif(i1s='1' and rCnt>=500000) then
				wDist <= wDist(6 downto 0) & '1';
			else
				wDist <= wDist;
			end if;
		else
			wDist <= wDist;
			rCnt <= rCnt;
		end if;
	end Process;

End Behavioral;

