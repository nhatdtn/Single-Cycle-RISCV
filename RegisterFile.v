module RegisterFile (
    input clk,
    input rst_n,
    input [4:0] rs1, // Source register 1
    input [4:0] rs2, // Source register 2
    input [4:0] rd,  // Destination register
    input [31:0] write_data,
    input reg_write,
    output [31:0] read_data1,
    output [31:0] read_data2
);
    reg [31:0] registers [0:31];
    integer i;

    // Initialize registers
    always @(negedge rst_n) begin
        for (i = 0; i < 32; i = i + 1)
            registers[i] <= 32'h00000000;
    end

    // Write operation
    always @(posedge clk) begin
        if (reg_write && rd != 5'b00000) // x0 is always 0
            registers[rd] <= write_data;
	$display("RegisterFile: Cycle=%0d, rd=%0d, write_data=%h, x3=%h",
                     $time/10, rd, write_data, registers[3]);
    end

    // Read operation
    assign read_data1 = (rs1 == 5'b00000) ? 32'h00000000 : registers[rs1];
    assign read_data2 = (rs2 == 5'b00000) ? 32'h00000000 : registers[rs2];
endmodule