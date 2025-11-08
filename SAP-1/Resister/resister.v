module resister (
    input CLK,
    input RST,
    input EnIn,
    input EnOut,
    input [7:0] R_IN,
    output reg [7:0] R_OUT
);
    reg [7:0] MEM
    always @(posedge CLK or posedge RST) begin
        if (RST)
            MEM <= 8'b0;
        else if (EnIn)
            MEM <= R_IN;
        else if (EnOut)
            R_OUT <= MEM;
    end

endmodule
