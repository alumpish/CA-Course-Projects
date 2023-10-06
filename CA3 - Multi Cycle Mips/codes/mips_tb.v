module mips_tb;
  
  wire [31:0] adr, data_in, data_out, inst;
  wire MemRead, MemWrite;
  reg clk, rst;
  
  mips_multi_cycle MC(rst, clk, data_out, adr, data_in, inst, MemRead, MemWrite);
  
  data_mem DM (adr, data_in, MemRead, MemWrite, clk, data_out);
  
  initial
  begin
    rst = 1'b1;
    clk = 1'b0;
    #20 rst = 1'b0;
    #5000 $stop;
  end
  
  always
  begin
    #2 clk = ~clk;
  end 
endmodule
