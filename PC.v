module PC (
    input clk,
    input rst_n,
    input [31:0] pc_in,
    input pc_write,
    output reg [31:0] pc_out
);
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            pc_out <= 32'h00000000;
        else if (pc_write)
            pc_out <= pc_in;
    end
endmodule