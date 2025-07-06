module alu(
    input [7:0] a,
    input [7:0] b,
    input alu_op,         // 0 = ADD, 1 = SUB
    output reg [7:0] result
);

    always @(*) begin
        case (alu_op)
            1'b0: result = a + b;   // ADD
            1'b1: result = a - b;   // SUB
            default: result = 8'b0;
        endcase
    end
endmodule
