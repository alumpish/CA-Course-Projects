module adder (a, b, ci, co, s);
  input [4:0] a, b;
  input ci;
  output co;
  output [4:0] s;
  
  assign {co, s} = a + b + ci;
  
endmodule
