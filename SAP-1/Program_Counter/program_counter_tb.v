`timescale 1 ns / 1 ps

module tb_program_counter ();
    wire        clk;
    wire        rst;
    wire        inc;
    wire [3:0]  count;

    program_counter dut (
        .CLK   (clk),
        .RST   (rst),
        .INC   (inc),
        .count (count)
    );

/* -------------------- clock generation --------------- */
initial begin
    clk = 0;
    forever #5 clk = ~clk;   // 10 ns period
end

/* -------------------- stimulus & check --------------- */
initial begin
    rst = 1;
    inc = 0;
    @(posedge clk);
    @(posedge clk);
    assert (count === 4'd0) else $fatal("Reset failed");

    rst = 0;                 // leave reset
    @(posedge clk);
    assert (count === 4'd0) else $fatal("Count changed while INC=0");

    inc = 1;                 // start counting
    repeat (5) @(posedge clk);
    assert (count === 4'd5) else $fatal("Count mismatch after 5 inc");

    inc = 0;                 // hold
    @(posedge clk);
    assert (count === 4'd5) else $fatal("Count changed while INC=0");

    $display("All tests passed.");
    $finish;
end

/* -------------------- wave dump (optional) ----------- */
initial begin
    $dumpfile("program_counter_tb.vcd");
    $dumpvars(0, program_counter_tb);
end

endmodule
