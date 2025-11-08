module input_unit (
    input [7:0] DataIn,
    input [3:0] AddrIn,
    input R_W,
    output reg [7:0] DataOut,
    output [3:0] AddrOut
);
    assign AddrOut = AddrIn;
    
    always @(R_W) begin
        DataOut <= DataIn;

    end
    
endmodule