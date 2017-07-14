`timescale 1ns / 1ps

/*
**  UCSD CSE 141L Lab2/3 Implemented Module
** -------------------------------------------------------------------
**  Shiftleft2 for Single-Cycle MIPS Processor for Altera FPGAs
**  Implements a very simple parameterized shift left 2 module for the processor project
**	 Date: 7/2/2016
**	 Author: Son Do
*/

module shift_left_two(data_in, data_out);
parameter ADDR_WIDTH = 26;

	input  [ADDR_WIDTH-1:0]   data_in;
	output [ADDR_WIDTH-1:0]  data_out;
	
	assign data_out = {data_in[ADDR_WIDTH-3:0],2'b00};
endmodule 