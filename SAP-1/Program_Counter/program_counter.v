module program_counter (
    input CLK,
    input RST,
    input INC,
    output reg [3:0] count
);

always @(posedge CLK or posedge RST) begin
    if (RST) begin
        count <= 4'b0;
    end
    else if (INC) begin
        count <= count + 1;
    end
end

endmodule
