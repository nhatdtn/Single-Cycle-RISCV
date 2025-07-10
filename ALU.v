module ALU (
    input [31:0] value1,
    input [31:0] value2,
    input [3:0] alu_op,
    output reg [31:0] finalValue,
    output reg zero
);
    always @(*) begin
	$display("ALU: Cycle=%0d, op1=%h, op2=%h, alu_op=%b, finalValue=%h",
                 $time/10, value1, value2, alu_op, finalValue);
        case (alu_op)
            4'b0000: finalValue = value1 + value2; // ADD
            4'b0001: finalValue = value1 - value2; // SUB
            4'b0010: finalValue = value1 & value2; // AND
            4'b0011: finalValue = value | value2; // OR
            4'b0100: finalValue = value1 ^ value2; // XOR
            4'b0101: finalValue = value1 << value2[4:0]; // SLL
            4'b0110: finalValue = value1 >> value2[4:0]; // SRL
            4'b0111: finalValue = $signed(value1) >>> value2[4:0]; // SRA
            4'b1000: finalValue = ($signed(value1) < $signed(value2)) ? 32'h1 : 32'h0; // SLT
            4'b1001: finalValue = (value1 < value2) ? 32'h1 : 32'h0; // SLTU
            default: finalValue = 32'h00000000;
        endcase
        zero = (finalValue == 32'h00000000);
    end
endmodule
