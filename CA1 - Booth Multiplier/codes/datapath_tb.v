module datapth_tb;
  
  reg [3:0] data_in; 
  reg ldY, clrE, ldE, clrA, ldA, shA, ldX, shX, sel, clk;
  wire x0; 
  wire [3:0] data_out;
  
  datapath DUT(data_in, ldY, clrE, ldE, clrA, ldA, shA, ldX, shX, sel, clk, x0, data_out);
  
  initial
  begin
    clk = 1'b0;
    sel = 1'b0;
    #20 clrA = 1'b1; clrE = 1'b1;
    #20 clrA = 1'b0; clrE = 1'b0;
    #20 ldY = 1'b1; data_in = 4'b1010;
    #20 ldY = 1'b0; 
    #20 ldX = 1'b1; data_in = 4'b1101;
    #20 ldX = 1'b0; sel = 1'b1;
  end
  
  always 
    #10 clk = ~clk;
  
endmodule