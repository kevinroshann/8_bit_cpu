module instruction_memory(
    input [7:0] addr,
    output reg [7:0] data
);
    reg [7:0] memory [0:255];

    always @(*) begin
        data = memory[addr];
    end

    initial begin
        memory[8'h00] = 8'b10010000; memory[8'h01] = 8'h10; // LOAD R0, 0x10
        memory[8'h02] = 8'b10010100; memory[8'h03] = 8'h11; // LOAD R1, 0x11
        memory[8'h04] = 8'b10011000; memory[8'h05] = 8'h12; // LOAD R2, 0x12
        memory[8'h06] = 8'b10011100; memory[8'h07] = 8'h13; // LOAD R3, 0x13

        memory[8'h08] = 8'b00010001;                        // ADD R0, R1
        memory[8'h09] = 8'b00101000;                        // SUB R2, R0
        memory[8'h0A] = 8'b00011111;                        // ADD R3, R3
        memory[8'h0B] = 8'b00100110;                        // SUB R1, R2

        memory[8'h0C] = 8'b11011100; memory[8'h0D] = 8'h30; // STORE R3, 0x30
        memory[8'h0E] = 8'b11010100; memory[8'h0F] = 8'h31; // STORE R1, 0x31
        memory[8'h10] = 8'b11010000; memory[8'h11] = 8'h32; // STORE R0, 0x32

        memory[8'h12] = 8'b10010000; memory[8'h13] = 8'h30; // LOAD R0, 0x30
        memory[8'h14] = 8'b10010100; memory[8'h15] = 8'h31; // LOAD R1, 0x31
        memory[8'h16] = 8'b10011000; memory[8'h17] = 8'h32; // LOAD R2, 0x32

        memory[8'h18] = 8'b00100001;                        // SUB R0, R1
        memory[8'h19] = 8'b00010001;                        // ADD R0, R1
        memory[8'h1A] = 8'b00100000;                        // SUB R0, R0
        memory[8'h1B] = 8'b00010001;                        // ADD R0, R1

        memory[8'h1C] = 8'b10010000; memory[8'h1D] = 8'h01; // LOAD R0, 0x01
        memory[8'h1E] = 8'b10010100; memory[8'h1F] = 8'h03; // LOAD R1, 0x03
        memory[8'h20] = 8'b10011000; memory[8'h21] = 8'h07; // LOAD R2, 0x07
        memory[8'h22] = 8'b10011100; memory[8'h23] = 8'h0F; // LOAD R3, 0x0F

        memory[8'h24] = 8'b11110000;                        // HLT
    end
endmodule
