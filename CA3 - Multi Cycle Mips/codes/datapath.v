module datapath (clk, rst, data_in, adr, data_out, inst,
                IRWrite, RegDst, MemToReg, S1, S2, PCWrite, PCWriteCond,
                RegWrite, IorD, PCSrc, ALUSrcA, ALUSrcB, ALUCtrl);

  input  clk, rst;
  input RegDst, S1, S2, MemToReg, IorD, ALUSrcA, IRWrite, RegWrite, PCWrite, PCWriteCond;
  input [1:0] ALUSrcB, PCSrc;
  input [2:0] ALUCtrl;
  input [31:0] data_in;

  output [31:0] adr, data_out, inst;

  wire Zero;
  wire [4:0]  mux2_out, mux3_out;
  wire [27:0] shl1_out;
  wire [31:0] mux1_out, mux6_out, mux7_out, mux8_out, mux4_out, mux5_out;
  wire [31:0] inst, mdr_out;
  wire [31:0] alu_out, alu_reg_out, a_reg_out, b_reg_out, shl2_out, sgn_ext_out, pc_out, read_data1, read_data2;


  sign_ext SGN_EXT(inst[15:0], sgn_ext_out);

  shl2_26 SHL1(inst[25:0], shl1_out);
  shl2_32 SHL2(sgn_ext_out, shl2_out);

  mux2to1_5b mux2(inst[20:16], inst[15:11], RegDst, mux2_out);
  mux2to1_5b mux3(mux2_out, 5'd31, S1, mux3_out);

  mux2to1_32b mux4(alu_reg_out, mdr_out, MemToReg, mux4_out);
  mux2to1_32b mux5(mux4_out, pc_out, S2, mux5_out);
  mux2to1_32b mux1(pc_out, alu_reg_out, IorD, mux1_out);
  mux2to1_32b mux6(pc_out, a_reg_out, ALUSrcA, mux6_out);

  mux4to1_32b mux7(b_reg_out, 32'd4, sgn_ext_out, shl2_out, ALUSrcB, mux7_out);
  mux4to1_32b mux8(alu_out, {pc_out[31:28], shl1_out}, alu_reg_out, a_reg_out, PCSrc, mux8_out);

  assign PCContrl = (Zero & PCWriteCond) | PCWrite;

  reg_32b PC(mux8_out, rst, PCContrl, clk, pc_out);

  reg_32b IR(data_in, rst, IRWrite, clk, inst);
  reg_32b MDR(data_in, rst, 1'b1, clk, mdr_out);

  reg_file RF(mux5_out, inst[25:21], inst[20:16], mux3_out, RegWrite, rst, clk, read_data1, read_data2);

  reg_32b A(read_data1, rst, 1'b1, clk, a_reg_out);
  reg_32b B(read_data2, rst, 1'b1, clk, b_reg_out);

  alu ALU(mux6_out, mux7_out, ALUCtrl, alu_out, Zero);

  reg_32b alu_reg(alu_out, rst, 1'b1, clk, alu_reg_out);

  assign adr = mux1_out;
  assign data_out = b_reg_out;

  endmodule
