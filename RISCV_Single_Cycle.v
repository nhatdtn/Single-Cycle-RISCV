module RISCV_Single_Cycle (
    input clk,
    input rst_n,
    output [31:0] PC_out_top,
    output [31:0] Instruction_out_top
);

    // Wires
    wire [31:0] pc_out, pc_in, inst, imm, read_data1, read_data2, alu_finalValue, mem_read_data, write_data;
    wire [31:0] alu_value2, pc_plus_4, branch_target, jalr_target;
    wire reg_write, mem_read, mem_write, mem_to_reg, alu_src, branch, jump, zero;
    wire [3:0] alu_op;
    wire [1:0] pc_src;
    wire pc_write;

    // PC
    assign pc_write = 1'b1; // Always write PC
    assign pc_plus_4 = pc_out + 4;
    assign branch_target = pc_out + imm;
    assign jalr_target = read_data1 + imm;
    assign pc_in = (pc_src == 2'b00) ? pc_plus_4 :
                   (pc_src == 2'b01) ? branch_target :
                   (pc_src == 2'b10) ? jalr_target : pc_plus_4;

    PC pc_inst (
        .clk(clk),
        .rst_n(rst_n),
        .pc_in(pc_in),
        .pc_write(pc_write),
        .pc_out(pc_out)
    );

    // IMEM
    IMEM IMEM_inst (
        .addr(pc_out),
        .inst(inst)
    );

    // Control Unit
    ControlUnit ctrl_inst (
        .opcode(inst[6:0]),
        .funct3(inst[14:12]),
        .funct7(inst[31:25]),
        .reg_write(reg_write),
        .mem_read(mem_read),
        .mem_write(mem_write),
        .mem_to_reg(mem_to_reg),
        .alu_op(alu_op),
        .alu_src(alu_src),
        .branch(branch),
        .jump(jump),
        .pc_src(pc_src)
    );

    // Register File
    RegisterFile Reg_inst (
        .clk(clk),
        .rst_n(rst_n),
        .rs1(inst[19:15]),
        .rs2(inst[24:20]),
        .rd(inst[11:7]),
        .write_data(write_data),
        .reg_write(reg_write),
        .read_data1(read_data1),
        .read_data2(read_data2)
    );

    // Immediate Generator
    ImmGen imm_gen_inst (
        .inst(inst),
        .imm(imm)
    );

    // ALU
    assign alu_value2 = alu_src ? imm : read_data2;
    ALU alu_inst (
        .value1(read_data1),
        .value2(alu_value2),
        .alu_op(alu_op),
        .finalValue(alu_finalValue),
        .zero(zero)
    );

    // Data Memory
    DMEM DMEM_inst (
        .clk(clk),
        .addr(alu_finalValue),
        .write_data(read_data2),
        .mem_write(mem_write),
        .mem_read(mem_read),
        .read_data(mem_read_data)
    );

    // Write-back
    assign write_data = mem_to_reg ? mem_read_data : 
                        (jump ? pc_plus_4 : alu_finalValue);

    // Outputs for testbench
    assign PC_out_top = pc_out;
    assign Instruction_out_top = inst;

    always @(posedge clk) begin
        $display("Cycle=%0d, PC=%h, Inst=%h, x3=%h, imm=%h, alu_finalValue=%h, reg_write=%b, alu_src=%b, alu_op=%b",
                 $time/10, pc_out, inst, Reg_inst.registers[3], imm, alu_finalValue,
                 ctrl_inst.reg_write, ctrl_inst.alu_src, ctrl_inst.alu_op);
    end
endmodule
