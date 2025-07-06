module instruction_memory(
    input [7:0] addr,
    output [7:0] data
);
    reg [7:0] memory [0:255];
    assign data = memory[addr];

    initial begin
        // LOAD R0, 0x0A
        memory[0] = 8'b10010000;
        memory[1] = 8'h0A;

        // LOAD R1, 0x0B
        memory[2] = 8'b10010100;
        memory[3] = 8'h0B;

        // ADD R2, R0
        memory[4] = 8'b00011000;

        // ADD R2, R1
        memory[5] = 8'b00011010;

        // STORE R2, 0x0D
        memory[6] = 8'b11011000;
        memory[7] = 8'h0D;

        // HLT
        memory[8] = 8'hFF;
    end
endmodule
