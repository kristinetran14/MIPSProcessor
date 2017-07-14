`timescale 1ns / 1ps

/*
**  UCSD CSE 141L Lab2/3 Implemented Module
** -------------------------------------------------------------------
**  Parameterizzed Mux Module for Single-Cycle MIPS Processor for Altera FPGAs
**  Implements a very simple Parameterizzed mux module for the processor project
**	 Date: 7/2/2016
**	 Author: Son Do
*/

module n_mux3(data_in0,data_in1, data_in2, sel, data_out);
parameter ADDR_WIDTH = 8;

	input [ADDR_WIDTH-1:0] data_in0;
	input [ADDR_WIDTH-1:0] data_in1;
	input [ADDR_WIDTH-1:0] data_in2;
	input [1:0] sel;
	output [ADDR_WIDTH-1:0] data_out;

	assign data_out = (sel == 2'b00) ? data_in0 : 
							(sel == 2'b01) ? data_in1 :
												  data_in2 ;
endmodule 