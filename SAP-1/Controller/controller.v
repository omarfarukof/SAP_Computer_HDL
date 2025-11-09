module controller (
    input CLK,
    input RST,
    input [3:0] OPC,
    output HLT,
    output [7:0] COUT
);  
    reg TCount;
    initial begin
        TCount = 3'b0;
    end
    always @(negedge CLK) begin
        if (TCount < 6)
            TCount = TCount + 1;
        else
            TCount = 3'b0;
    end

    always @(negedge CLK or posedge RST) begin
        if (RST) begin
            { CE, CO, MI, RO, II, IO, AI, AO, SU, EO, BI, OI } = 12'b0;
        end
        if (TCount==0) begin
            //TODO: controller == 0
            { CO, MI } = 2'b11;
        end
        if (TCount==1) begin
            //TODO: controller == 1
            { CO, MI } = 2'b00;
            CE = 1'b1;
        end
        if (TCount==2) begin
            //TODO: controller == 2
            CE = 1'b0;
            { RO, II } = 2'b11;
        end
        if (TCount==3) begin
            //TODO: controller == 3
            { RO, II } = 2'b00;
            if (conditions) begin
                // TODO: OpCode
            end
        end
        if (TCount==4) begin
            //TODO: controller == 4
        end
        if (TCount==5) begin
            //TODO: controller == 5 
        end
    end

    COUT = { CE, CO, MI, RO, II, IO, AI, AO, SU, EO, BI, OI };

endmodule