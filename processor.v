`timescale 1ns / 1ps

/*
**  UCSD CSE 141L Lab2/3 Implemented Module
** -------------------------------------------------------------------
**  Single-Cycle MIPS Processor implementation for Altera FPGAs
**  Date: 7/2/2016
**	 Author: Son Do
*/

module processor(
	input clock,
	input reset,

	//these ports are used for serial IO and 
	//must be wired up to the data_memory module
	input [7:0] serial_in,
	input serial_valid_in,
	input serial_ready_in,
	output [7:0] serial_out,
	output serial_rden_out,
	output serial_wren_out
);
	//Program counter
	wire [31:0] pcOut;
	wire [31:0] pcIn;
	wire [31:0] pc_4;
	wire Cout;
	
	adder adder1(pcOut,4,1'b0,pc_4,Cout);
	PC programCounter(.clk(clock),.reset(reset),.data_in(pcIn),.data_out(pcOut));
	
	//Instruction Memory
	wire [31:0] instruction;
	inst_rom #(
	.ADDR_WIDTH(10),
	.INIT_PROGRAM("D:/cse141L/lab4-test/lab4-files-2/memh/fib/fib.inst_rom.memh") 
	)
		instruction_mem(	.clock(clock),
								.reset(reset), 
								.addr_in(pcIn), 
								.data_out(instruction) 
							);
	
	//Controller
	wire [5:0] func_in;
	wire [31:0] rt;
	wire [1:0] RegDst;
	wire [1:0] ALUsrc;
	wire RegWrite;
	wire MemRead;
	wire MemWrite;
	wire [1:0] MemtoReg;
	wire [1:0] Jump;
	wire [1:0] size_in;
	
	control controller(
		.opCode(instruction[31:26]),
		.funct(instruction[5:0]),
		.rt(rt),
		.func_in(func_in),
		.RegDst(RegDst),
		.ALUsrc(ALUsrc),
		.RegWrite(RegWrite),
		.MemRead(MemRead),
		.MemWrite(MemWrite),
		.MemtoReg(MemtoReg),
		.Jump(Jump),
		.Size_in(size_in)
	);
	
	//RegisterFile
	wire [4:0] writeReg; 
	wire [31:0] writeData;
	wire [31:0] readData1;
	wire [31:0] readData2;
	assign rt= readData2;
	n_mux3 #(.ADDR_WIDTH(5)) mux1(instruction[20:16],instruction[15:11], 5'b11111, RegDst,writeReg);
	
	registerFiles decode( .clk(clock), 
								.ReadReg1(instruction[25:21]), 
								.ReadReg2(instruction[20:16]),
								.write_en(RegWrite), 
								.WriteReg(writeReg),
								.WriteData(writeData),
								.ReadData1(readData1),
								.ReadData2(readData2)
								);
	//ALU
	wire [31:0] B_in;
	wire [31:0] mux_data_in1;
	wire [31:0] mux_data_in2;
	wire [31:0] Alu_out;
	wire Branch_out;
	wire Jump_out;
	wire jump_or_branch;
	
	//sign extension
	sign_extend signExtend(instruction[15:0], instruction[31:26], mux_data_in1);
	zero_extend zero_extend(instruction[15:0],mux_data_in2);
	n_mux3#(.ADDR_WIDTH(32)) mux2(readData2, mux_data_in1, mux_data_in2, ALUsrc, B_in);
	
	alu ALU(	.A_in(readData1), 
				.B_in(B_in), 
				.Func_in(func_in), // A + B Modified later
				.O_out(Alu_out),
				.Branch_out(Branch_out),
				.Jump_out(Jump_out)
				);
	or(jump_or_branch,Jump_out,Branch_out);
	
	//Branch datapath
	wire [31:0] shift_left_1_out;
	wire [25:0] shift_left_2_out;
	wire [31:0] mux4_out;
	wire [31:0] adder2_out;
	wire cout;
	shift_left_two#(.ADDR_WIDTH(32)) shift_left_1(mux_data_in1,shift_left_1_out);
	
	adder adder2(pc_4,shift_left_1_out,1'b0,adder2_out,cout);
	
	n_mux3#(.ADDR_WIDTH(32)) mux4(adder2_out,{pc_4[31:28],instruction[25:00],2'b00},readData1, Jump,mux4_out);
	n_mux2#(.ADDR_WIDTH(32)) mux5(pc_4, mux4_out, jump_or_branch, pcIn);
	
	//Data memory
	wire [31:0] readdata_out;
	data_memory #(
		.INIT_PROGRAM0("D:/cse141L/lab4-test/lab4-files-2/memh/fib/fib.data_ram0.memh"),
		.INIT_PROGRAM1("D:/cse141L/lab4-test/lab4-files-2/memh/fib/fib.data_ram1.memh"),
		.INIT_PROGRAM2("D:/cse141L/lab4-test/lab4-files-2/memh/fib/fib.data_ram2.memh"),
		.INIT_PROGRAM3("D:/cse141L/lab4-test/lab4-files-2/memh/fib/fib.data_ram3.memh")
	) data_mem (				.clock(clock), .reset(reset),
									.serial_in(serial_in),
									.serial_valid_in(serial_valid_in),
									.serial_ready_in(serial_ready_in),
									.serial_out(serial_out),
									.serial_rden_out(serial_rden_out),
									.serial_wren_out(serial_wren_out),
									.addr_in(Alu_out),
									.writedata_in(readData2),
									.re_in(MemRead),
									.we_in(MemWrite),
									.size_in(size_in),
									.readdata_out(readdata_out)
					);	
	//logic for LB, LH, LW, LBU, LHU
	wire [31:0] dataMemOut;
	mem_data_out_processing mem_out(readdata_out, Alu_out[1:0], instruction[31:26],dataMemOut);
								
	n_mux3#(.ADDR_WIDTH(32)) mux3(Alu_out, dataMemOut, pc_4, MemtoReg, writeData);
endmodule 