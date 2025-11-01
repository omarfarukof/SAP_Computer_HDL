module resister (
    input CLK,
    input RST,
    input LOAD,
    input [7:0] R_IN,
    output [7:0] R_OUT
);

always @(posedge CLK or posedge RST) begin
    if (RST) begin
        R_OUT <= 8'b0;
    end
    else if (LOAD) begin
        R_OUT <= R_IN;
    end
end

endmodule
