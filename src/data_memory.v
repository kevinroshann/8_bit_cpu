module data_memory(
    input clk,
    input [7:0] address,
    input [7:0] write_data,
    input mem_write,
    input mem_read,
    output reg [7:0] read_data
);
    reg [7:0] memory [0:255];
    integer i;

    initial begin
        // Clear all memory
        for (i = 0; i < 256; i = i + 1) memory[i] = 8'h00;

        // Initial data for LOADs
        memory[8'h10] = 8'hAA; // R0
        memory[8'h11] = 8'hBB; // R1
        memory[8'h12] = 8'hCC; // R2
        memory[8'h13] = 8'hDD; // R3

        // For later loads to set known register values
        memory[8'h01] = 8'h01; // R0 final
        memory[8'h03] = 8'h03; // R1 final
        memory[8'h07] = 8'h07; // R2 final
        memory[8'h0F] = 8'h0F; // R3 final

        // 0x30, 0x31, 0x32 will be written and reloaded
    end

    always @(*) begin
        if (mem_read)
            read_data = memory[address];
        else
            read_data = 8'h00;
    end

    always @(posedge clk) begin
        if (mem_write)
            memory[address] <= write_data;
    end
endmodule
