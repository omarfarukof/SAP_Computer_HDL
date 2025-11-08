module address_selector (
    input [3:0] R0,
    input [3:0] R1,
    input SW,
    output reg [3:0] R_OUT
);
    always begin
            R_OUT = R1
        else
            R_OUT = R0
    end
    
endmodule