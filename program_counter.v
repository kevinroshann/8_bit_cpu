module program_counter(
    input clk,
    input rst,
    input [7:0] next_pc,
    output reg [7:0] pc
);
    always @(posedge clk or posedge rst) begin
        if (rst)
            pc <= 8'b0;
        else
            pc <= next_pc;
    end
endmodule
