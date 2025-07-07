// register_file.v
module register_file(
    input clk,
    input rst,
    input [1:0] read_reg1,
    input [1:0] read_reg2,
    input [1:0] write_reg,
    input [7:0] write_data,
    input reg_write,
    output [7:0] read_data1,
    output [7:0] read_data2
);
    reg [7:0] reg_file [0:3]; // Array of 4 8-bit registers (R0, R1, R2, R3)

    // Combinational reads: Data is available immediately based on address
    assign read_data1 = reg_file[read_reg1];
    assign read_data2 = reg_file[read_reg2];

    // Synchronous write: Register is written on the positive edge of the clock
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            // Reset all registers to 0
            reg_file[0] <= 8'h00;
            reg_file[1] <= 8'h00;
            reg_file[2] <= 8'h00;
            reg_file[3] <= 8'h00;
        end else if (reg_write) begin
            // Write data to the specified register if reg_write is high
            reg_file[write_reg] <= write_data;
        end
    end
endmodule