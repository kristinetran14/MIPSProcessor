`timescale 1ns / 1ps

/*
**  UCSD CSE 141L Lab2/3 Implemented Module
** -------------------------------------------------------------------
**  Sign Extend Module for Single-Cycle MIPS Processor for Altera FPGAs
**  Implements an 16-to-32 sign extend module for the processor project
**	 Date: 7/2/2016
**	 Author: Son Do
*/

module sign_extend(
	input [15:0] data_in,
	input [5:0] opCode,
	output [31:0] data_out
);

assign data_out = (opCode==6'h0D) ? {16'b0,data_in} : 
						(opCode==6'h0E) ? {16'b0,data_in} :
												{{16{data_in[15]}},data_in};

endmodule 