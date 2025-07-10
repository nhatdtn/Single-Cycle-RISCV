module ImmGen (
    input [31:0] instr,
	output reg [31:0] immValue
);
    always @(*) begin
	    $display("ImmGen: Cycle=%0d, instr=%h, immValue=%h", $time/10, instr, immValue);
        case (instr[6:0]) // Opcode
            7'b0010011: // I-type (ADDI, etc.)
                immValue = {{20{instr[31]}}, instr[31:20]};
            7'b0000011: // Load (LW)
                immValue = {{20{instr[31]}}, instr[31:20]};
            7'b0100011: // Store (SW)
                immValue = {{20{instr[31]}}, instr[31:25], instr[11:7]};
            7'b1100011: // Branch (BEQ, etc.)
                immValue = {{19{instr[31]}}, instr[31], instr[7], instr[30:25], instr[11:8], 1'b0};
            7'b1101111: // JAL
                immValue = {{11{instr[31]}}, instr[31], instr[19:12], instr[20], instr[30:21], 1'b0};
            7'b0110111: // LUI
                immValue = {instr[31:12], 12'h000};
            7'b0010111: // AUIPC
                immValue = {instr[31:12], 12'h000};
            default: immValue = 32'h00000000;
        endcase
    end
endmodule
