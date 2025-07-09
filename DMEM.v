module DMEM (
    input clk,
    input [31:0] addr,
    input [31:0] write_data,
    input mem_write,
    input mem_read,
    output reg [31:0] read_data
);
    reg [31:0] memory [0:255]; // 256 words

    always @(posedge clk) begin
        if (mem_write)
            memory[addr[31:2]] <= write_data;
    end

    always @(*) begin
        if (mem_read)
            read_data = memory[addr[31:2]];
        else
            read_data = 32'h00000000;
    end
endmodule