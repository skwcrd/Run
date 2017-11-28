Library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

Entity RunTop is
Port(
	CLK,Rstb : in std_logic;
	iPush,Change : in std_logic;
	oLED : out std_logic_vector(7 downto 0);
	oBCD : out std_logic_vector(6 downto 0);
	com : out std_logic_vector(3 downto 0);
	dp : out std_logic
);
End RunTop;

Architecture Stuctural of RunTop is
	
	Component CLK1ms is
	Port(
		CLK : in std_logic;
		Rstb : in std_logic;
		o1ms : out std_logic
	);
	End Component CLK1ms;
	
	Component CLK1s is
	Port(
		CLK : in std_logic;
		Rstb : in std_logic;
		i1ms : in std_logic;
		o1s : out std_logic
	);
	End Component CLK1s;
	
	Component CLK0_5s is
	Port(
		CLK : in std_logic;
		Rstb : in std_logic;
		i1ms : in std_logic;
		o0_5s : out std_logic
	);
	End Component CLK0_5s;
	
	Component Debouce is
	Port(
		CLK : in std_logic;
		Rstb : in std_logic;
		i1ms : in std_logic;
		I : in std_logic;
		O : out std_logic
	);
	End Component Debouce;
	
	Component ScanDigit is
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
	End Component ScanDigit;
	
	Component BCD is
	Port(
		I : in std_logic_vector(3 downto 0);
		O : out std_logic_vector(6 downto 0)
	);
	End Component BCD;
	
	Component FSM is
	Port(
		CLK,Rstb : in std_logic;
		I : in std_logic;
		iDigitT1,iDigitT2,iDigitT3,iDigitT4 : in std_logic_vector(3 downto 0);
		iDigitD1,iDigitD2,iDigitD3,iDigitD4 : in std_logic_vector(3 downto 0);
		iDigitC1,iDigitC2,iDigitC3,iDigitC4 : in std_logic_vector(3 downto 0);
		iDigitD01,iDigitD10 : in std_logic_vector(3 downto 0);
		oDigit1,oDigit2,oDigit3,oDigit4 : out std_logic_vector(3 downto 0)
	);
	End Component FSM;
	
	Component Time_RUN is
	Port(
		CLK,Rstb : in std_logic;
		i1s : in std_logic;
		iPush : in std_logic;
		oDigit1,oDigit2,oDigit3,oDigit4 : out std_logic_vector(3 downto 0);
		stop : out std_logic
	);
	End Component Time_RUN;
	
	Component Calories is
	Port(
		CLK,Rstb : in std_logic;
		i1s : in std_logic;
		iPush,stop : in std_logic;
		oDigit1,oDigit2,oDigit3,oDigit4 : out std_logic_vector(3 downto 0)
	);
	End Component Calories;
	
	Component BCD_Distance is
	Port(
		CLK,Rstb : in std_logic;
		i1s : in std_logic;
		iPush,stop : in std_logic;
		oDigit1,oDigit2,oDigit3,oDigit4 : out std_logic_vector(3 downto 0)
	);
	End Component BCD_Distance;
	
	Component Distance is
	Port(
		CLK,Rstb : in std_logic;
		i1s : in std_logic;
		iPush,stop : in std_logic;
		iDigitD01,iDigitD10 : out std_logic_vector(3 downto 0);
		oLED : out std_logic_vector(7 downto 0)
	);
	End Component Distance;
	
	signal w1ms,w1s,w0_5s : std_logic;
	signal wData : std_logic_vector(3 downto 0);
	signal wDigitT1,wDigitT2,wDigitT3,wDigitT4 : std_logic_vector(3 downto 0);
	signal wDigitD1,wDigitD2,wDigitD3,wDigitD4 : std_logic_vector(3 downto 0);
	signal wDigitC1,wDigitC2,wDigitC3,wDigitC4 : std_logic_vector(3 downto 0);
	signal wDigitD01,wDigitD10 : std_logic_vector(3 downto 0);
	signal wDigit1,wDigit2,wDigit3,wDigit4 : std_logic_vector(3 downto 0);
	signal wPush,wChange,wStop : std_logic;
