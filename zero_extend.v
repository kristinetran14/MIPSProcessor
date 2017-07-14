`timescale 1ns / 1ps

/*
**  UCSD CSE 141L Lab2/3 Implemented Module
** -------------------------------------------------------------------
**  Zero extender module for Single-Cycle MIPS Processor for Altera FPGAs
**  Date: 7/3/2016
**	 Author: Son Do
*/

module zero_extend(
	input  [15:0] data_in,
	output [31:0] data_out
);

assign data_out = {data_in,16'b0};

endmodule
