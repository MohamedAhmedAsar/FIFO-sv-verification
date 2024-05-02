module top;
    bit clk;
    always begin
        #5;
        clk=~clk;
    end
    FIFO_intf intf(clk);
    FIFO dut(intf);
    initial begin 
        intf.rst_n=0;
        @(negedge clk);
        intf.rst_n=1;
        repeat(1000)begin
        intf.wr_en=$random;
        intf.data_in=$random;
        intf.rd_en=$random;
        @(negedge clk);
        end
        $stop;
    end
endmodule