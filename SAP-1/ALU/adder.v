module adder (
    input SUB,
    input [7:0] A,
    input [7:0] B,
    output reg [7:0] OUT,
);
    always begin
        if (SUB) 
            OUT <= A + B;
        else
            OUT <= A - B;       
    end

endmodule