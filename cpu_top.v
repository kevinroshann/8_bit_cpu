module cpu_top(
    input clk,
    input rst
);
    reg [7:0] pc;
    wire [7:0] next_instr;
    wire [7:0] next_byte;
    wire [7:0] pc_plus_1;

    assign pc_plus_1 = pc + 1;

    integer cycle = 0;

    // Control signals
    wire [1:0] reg_dst, reg_src;
    wire alu_op;
    wire reg_write, mem_write, mem_read;
    wire use_imm, is_two_byte;

    wire [7:0] read_data1, read_data2;
    wire [7:0] write_back_data;
    wire [7:0] alu_result;
    wire [7:0] mem_data;

    // Modules
    instruction_memory imem1 (
        .addr(pc),
        .data(next_instr)
    );

    instruction_memory imem2 (
        .addr(pc_plus_1),
        .data(next_byte)
    );

    control_unit cu (
        .instr(next_instr),
        .reg_dst(reg_dst),
        .reg_src(reg_src),
        .alu_op(alu_op),
        .reg_write(reg_write),
        .mem_write(mem_write),
        .mem_read(mem_read),
        .use_imm(use_imm),
        .is_two_byte(is_two_byte)
    );

    register_file rf (
        .clk(clk),
        .rst(rst),
        .read_reg1(reg_dst),
        .read_reg2(reg_src),
        .write_reg(reg_dst),              // ✅ FIXED: use correct write register
        .write_data(write_back_data),
        .reg_write(reg_write),
        .read_data1(read_data1),
        .read_data2(read_data2)
    );

    alu alu_unit (
        .a(read_data1),
        .b(use_imm ? next_byte : read_data2),
        .alu_op(alu_op),
        .result(alu_result)
    );

    data_memory dmem (
        .clk(clk),
        .address(next_byte),
        .write_data(read_data2),
        .mem_write(mem_write),
        .mem_read(mem_read),
        .read_data(mem_data)
    );

    assign write_back_data = mem_read ? mem_data : alu_result;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            pc <= 0;
            cycle <= 0;
        end else begin
            // ✅ Handle HLT instruction (0xFF)
            if (next_instr === 8'hFF) begin
                $display("HLT encountered. Final Register State:");
                $display("Reg[0] = %h", rf.reg_file[0]);
                $display("Reg[1] = %h", rf.reg_file[1]);
                $display("Reg[2] = %h", rf.reg_file[2]);
                $display("Reg[3] = %h", rf.reg_file[3]);
                $finish;
            end

            // Debug output
            $display("----- Cycle %0d -----", cycle);
            $display("PC       = %0d", pc);
            $display("Instr    = %b", next_instr);
            $display("Reg[%0d] = %h (dest), Reg[%0d] = %h (src)", reg_dst, read_data1, reg_src, read_data2);
            $display("ALU Res  = %h", alu_result);
            if (mem_read)
                $display("LOAD from Mem[%h] = %h", next_byte, mem_data);
            if (mem_write)
                $display("STORE to Mem[%h] = %h", next_byte, read_data2);
            if (reg_write)
                $display("-> Writing %h to Reg[%0d]", write_back_data, reg_dst);
            $display("");

            // PC increment
            pc <= pc + (is_two_byte ? 2 : 1);
            cycle <= cycle + 1;
        end
    end
endmodule
