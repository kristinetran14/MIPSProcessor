`timescale 1ns / 1ps

/*
**  UCSD CSE 141L Lab2/3 Implemented Module
** -------------------------------------------------------------------
**  Control unit module for Single-Cycle MIPS Processor for Altera FPGAs
**  Date: 7/3/2016
**	 Author: Son Do
*/

module control(
	input  [5:0]  opCode,
	input  [5:0]  funct,
	input  [31:0] rt,
	output [5:0] func_in,
	output [1:0] RegDst,
	output [1:0] ALUsrc,
	output RegWrite,
	output MemRead,
	output MemWrite,
	output [1:0] MemtoReg,
	output [1:0] Jump,
	output [1:0] Size_in
);

	reg [18:0] out;
	assign func_in =  out[18:13];
	assign RegDst =   out[12:11];
	assign ALUsrc =   out[10:9];
	assign RegWrite = out[8];
	assign MemRead =  out[7];
	assign MemWrite = out[6];
	assign MemtoReg = out[5:4];
	assign Jump =     out[3:2];
	assign Size_in=   out[1:0];
	
	always @(opCode or funct) begin
		case (opCode)
			default: out <= 19'b0; //Unused
			6'h01: case(rt)
			32'b0: out <= {6'b111000,13'b0000000000000};  //bltz
			32'b1: out <= {6'b111001,13'b0000000000000};  //bgez
			endcase
			6'h02: out <= {6'b111010,13'b0000000000100};  //J
			6'h03: out <= {6'b111010,13'b1000100100100};  //JAL
			6'h04: out <= {6'b111100,13'b0000000000000};  //BEQ
			6'h05: out <= {6'b111101,13'b0000000000000};  //BNE
			6'h06: out <= {6'b111110,13'b0000000000000};  //BLEZ
			6'h07: out <= {6'b111111,13'b0000000000000};  //BGTZ
			6'h08: out <= {6'b100000,13'b0001100000011};  //ADDI
			6'h09: out <= {6'b100001,13'b0001100000000};  //ADDIU
			6'h0C: out <= {6'b100100,13'b0001100000000};  //ANDI
			6'h0D: out <= {6'b100101,13'b0001100000000};  //ORI
			6'h0E: out <= {6'b100110,13'b0001100000000};  //XORI
			6'h0F: out <= {6'b100000,13'b0010100000011};  //LUI
			6'h20: out <= {6'b100000,13'b0001110010000};  //LB
			6'h21: out <= {6'b100000,13'b0001110010001};  //LH
			6'h23: out <= {6'b100000,13'b0001110010011};  //LW
			6'h24: out <= {6'b100000,13'b0001110010000};  //LBU
			6'h25: out <= {6'b100000,13'b0001110010001};  //LHU
			6'h28: out <= {6'b100000,13'b0001001000000};  //SB
			6'h29: out <= {6'b100000,13'b0001001000001};  //SH
			6'h2b: out <= {6'b100000,13'b0001001000011};  //SW
			6'h0 : case (funct)
			6'h08: out <= {6'b111010,13'b0000000001000};  //JR
			6'h09: out <= {6'b111010,13'b0100100101000};  //JALR
			6'h20: out <= 		{funct,13'b0100100000011};  //ADD
			6'h21: out <= 		{funct,13'b0100100000000};  //ADDU
			6'h22: out <= 		{funct,13'b0100100000011};	 //SUB
			6'h23: out <= 		{funct,13'b0100100000000};  //SUBU
			6'h24: out <= 		{funct,13'b0100100000011};	 //AND
			6'h25: out <= 		{funct,13'b0100100000011};	 //OR
			6'h26: out <= 		{funct,13'b0100100000011};	 //XOR
			6'h27: out <= 		{funct,13'b0100100000011};	 //NOR
			6'h2A: out <= 		{funct,13'b0100100000000};  //SLT
			6'h2B: out <= 		{funct,13'b0100100000000};  //SLTU
			6'h00: out <= 		{funct,13'b0000000000000};  //SLL NOP
			default: out <= 19'b0; //Unused
			endcase
		endcase
	end
	
endmodule