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

LIBRARY work;

ENTITY test IS 
	PORT
	(
		pin_name11 :  IN  STD_LOGIC;
		pin_name12 :  IN  STD_LOGIC;
		pin_name13 :  IN  STD_LOGIC;
		pin_name14 :  IN  STD_LOGIC;
		pin_name15 :  IN  STD_LOGIC;
		pin_name16 :  IN  STD_LOGIC;
		pin_name :  OUT  STD_LOGIC;
		pin_name8 :  OUT  STD_LOGIC;
		pin_name9 :  OUT  STD_LOGIC;
		pin_name10 :  OUT  STD_LOGIC
	);
END test;

ARCHITECTURE bdf_type OF test IS 

ATTRIBUTE black_box : BOOLEAN;
ATTRIBUTE noopt : BOOLEAN;

COMPONENT \7490_0\
	PORT(SET9A : IN STD_LOGIC;
		 CLRA : IN STD_LOGIC;
		 SET9B : IN STD_LOGIC;
		 CLKB : IN STD_LOGIC;
		 CLKA : IN STD_LOGIC;
		 CLRB : IN STD_LOGIC;
		 QD : OUT STD_LOGIC;
		 QA : OUT STD_LOGIC;
		 QB : OUT STD_LOGIC;
		 QC : OUT STD_LOGIC);
END COMPONENT;
ATTRIBUTE black_box OF \7490_0\: COMPONENT IS true;
ATTRIBUTE noopt OF \7490_0\: COMPONENT IS true;



BEGIN 



b2v_inst : 7490_0
PORT MAP(SET9A => pin_name11,
		 CLRA => pin_name13,
		 SET9B => pin_name12,
		 CLKB => pin_name16,
		 CLKA => pin_name15,
		 CLRB => pin_name14,
		 QD => pin_name,
		 QA => pin_name10,
		 QB => pin_name9,
		 QC => pin_name8);


END bdf_type;