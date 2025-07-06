module control_unit(
    input [7:0] instr,
    output reg [1:0] reg_dst,
    output reg [1:0] reg_src,
output reg [3:0] alu_op,

    output reg reg_write,
    output reg mem_write,
    output reg mem_read,
    output reg use_imm,
    output reg is_two_byte
);
    wire [3:0] opcode = instr[7:4];

    always @(*) begin
        // Default signals
        reg_write   = 0;
        mem_write   = 0;
        mem_read    = 0;
        use_imm     = 0;
        is_two_byte = 0;
        alu_op      = 0;
        reg_dst     = instr[3:2];  // Default
        reg_src     = instr[1:0];

        case (opcode)
            4'b0001: begin // ADD
                reg_write = 1;
                alu_op = 0;
            end
            4'b0010: begin // SUB
                reg_write = 1;
                alu_op = 1;
            end
            4'b1001: begin // LOAD
                reg_write = 1;
                mem_read = 1;
                use_imm = 1;
                is_two_byte = 1;
                reg_dst = instr[3:2];  // destination from bits [3:2]
            end
            4'b1101: begin // STORE
                mem_write = 1;
                use_imm = 1;
                is_two_byte = 1;
                reg_src = instr[3:2]; // source register is bits [3:2]
            end
            4'b1111: begin // HLT
                // handled in cpu_top
            end
        endcase
    end
endmodule
