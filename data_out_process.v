`timescale 1ns / 1ps

/*
**  UCSD CSE 141L Lab2/3 Implemented Module
** -------------------------------------------------------------------
**  Processing data memory output for LB, LH, LW instruction
**	 Date: 7/2/2016
**	 Author: Son Do
*/

module mem_data_out_processing(data_in, offset_in, opCode, data_out);
		input [31:0] data_in;
		input [1:0] offset_in;
		input [5:0] opCode;
		output reg [31:0] data_out;
		
		always @(*) begin
			case (opCode)
				6'h20: case(offset_in) //LB
							2'b00: data_out <= {{24{data_in[7]}},data_in[7:0]};
							2'b01: data_out <= {{24{data_in[15]}},data_in[15:8]};
							2'b10: data_out <= {{24{data_in[23]}},data_in[23:16]};
							2'b11: data_out <= {{24{data_in[31]}},data_in[31:24]};
						 endcase
				6'h21: case(offset_in) //LH
							2'b10:   data_out <= {{16{data_in[15]}},data_in[15:0]}; 
							default: data_out <= {{16{data_in[31]}},data_in[31:16]};
						 endcase
				6'h24: case(offset_in) //LBU
							2'b00: data_out <= {24'b0,data_in[7:0]};
							2'b01: data_out <= {24'b0,data_in[15:8]};
							2'b10: data_out <= {24'b0,data_in[23:16]};
							2'b11: data_out <= {24'b0,data_in[31:24]};
						 endcase
				6'h25: case(offset_in) //LHU
							2'b10:   data_out <= {16'b0,data_in[15:0]}; 
							default: data_out <= {16'b0,data_in[31:16]};
						 endcase
				default: data_out <= data_in; //LW
			endcase
		end
endmodule 