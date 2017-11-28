Library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

Entity CLK0_5s is
Port(
	CLK : in std_logic;
	Rstb : in std_logic;
	i1ms : in std_logic;
	o0_5s : out std_logic
);
End CLK0_5s;

Architecture Behavioral of CLK0_5s is
	signal rCnt : std_logic_vector(8 downto 0);
	signal r0_5s : std_logic := '0';
Begin

	o0_5s <= r0_5s;
	
	u_rCnt : Process(CLK,Rstb)
	begin
		if(Rstb = '0') then
			rCnt <= (others => '0');
			r0_5s <= '0';
		elsif(rising_edge(CLK)) then
			if(rCnt = 499 and i1ms = '1') then
				rCnt <= (others => '0');
				r0_5s <= '1';
			elsif(i1ms = '1') then
				rCnt <= rCnt + 1;
				r0_5s <= '0';
			else
				rCnt <= rCnt;
				r0_5s <= '0';
			end if;
		end if;
	end Process;

End Behavioral;

