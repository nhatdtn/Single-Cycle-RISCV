module IMEM (
    input [31:0] addr,
    output [31:0] inst
);
    reg [31:0] memory [0:255]; // 256 words
    
    assign inst = memory[addr[31:2]]; // Word-aligned address

    always @(*) begin
        $display("IMEM: Cycle=%0d, addr=%h, inst=%h", $time/10, addr, inst);
    end
endmodule