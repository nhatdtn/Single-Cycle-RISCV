module ControlUnit (
    input [6:0] opcode,
    input [2:0] funct3,
    input [6:0] funct7,
    output reg reg_write,
    output reg mem_read,
    output reg mem_write,
    output reg mem_to_reg,
    output reg [3:0] alu_op,
    output reg alu_src,
    output reg branch,
    output reg jump,
    output reg [1:0] pc_src
);
    always @(*) begin
	$display("ControlUnit: Cycle=%0d, opcode=%b, funct3=%b, funct7=%b, reg_write=%b, alu_src=%b, alu_op=%b",
                 $time/10, opcode, funct3, funct7, reg_write, alu_src, alu_op);
        reg_write = 1'b0;
        mem_read = 1'b0;
        mem_write = 1'b0;
        mem_to_reg = 1'b0;
        alu_op = 4'b0000;
        alu_src = 1'b0;
        branch = 1'b0;
        jump = 1'b0;
        pc_src = 2'b00; // PC + 4

        case (opcode)
            7'b0110011: begin // R-type
                reg_write = 1'b1;
                alu_src = 1'b0;
                case ({funct3, funct7})
                    {3'b000, 7'h00}: alu_op = 4'b0000; // ADD
                    {3'b000, 7'h20}: alu_op = 4'b0001; // SUB
                    {3'b001, 7'h00}: alu_op = 4'b0101; // SLL
                    {3'b010, 7'h00}: alu_op = 4'b1000; // SLT
                    {3'b011, 7'h00}: alu_op = 4'b1001; // SLTU
                    {3'b100, 7'h00}: alu_op = 4'b0100; // XOR
                    {3'b101, 7'h00}: alu_op = 4'b0110; // SRL
                    {3'b101, 7'h20}: alu_op = 4'b0111; // SRA
                    {3'b110, 7'h00}: alu_op = 4'b0011; // OR
                    {3'b111, 7'h00}: alu_op = 4'b0010; // AND
                endcase
            end
            7'b0010011: begin // I-type (ADDI, etc.)
                reg_write = 1'b1;
                alu_src = 1'b1;
                case (funct3)
                    3'b000: alu_op = 4'b0000; // ADDI
        	    3'b111: alu_op = 4'b0010; // ANDI
        	    3'b110: alu_op = 4'b0011; // ORI
        	    3'b100: alu_op = 4'b0100; // XORI
        	    3'b001: alu_op = 4'b0101; // SLLI
        	    3'b101: alu_op = (funct7 == 7'h00) ? 4'b0110 : 4'b0111; // SRLI, SRAI
        	    3'b010: alu_op = 4'b1000; // SLTI
        	    3'b011: alu_op = 4'b1001; // SLTIU
                endcase
            end
            7'b0000011: begin // Load (LW)
                reg_write = 1'b1;
                mem_read = 1'b1;
                mem_to_reg = 1'b1;
                alu_src = 1'b1;
                alu_op = 4'b0000; // ADD
            end
            7'b0100011: begin // Store (SW)
                mem_write = 1'b1;
                alu_src = 1'b1;
                alu_op = 4'b0000; // ADD
            end
            7'b1100011: begin // Branch (BEQ, etc.)
                branch = 1'b1;
                alu_op = 4'b0001; // SUB
                pc_src = 2'b01; // PC + imm (if branch taken)
            end
            7'b1101111: begin // JAL
                reg_write = 1'b1;
                jump = 1'b1;
                pc_src = 2'b01; // PC + imm
                alu_op = 4'b0000;
            end
            7'b1100111: begin // JALR
                reg_write = 1'b1;
                jump = 1'b1;
                pc_src = 2'b10; // rs1 + imm
                alu_op = 4'b0000;
                alu_src = 1'b1;
            end
            7'b0110111: begin // LUI
                reg_write = 1'b1;
                alu_src = 1'b1;
                alu_op = 4'b0000; // Pass immediate
            end
            7'b0010111: begin // AUIPC
                reg_write = 1'b1;
                alu_src = 1'b1;
                alu_op = 4'b0000; // ADD PC + imm
            end
	    default: begin
                $display("Unknown opcode: %b", opcode);
            end
        endcase
    end
endmodule