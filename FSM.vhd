Library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

Entity FSM is
Port(
	CLK,Rstb : in std_logic;
	I : in std_logic;
	iDigitT1,iDigitT2,iDigitT3,iDigitT4 : in std_logic_vector(3 downto 0);
	iDigitD1,iDigitD2,iDigitD3,iDigitD4 : in std_logic_vector(3 downto 0);
	iDigitC1,iDigitC2,iDigitC3,iDigitC4 : in std_logic_vector(3 downto 0);
	iDigitD01,iDigitD10 : in std_logic_vector(3 downto 0);
	oDigit1,oDigit2,oDigit3,oDigit4 : out std_logic_vector(3 downto 0)
);
End FSM;

Architecture Behavioral of FSM is
	type state_type is (S1,S2,S3,S4);
	signal state : state_type;
Begin

	u_State : Process(CLK,Rstb)
	Begin
		if(Rstb='0') then
			state <= S1;
		elsif(rising_edge(CLK)) then
			case state is
				when S1 => 	if(I='1') then
									state <= S2;
								else
									state <= S1;
								end if;
								
				when S2 => 	if(I='1') then
									state <= S3;
								else
									state <= S2;
								end if;
								
				when S3 => 	if(I='1') then
									state <= S4;
								else
									state <= S3;
								end if;
								
				when S4 => 	if(I='1') then
									state <= S1;
								else
									state <= S4;
								end if;
								
				when others => state <= S1;
			end case;
		end if;
	end Process;
	
	u_oState : Process(CLK)
	Begin
		if(rising_edge(CLK)) then
			case state is
				when S1 => 	oDigit1 <= iDigitT1;
								oDigit2 <= iDigitT2;
								oDigit3 <= iDigitT3;
								oDigit4 <= iDigitT4;
								
				when S2 => 	oDigit1 <= iDigitD1;
								oDigit2 <= iDigitD2;
								oDigit3 <= iDigitD3;
								oDigit4 <= iDigitD4;
								
				when S3 => 	oDigit1 <= iDigitC1;
								oDigit2 <= iDigitC2;
								oDigit3 <= iDigitC3;
								oDigit4 <= iDigitC4;
								
				when S4 => 	oDigit1 <= "0000";
								oDigit2 <= "0000";
								oDigit3 <= iDigitD01;
								oDigit4 <= iDigitD10;
			end case;
		end if;
	end Process;

End Behavioral;

