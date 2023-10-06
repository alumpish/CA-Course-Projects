module datapath ( clk, rst, inst_adr, inst,
                  data_adr, data_out, data_in, 
                  reg_dst, mem_to_reg, alu_src, pc_src, alu_ctrl, reg_write, jump, jumpReg, Link,
                  zero
                 );
  input  clk, rst;
  output [31:0] inst_adr;
  input  [31:0] inst;
  output [31:0] data_adr;
  output [31:0] data_out;
  input  [31:0] data_in;
  input  reg_dst, mem_to_reg, alu_src, pc_src, reg_write, jump, jumpReg, Link;
  input  [2:0] alu_ctrl;
  output zero;

  wire [31:0] pc_out;
  wire [31:0] adder1_out;
  wire [31:0] read_data1, read_data2;
  wire [31:0] sgn_ext_out;
  wire [31:0] alu_out;
  wire [31:0] adder2_out;
  wire [31:0] shl1_out;
  wire [31:0] mux3_out, mux4_out, mux5_out, mux6_out, mux7_out, mux8_out;


  wire [27:0] shl2_out;

  wire [4:0]  mux1_out, mux2_out;

  reg_32b PC(mux5_out, rst, 1'b1, clk, pc_out);

  adder_32b ADDER_1 (pc_out , 32'd4, 1'b0, , adder1_out);

  mux2to1_5b MUX_1(inst[20:16], inst[15:11], reg_dst, mux1_out);
  mux2to1_5b MUX_2(mux1_out, 5'd31, Link, mux2_out);


  reg_file  RF(mux7_out, inst[25:21], inst[20:16], mux2_out, reg_write, rst, clk, read_data1, read_data2);

  sign_ext SGN_EXT(inst[15:0], sgn_ext_out);

  mux2to1_32b MUX_8(read_data2, sgn_ext_out, alu_src, mux8_out);

  alu ALU(read_data1, mux8_out, alu_ctrl, alu_out, zero);

  shl2_32 SHL1(sgn_ext_out, shl1_out);
  shl2_26 SHL2(inst[25:0], shl2_out);


  adder_32b ADDER_2(adder1_out, shl1_out, 1'b0, , adder2_out);

  mux2to1_32b MUX_3(adder1_out, adder2_out, pc_src, mux3_out);
  mux2to1_32b MUX_4({adder1_out[31:28], shl2_out}, read_data1, jumpReg, mux4_out);
  mux2to1_32b MUX_5(mux3_out, mux4_out, jump, mux5_out);

  mux2to1_32b MUX_6(alu_out, data_in, mem_to_reg, mux6_out);
  mux2to1_32b MUX_7(mux6_out, adder1_out, Link, mux7_out);

  assign inst_adr = pc_out;
  assign data_adr = alu_out;
  assign data_out = read_data2;
  
endmodule