Begin

	u_CLK1ms : CLK1ms
	Port Map(
		CLK=> CLK,
		Rstb=> Rstb,
		o1ms=> w1ms
	);
	
	u_CLK1s : CLK1s
	Port Map(
		CLK=> CLK,
		Rstb=> Rstb,
		i1ms=> w1ms,
		o1s=> w1s
	);
	
	u_CLK0_5s : CLK0_5s
	Port Map(
		CLK=> CLK,
		Rstb=> Rstb,
		i1ms=> w1ms,
		o0_5s=> w0_5s
	);
	
	u_Push : Debouce
	Port Map(
		CLK=> CLK,
		Rstb=> Rstb,
		i1ms=> w1ms,
		I=> iPush,
		O=> wPush
	);
	
	u_Time : Time_RUN
	Port Map(
		CLK=> CLK,
		Rstb=> Rstb,
		i1s=> w1s,
		iPush=> wPush,
		oDigit1=> wDigitT1,
		oDigit2=> wDigitT2,
		oDigit3=> wDigitT3,
		oDigit4=> wDigitT4,
		stop=> wStop
	);
	
	u_BCDdistance : BCD_Distance
	Port Map(
		CLK=> CLK,
		Rstb=> Rstb,
		i1s=> w1s,
		iPush=> wPush,
		stop=> wStop,
		oDigit1=> wDigitD1,
		oDigit2=> wDigitD2,
		oDigit3=> wDigitD3,
		oDigit4=> wDigitD4
	);
	
	u_Calories : Calories
	Port Map(
		CLK=> CLK,
		Rstb=> Rstb,
		i1s=> w1s,
		iPush=> wPush,
		stop=> wStop,
		oDigit1=> wDigitC1,
		oDigit2=> wDigitC2,
		oDigit3=> wDigitC3,
		oDigit4=> wDigitC4
	);
	
	u_Change : Debouce
	Port Map(
		CLK=> CLK,
		Rstb=> Rstb,
		i1ms=> w1ms,
		I=> Change,
		O=> wChange
	);
	
	u_FSM : FSM
	Port Map(
		CLK=> CLK,
		Rstb=> Rstb,
		I=> wChange,
		iDigitT1=> wDigitT1,
		iDigitT2=> wDigitT2,
		iDigitT3=> wDigitT3,
		iDigitT4=> wDigitT4,
		iDigitD1=> wDigitD1,
		iDigitD2=> wDigitD2,
		iDigitD3=> wDigitD3,
		iDigitD4=> wDigitD4,
		iDigitC1=> wDigitC1,
		iDigitC2=> wDigitC2,
		iDigitC3=> wDigitC3,
		iDigitC4=> wDigitC4,
		iDigitD01=> wDigitD01,
		iDigitD10=> wDigitD10,
		oDigit1=> wDigit1,
		oDigit2=> wDigit2,
		oDigit3=> wDigit3,
		oDigit4=> wDigit4
	);
	
	u_ScanDigit : ScanDigit
	Port Map(
		CLK=> CLK,
		Rstb=> Rstb,
		i1ms=> w1ms,
		i0_5s=> w0_5s,
		I=> wChange,
		iDigit1=> wDigit1,
		iDigit2=> wDigit2,
		iDigit3=> wDigit3,
		iDigit4=> wDigit4,
		oDigit=> com,
		oData=> wData,
		dp=> dp
	);
	
	u_BCD : BCD
	Port Map(
		I=> wData,
		O=> oBCD
	);
	
	u_Distance : Distance
	Port Map(
		CLK=> CLK,
		Rstb=> Rstb,
		i1s=> w1s,
		iPush=> wPush,
		stop=> wStop,
		iDigitD01=> wDigitD01,
		iDigitD10=> wDigitD10,
		oLED=> oLED
	);
	
End Stuctural;

