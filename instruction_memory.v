module instruction_memory(
    input [7:0] addr,
    output [7:0] data
);
    reg [7:0] memory [0:255];
    assign data = memory[addr];

initial begin
    memory[8'h00] = 8'b10010000; // LOAD R0, 0x0A
    memory[8'h01] = 8'h0A;
    memory[8'h02] = 8'b10010100; // LOAD R1, 0x0B
    memory[8'h03] = 8'h0B;
    memory[8'h04] = 8'b00101001; // SUB R2, R1
    memory[8'h05] = 8'b11110000; // HLT
end


endmodule
