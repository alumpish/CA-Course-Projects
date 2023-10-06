module mux2to1_5b (i0, i1, sel, y);
  input [4:0] i0, i1;
  input sel;
  output [4:0] y;
  
  assign y = (sel==1'b1) ? i1 : i0; 
endmodule

module mux2to1_32b (i0, i1, sel, y);
  input [31:0] i0, i1;
  input sel;
  output [31:0] y;
  
  assign y = (sel==1'b1) ? i1 : i0;  
endmodule

module mux4to1_32b (i0, i1, i2, i3, sel, y);
  input [31:0] i0, i1, i2, i3;
  input [1:0] sel;
  output [31:0] y;
  
  assign y = (sel==2'd0) ? i0 :
            (sel==2'd1) ? i1:
            (sel==2'd2) ? i2:
            i3;
endmodule
