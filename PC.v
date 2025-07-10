module PC (
    input clk,
    input rst_n,
    input [31:0] pcValueIn,
    input pcWrite,
    output reg [31:0] pcValueOut
);
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            pcValueOut <= 32'd0;
        else if (pcWrite)
            pcValueOut <= pcValueIn;
    end
endmodule
