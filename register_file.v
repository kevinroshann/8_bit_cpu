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
    reg [7:0] reg_file [0:3];

    assign read_data1 = reg_file[read_reg1];
    assign read_data2 = reg_file[read_reg2];

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            reg_file[0] <= 8'h00;
            reg_file[1] <= 8'h00;
            reg_file[2] <= 8'h00;
            reg_file[3] <= 8'h00;
        end else if (reg_write) begin
            reg_file[write_reg] <= write_data;
        end
    end
endmodule
