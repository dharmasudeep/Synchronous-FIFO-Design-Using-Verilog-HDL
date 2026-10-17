
`timescale 1ns/1ps

module tb_sync_fifo;

    reg clk;
    reg rst;
    reg wr_en;
    reg rd_en;
    reg [7:0] data_in;

    wire [7:0] data_out;
    wire full;
    wire empty;

    // Connect the FIFO design to the testbench
    sync_fifo dut (
        .clk(clk),
        .rst(rst),
        .wr_en(wr_en),
        .rd_en(rd_en),
        .data_in(data_in),
        .data_out(data_out),
        .full(full),
        .empty(empty)
    );

    // Generate a clock with a 10 ns period
    always #5 clk = ~clk;

    // Write one data item
    task write_data;
        input [7:0] value;
        begin
            @(negedge clk);
            data_in = value;
            wr_en = 1;
            rd_en = 0;

            @(negedge clk);
            wr_en = 0;
        end
    endtask

    // Read one item and check the expected value
    task read_data;
        input [7:0] expected;
        begin
            @(negedge clk);
            wr_en = 0;
            rd_en = 1;

            @(posedge clk);
            #1;

            if (data_out !== expected) begin
                $display("FAIL: Expected %0d, got %0d",
                         expected, data_out);
                $finish;
            end else begin
                $display("PASS: Expected %0d, got %0d",
                         expected, data_out);
            end

            @(negedge clk);
            rd_en = 0;
        end
    endtask

    initial begin
        $dumpfile("fifo.vcd");
        $dumpvars(0, tb_sync_fifo);

        clk = 0;
        rst = 1;
        wr_en = 0;
        rd_en = 0;
        data_in = 0;

        // Reset the FIFO
        repeat (2) @(negedge clk);
        rst = 0;
        #1;

        if (empty !== 1'b1) begin
            $display("FAIL: FIFO should be empty after reset");
            $finish;
        end

        $display("PASS: FIFO reset");

        // Write three values
        write_data(10);
        write_data(20);
        write_data(30);

        // Read the same values in FIFO order
        read_data(10);
        read_data(20);
        read_data(30);

        if (empty !== 1'b1) begin
            $display("FAIL: FIFO should be empty");
            $finish;
        end

        $display("PASS: FIFO ordering");
        $display("ALL BASIC TESTS PASSED");

        $finish;
    end

endmodule
