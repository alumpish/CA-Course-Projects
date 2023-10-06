module datapath (data_in, ldY, clrE, ldE, clrA, ldA, shA, ldX, shX, sel, selout, cin, clk, x1, e_out, data_out);
  input [4:0] data_in;
  input ldY, clrE, ldE, clrA, ldA, shA, ldX, shX, sel, selout, cin, clk;
  output x1, e_out;
  output [4:0] data_out;
  
  wire [4:0] a_out, y_final, y_out, y_not, x_out, sum;
  wire cout;
  
  adder add_5b (a_out, y_final, cin, cout, sum);
  
  reg_4b Y(data_in, ldY, clk, y_out);
  
  shreg_4b A(sum, a_out[4], clrA, ldA, shA, clk, a_out);
  
  shreg_4b X(data_in, a_out[0], 1'b0, ldX, shX, clk, x_out);

  dff E(x_out[0], clrE, ldE, clk, e_out);
  
  mux_2_to_1 mux(y_out, y_not, sel , y_final);

  mux_2_to_1 mux2(x_out, a_out, selout , data_out);

  not_5b nt(y_out, y_not);

  assign x1 = x_out[0];
  
endmodule  
