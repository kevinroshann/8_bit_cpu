module data_memory(
    input clk,
    input [7:0] address,
    input [7:0] write_data,
    input mem_write,
    input mem_read,
    output reg [7:0] read_data
);

    reg [7:0] memory [0:255];

    // Preload memory for LOAD instruction
initial begin
    memory[8'h0A] = 8'h05; // for MOVI R0, 0x05
    memory[8'h0B] = 8'h03; // for MOVI R1, 0x03
end



    always @(*) begin
        if (mem_read)
            read_data = memory[address];
        else
            read_data = 8'b0;
    end

    always @(posedge clk) begin
        if (mem_write)
            memory[address] <= write_data;
    end
endmodule
