// alu.v
module alu(
    input  [7:0] a,
    input  [7:0] b,
    input  [3:0] alu_op,
    output reg [7:0] result
);

    always @(*) begin
        case (alu_op)
            4'b0000: result = a + b;      // ADD
            4'b0001: result = a - b;      // SUB
            // Add more operations here as needed, e.g.:
            // 4'b0010: result = a & b;      // AND
            // 4'b0011: result = a | b;      // OR
            // 4'b0100: result = ~a;       // NOT (unary, 'b' input would be ignored)
            default: result = 8'b0;       // Default to 0 or handle as an error
        endcase
    end
endmodule