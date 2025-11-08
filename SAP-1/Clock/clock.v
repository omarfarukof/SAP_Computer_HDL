`timescale 1 ns / 1 ps

module clock (
    input HLT,
    output CLK
);
    always @(!HLT) begin
        #5
        CLK = ~CLK;
    end
endmodule
