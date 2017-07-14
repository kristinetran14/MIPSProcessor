`timescale 1ns / 1ps

/*
**  UCSD CSE 141L Lab2/3 Implemented Module
** -------------------------------------------------------------------
**  Adder Module for Single-Cycle MIPS Processor for Altera FPGAs
**  Implements a very simple 32bit adder as part of the program counter
**  for the processor project
**	 Date: 7/2/2016
**	 Author: Son Do
*/

module adder(
	input  [31:0] data_in1,
	input  [31:0] data_in2,
	input Cin,
	output [31:0] data_out,
	output Cout
);

	assign {Cout,data_out} = data_in1 + data_in2 + Cin;	
endmodule	