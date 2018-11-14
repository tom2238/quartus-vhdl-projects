-- Copyright (C) 1991-2010 Altera Corporation
-- Your use of Altera Corporation's design tools, logic functions 
-- and other software and tools, and its AMPP partner logic 
-- functions, and any output files from any of the foregoing 
-- (including device programming or simulation files), and any 
-- associated documentation or information are expressly subject 
-- to the terms and conditions of the Altera Program License 
-- Subscription Agreement, Altera MegaCore Function License 
-- Agreement, or other applicable license agreement, including, 
-- without limitation, that your use is for the sole purpose of 
-- programming logic devices manufactured by Altera and sold by 
-- Altera or its authorized distributors.  Please refer to the 
-- applicable agreement for further details.

-- PROGRAM		"Quartus II"
-- VERSION		"Version 9.1 Build 350 03/24/2010 Service Pack 2 SJ Web Edition"
-- CREATED		"Thu Apr 23 21:33:24 2015"

LIBRARY ieee;
USE ieee.std_logic_1164.all; 

LIBRARY altera;
USE altera.maxplus2.all; 

LIBRARY work;

ENTITY 7490_0 IS 
PORT 
( 
	SET9A	:	IN	 STD_LOGIC;
	CLRA	:	IN	 STD_LOGIC;
	SET9B	:	IN	 STD_LOGIC;
	CLKB	:	IN	 STD_LOGIC;
	CLKA	:	IN	 STD_LOGIC;
	CLRB	:	IN	 STD_LOGIC;
	QD	:	OUT	 STD_LOGIC;
	QA	:	OUT	 STD_LOGIC;
	QB	:	OUT	 STD_LOGIC;
	QC	:	OUT	 STD_LOGIC
); 
END 7490_0;

ARCHITECTURE bdf_type OF 7490_0 IS 
BEGIN 

-- instantiate macrofunction 

b2v_inst : 7490
PORT MAP(SET9A => SET9A,
		 CLRA => CLRA,
		 SET9B => SET9B,
		 CLKB => CLKB,
		 CLKA => CLKA,
		 CLRB => CLRB,
		 QD => QD,
		 QA => QA,
		 QB => QB,
		 QC => QC);

END bdf_type; 