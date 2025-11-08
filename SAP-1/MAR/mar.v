module mar (
    input CLK,
    input EnIn,
    input [3:0] R_IN,
    output reg [3:0] R_OUT
);

    always @(posedge CLK) begin
        if (EnIn)
            R_OUT <= R_IN
    end
    
endmodule