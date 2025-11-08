module alu (
    input SU,
    input EO,
    input [7:0] A,    
    input [7:0] B,
    output [7:0] OUT
);

    wire MEM;
    adder (
        .SUB(SU),
        .A(A),
        .B(B),
        .OUT(MEM),
    );

    always @(EO) begin
        OUT = MEM;
    end

    

    
endmodule