module mips_multi_cycle (rst, clk, data_in, adr, data_out, inst, MemRead, MemWrite);

  input rst, clk;
  input  [31:0] data_in;
  output [31:0] adr, data_out, inst;
  output MemRead, MemWrite;
  
  wire IRWrite, RegDst, MemToReg, ALUSrcA, RegWrite, S1, S2, IorD, PCWrite, PCWriteCond;
  wire [1:0] ALUSrcB, PCSrc;
  wire [2:0] ALUCtrl;
  
  
  datapath DP(  clk, rst, data_in, adr, data_out, inst,
                IRWrite, RegDst, MemToReg, S1, S2, PCWrite, PCWriteCond,
                RegWrite, IorD, PCSrc, ALUSrcA, ALUSrcB, ALUCtrl
            );

  controller CU(  clk, rst, inst[31:26], inst[5:0], PCWrite, PCWriteCond, IorD,
                  IRWrite, RegDst, MemToReg, S1, S2, RegWrite, ALUSrcA, ALUSrcB,
                  ALUCtrl, PCSrc, MemWrite, MemRead
              ); 
endmodule
