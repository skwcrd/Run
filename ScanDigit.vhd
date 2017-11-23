Library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

Entity ScanDigit is
Port(
	CLK : in std_logic;
	Rstb : in std_logic;
	i1ms,i0_5s : in std_logic;
	I : in std_logic;
	iDigit1 : in std_logic_vector(3 downto 0);
	iDigit2 : in std_logic_vector(3 downto 0);
	iDigit3 : in std_logic_vector(3 downto 0);
	iDigit4 : in std_logic_vector(3 downto 0);
	oDigit : out std_logic_vector(3 downto 0);
	oData : out std_logic_vector(3 downto 0);
	dp : out std_logic
);
End ScanDigit;

Architecture Behavioral of ScanDigit is
	type state_type is (S1,S2,S3);
	signal state : state_type;
	signal rCnt : std_logic_vector(3 downto 0);
	signal rShift : std_logic_vector(3 downto 0);
	signal wdp : std_logic := '0';
Begin

	oDigit <= rShift;
	
	oData <= iDigit1 when rShift="0111" else
				iDigit2 when rShift="1011" else
				iDigit3 when rShift="1101" else
				iDigit4;
	
	u_rCnt : Process(CLK,Rstb)
	Begin
		if(Rstb='0') then
			rCnt <= (others => '0');
			rShift <= "0111";
		elsif(rising_edge(CLK)) then
			if(rCnt=4 and i1ms='1') then
				rCnt <= (others => '0');
				rShift <= rShift(0) & rShift(3 downto 1);
			elsif(i1ms = '1') then
				rCnt <= rCnt + 1;
				rShift <= rShift;
			else
				rCnt <= rCnt;
				rShift <= rShift;
			end if;
		end if;
	end Process;
	
	u_State : Process(CLK,Rstb)
	Begin
		if(Rstb='0') then
			state <= S1;
			wdp <= '0';
		elsif(rising_edge(CLK)) then
			case state is
				when S1 => 	if(I='1') then
									state <= S2;
								else
									state <= S1;
								end if;
								
								if(rShift="1011" or rShift="1101") then
									dp <= wdp;
								else 
									dp <= '0';
								end if;
								
								if(i0_5s='1') then
									wdp <= not wdp;
								else
									wdp <= wdp;
								end if;
								
				when S2 => 	if(I='1') then
									state <= S3;
								else
									state <= S2;
								end if;
								
								if(rShift="1011") then
									dp <= wdp;
								else 
									dp <= '0';
								end if;
								
								if(i0_5s='1') then
									wdp <= not wdp;
								else
									wdp <= wdp;
								end if;
								
				when S3 => 	if(I='1') then
									state <= S1;
								else
									state <= S3;
								end if;
								
								if(rShift="1101") then
									dp <= wdp;
								else 
									dp <= '0';
								end if;
								
								if(i0_5s='1') then
									wdp <= not wdp;
								else
									wdp <= wdp;
								end if;
								
				when others => state <= S1;
			end case;
		end if;
	end Process;

End Behavioral;

