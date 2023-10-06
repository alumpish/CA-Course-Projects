`define   S0      5'b00000
`define   S1      5'b00001
`define   S2      5'b00010
`define   S3      5'b00011
`define   S4      5'b00100
`define   S5      5'b00101
`define   S6      5'b00110
`define   S7      5'b00111
`define   S8      5'b01000
`define   S9      5'b01001
`define   S10     5'b01010
`define   S11     5'b01011
`define   S12     5'b01100
`define   S13     5'b01101
`define   S14     5'b01110
`define   S15     5'b01111
`define   S16     5'b10000
`define   S17     5'b10001
`define   S18     5'b10010
`define   S19     5'b10011
`define   S20     5'b10100
`define   S21     5'b10101
`define   S22     5'b10110
`define   S23     5'b10111

module controller (start, x1, x0, rst, clk, ldY, ldE, clrE, clrA, ldA, shA, ldX, shX, sel, selout, cin, done, tes);
  input start, x1, x0, rst, clk;
  output ldY, ldE, clrE, clrA, ldA, shA, ldX, shX, sel, selout, cin, done;
  output [4:0] tes;
  reg ldY, ldE, clrE, clrA, ldA, shA, ldX, shX, sel, selout, cin, done;
  
  reg [4:0] ps = 5'b0, ns = 5'b0;

  assign tes = ps;
  
  // Sequential part 
  always @(posedge clk)
    if (rst)
      ps <= 5'b00000;
    else
      ps <= ns;
      
  always @(ps or start or x1 or x0)
  begin
    case (ps)
      `S0:  ns = start ? `S1 : `S0;
      `S1:  ns = `S2;
      `S2:  ns = ({x1, x0} == 2'b00) ? `S5 :
		 ({x1, x0} == 2'b11) ? `S5 :
		 ({x1, x0} == 2'b10) ? `S3 : `S4;
      `S3:  ns = `S5;
      `S4:  ns = `S5;
      `S5:  ns = `S6;
      `S6:  ns = ({x1, x0} == 2'b00) ? `S9 :
		 ({x1, x0} == 2'b11) ? `S9 :
		 ({x1, x0} == 2'b10) ? `S7 : `S8;
      `S7:  ns = `S9;
      `S8:  ns = `S9;
      `S9:  ns =`S10;
      `S10: ns = ({x1, x0} == 2'b00) ? `S13 :
		 ({x1, x0} == 2'b11) ? `S13 :
		 ({x1, x0} == 2'b10) ? `S11 : `S12;
      `S11: ns = `S13;
      `S12: ns = `S13;
      `S13: ns = `S14;
      `S14: ns = ({x1, x0} == 2'b00) ? `S17 :
		 ({x1, x0} == 2'b11) ? `S17 :
		 ({x1, x0} == 2'b10) ? `S15 : `S16;
      `S15: ns = `S17;
      `S16: ns = `S17;
      `S17: ns =`S18;
      `S18: ns = ({x1, x0} == 2'b00) ? `S21 :
		 ({x1, x0} == 2'b11) ? `S21 :
		 ({x1, x0} == 2'b10) ? `S19 : `S20;
      `S19: ns = `S21;
      `S20: ns = `S21;
      `S21: ns = `S22;
      `S22: ns = `S23;
      `S23: ns = `S0;
    endcase
  end
  
  always @(ps)
  begin
    {clrE, ldE, clrA, ldA, shA, ldX, shX, ldY, sel, selout, cin, done} = 11'b000_0000_0000;
    case (ps)
      `S0: ;
      `S1: {ldX, clrA, clrE} = 3'b111;
      `S2: ldY = 1'b1;
      `S3: {ldA, sel, cin} = 3'b111;
      `S4: {ldA} = 1'b1;
      `S5: {shA, shX, ldE} = 3'b111;
      `S6: ;
      `S7: {ldA, sel, cin} = 3'b111;
      `S8: {ldA} = 1'b1;
      `S9: {shA, shX, ldE} = 3'b111;
      `S10: ;
      `S11: {ldA, sel, cin} = 3'b111;
      `S12: {ldA} = 1'b1;
      `S13: {shA, shX, ldE} = 3'b111;
      `S14: ;
      `S15: {ldA, sel, cin} = 3'b111;
      `S16: {ldA} = 1'b1;
      `S17: {shA, shX, ldE} = 3'b111;
      `S18: ;
      `S19: {ldA, sel, cin} = 3'b111;
      `S20: {ldA} = 1'b1;
      `S21: {shA, shX, ldE} = 3'b111;
      `S22: done = 1'b1;
      `S23: {selout , done} = 2'b11;
    endcase
  end
  
endmodule 
