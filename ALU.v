module ALU (
    input [31:0] operand1,
    input [31:0] operand2,
    input [3:0] alu_op,
    output reg [31:0] result,
    output reg zero
);
    always @(*) begin
	$display("ALU: Cycle=%0d, op1=%h, op2=%h, alu_op=%b, result=%h",
                 $time/10, operand1, operand2, alu_op, result);
        case (alu_op)
            4'b0000: result = operand1 + operand2; // ADD
            4'b0001: result = operand1 - operand2; // SUB
            4'b0010: result = operand1 & operand2; // AND
            4'b0011: result = operand1 | operand2; // OR
            4'b0100: result = operand1 ^ operand2; // XOR
            4'b0101: result = operand1 << operand2[4:0]; // SLL
            4'b0110: result = operand1 >> operand2[4:0]; // SRL
            4'b0111: result = $signed(operand1) >>> operand2[4:0]; // SRA
            4'b1000: result = ($signed(operand1) < $signed(operand2)) ? 32'h1 : 32'h0; // SLT
            4'b1001: result = (operand1 < operand2) ? 32'h1 : 32'h0; // SLTU
            default: result = 32'h00000000;
        endcase
        zero = (result == 32'h00000000);
    end
endmodule