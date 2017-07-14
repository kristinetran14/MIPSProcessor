`timescale 1ns / 1ps

/*
**  UCSD CSE 141L Lab2/3 Implemented Module
** -------------------------------------------------------------------
**  RegisterFile Module for Single-Cycle MIPS Processor for Altera FPGAs
**  Implements a RegisterFile module for the processor project
**	 Date: 7/2/2016
**	 Author: Son Do
*/

module registerFiles(
	input clk,
	input write_en,
	input [4:0] ReadReg1,
	input [4:0] ReadReg2,
	input [4:0] WriteReg,
	input [31:0] WriteData,
	output [31:0] ReadData1,
	output [31:0] ReadData2
);

	//Collection of 32 registers, with registers[0] as zero register $zero
	reg [31:0] registers [0:31];
	//Assign the appropriate ReadData (Read 2 register asynchronously and simultaneously)
	assign ReadData1 = (ReadReg1 == 5'b0) ? 32'b0 : registers[ReadReg1];
	assign ReadData2 = (ReadReg2 == 5'b0) ? 32'b0 : registers[ReadReg2];

	//Write Data to the Write register when write is enabled
	always @(posedge clk) begin
		if (write_en && WriteReg!= 5'b0) begin
			registers[WriteReg] <= WriteData;
		end
	end
endmodule		