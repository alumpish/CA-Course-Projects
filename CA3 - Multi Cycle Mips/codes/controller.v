`define IF              4'd0
`define ID              4'd1
`define Memory          4'd2
`define Load            4'd3
`define Load_Write      4'd4
`define Store           4'd5
`define R_type          4'd6
`define R_type_Write    4'd7
`define Branch          4'd8
`define Jump            4'd9
`define Addi            4'd10
`define Addi_Write      4'd11
`define Jal             4'd12
`define Jr              4'd13
`define Slti            4'd14
`define Slti_Write      4'd15


module controller(clk, rst, opcode, func, PCWrite, PCWriteCond, IorD,
                  IRWrite, RegDst, MemToReg, S1, S2, RegWrite, ALUSrcA, ALUSrcB,
                  Operation, PCSrc, MemWrite, MemRead);

  input clk, rst;
  input [5:0] opcode,func;
  output reg PCWrite, PCWriteCond, IorD, IRWrite, RegDst, MemToReg, S2, S1, RegWrite, ALUSrcA, MemWrite, MemRead;
  output reg [1:0] ALUSrcB,PCSrc;
  output [2:0] Operation;
  reg[3:0] ns,ps;
  reg[1:0] ALUOp;

  alu_controller AC (ALUOp, func, Operation);

  always @(ps, opcode) begin
    ns = `IF;
    case(ps)
      0: ns = 1;
      
      1:
      case(opcode)
      // RType
        6'b000000: ns = `R_type;   
        // Load Word (lw)    
        6'b100011: ns = `Memory;  
        // Store Word (sw)
        6'b101011: ns = `Memory;                               
        // Branch on equal (beq)
        6'b000100: ns = `Branch; 
        // Add immediate (addi)
        6'b001001: ns = `Addi;  
       // Set on less than immediate (slti)
        6'b001010: ns = `Slti; 
       //Jump
        6'b000010: ns = `Jump  ; 
       //Jump And Link
        6'b000011: ns = `Jal ; 
        //Jump Register
        6'b000110: ns = `Jr ;
        default : ns = `IF;
     endcase

   2: ns = opcode[3] ? `Store : `Load;
   3: ns = `Load_Write;
   4: ns = `IF;
   5: ns = `IF;
   6: ns = `R_type_Write;
   7: ns = `IF;
   8: ns = `IF;
   9: ns = `IF;
   10: ns = `Addi_Write;
   11: ns = `IF;
   12: ns = `IF;
   13: ns = `IF;
   14: ns = `Slti_Write;
   15: ns = `IF;
   default: ns = `IF;
   endcase
 end

 always @(ps) begin
   {PCWrite, PCWriteCond, IorD, IRWrite, RegDst, MemToReg, S2,
    S1, RegWrite, ALUSrcA, MemWrite, MemRead, ALUSrcB, PCSrc} = 16'b0;

   case(ps)
    `IF: {MemRead, ALUSrcA, IorD, IRWrite ,ALUSrcB, ALUOp, PCWrite, PCSrc} = 11'b10010100100;
    `ID: {ALUSrcA, ALUSrcB, ALUOp} = 5'b01100;
    `Memory: {ALUSrcA, ALUSrcB, ALUOp} = 5'b11000;
    `Load: {MemRead, IorD} = 2'b11;
    `Load_Write: {RegDst, RegWrite, MemToReg} = 3'b011;
    `Store: {MemWrite, IorD} = 2'b11;
    `R_type: {ALUSrcA, ALUSrcB, ALUOp} = 5'b10010;
    `R_type_Write: {RegDst, RegWrite, MemToReg} = 3'b110;
    `Branch: {ALUSrcA, ALUSrcB, ALUOp, PCWriteCond, PCSrc} = 8'b10001110;
    `Jump: {PCWrite, PCSrc} = 3'b101;
    `Addi: {ALUSrcA, ALUSrcB, ALUOp} = 5'b11000;
    `Addi_Write: {MemToReg, RegWrite, S1, S2, RegDst} = 5'b01000;
    `Jal: {S1, S2, PCWrite, RegWrite, PCSrc} = 6'b111101;
    `Jr: {PCWrite, PCSrc} = 3'b111;
    `Slti: {ALUSrcA, ALUSrcB, ALUOp} = 5'b11011;
    `Slti_Write: {MemToReg, RegWrite, S1, S2, RegDst} = 5'b01000;
   endcase
 end

 always @(posedge clk, posedge rst) begin
    if(rst)
      ns = `IF;
    else
      ps = ns;
 end
endmodule
