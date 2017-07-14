`timescale 1ns / 1ps

/*
**  UCSD CSE 141L Lab2/3 Implemented Module
** -------------------------------------------------------------------
**  Program Counter Module for Single-Cycle MIPS Processor for Altera FPGAs
**  Implements a very simple program counter module for the processor project
**	 Date: 7/2/2016
**	 Author: Son Do
*/

module PC(
	input [31:0] data_in,
	input clk,
	input reset,
	output reg [31:0] data_out
);

	always @(posedge clk) begin
		if (reset) begin
			data_out <= 32'h003FFFFC;
		end else begin
			data_out <= data_in;
		end
	end
endmodule 