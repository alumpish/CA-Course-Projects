module multiplier (data_in, rst, start, clk, data_out, done, tes);
  input [4:0] data_in;
  input rst, start, clk;
  output [4:0] data_out, tes;
  output done;
  
  wire ldY, clrE, ldE, clrA, ldA, shA, ldX, shX, sel, selout, cin, x1, x0;
  datapath   dp(data_in, ldY, clrE, ldE, clrA, ldA, shA, ldX, shX, sel, selout, cin, clk, x1, x0, data_out);
  controller cu(start, x1, x0, rst, clk, ldY, ldE, clrE, clrA, ldA, shA, ldX, shX, sel, selout, cin, done, tes);
endmodule
