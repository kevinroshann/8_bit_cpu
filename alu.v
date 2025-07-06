module alu(
    input  [7:0] a,
    input  [7:0] b,
    input  [3:0] alu_op,         // Now 4-bit opcode
    output reg [7:0] result
);

    always @(*) begin
        case (alu_op)
            4'b0000: result = a + b;      // ADD
            4'b0001: result = a - b;      // SUB
            4'b0010: result = b;          // MOV (pass-through)
            4'b0011: result = a & b;      // AND
            4'b0100: result = a | b;      // OR
            default: result = 8'b0;
        endcase
    end
endmodule
