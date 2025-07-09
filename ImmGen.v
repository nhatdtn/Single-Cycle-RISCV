module ImmGen (
    input [31:0] inst,
    output reg [31:0] imm
);
    always @(*) begin
	$display("ImmGen: Cycle=%0d, inst=%h, imm=%h", $time/10, inst, imm);
        case (inst[6:0]) // Opcode
            7'b0010011: // I-type (ADDI, etc.)
                imm = {{20{inst[31]}}, inst[31:20]};
            7'b0000011: // Load (LW)
                imm = {{20{inst[31]}}, inst[31:20]};
            7'b0100011: // Store (SW)
                imm = {{20{inst[31]}}, inst[31:25], inst[11:7]};
            7'b1100011: // Branch (BEQ, etc.)
                imm = {{19{inst[31]}}, inst[31], inst[7], inst[30:25], inst[11:8], 1'b0};
            7'b1101111: // JAL
                imm = {{11{inst[31]}}, inst[31], inst[19:12], inst[20], inst[30:21], 1'b0};
            7'b0110111: // LUI
                imm = {inst[31:12], 12'h000};
            7'b0010111: // AUIPC
                imm = {inst[31:12], 12'h000};
            default: imm = 32'h00000000;
        endcase
    end
endmodule