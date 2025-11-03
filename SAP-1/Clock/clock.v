`timescale 1 ns / 1 ps

module clock (
    output CLK
);
    always begin
        #5
        CLK = ~CLK;
    end
endmodule
