module multiplier_tb;
  reg [4:0] data_in;
  reg rst, start, clk;
  wire [4:0] data_out, tes;
  wire done;
  
  multiplier DUT(data_in, rst, start, clk, data_out, done, tes);
  
  initial
  begin
    start = 1'b0;
    rst = 1'b0;
    clk = 1'b0;
    #53 rst = 1'b1;
    #53 rst = 1'b0;
    #43 start = 1'b1;
    #80 start = 1'b0;
    data_in = 5'b01101;
    #80 data_in = 5'b01010;
    #2160 start = 1'b1;
    #80 start = 1'b0;
    data_in = 5'b11101;
    #80 data_in = 5'b01010;
    #2160 start = 1'b1;
    #80 start = 1'b0;
    data_in = 5'b01101;
    #80 data_in = 5'b11010;
    #2160 start = 1'b1;
    #80 start = 1'b0;
    data_in = 5'b00000;
    #80 data_in = 5'b01010;
    #2160 start = 1'b1;
    #80 start = 1'b0;
    data_in = 5'b11101;
    #80 data_in = 5'b11010;
    #3500 $stop;
  end
  
  always
  begin
    #40 clk = ~clk;
  end
  
  
endmodule
