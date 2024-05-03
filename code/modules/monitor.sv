import FIFO_transaction_pkg::*;
import FIFO_scoreboard_pkg::*;
import cover_pkg::*;
import shared_pkg::*;
module monitor(FIFO_intf.monitor dut_if);

    FIFO_transaction f_txn;
    FIFO_scoreboard f_scoreboard = new();
    FIFO_coverage f_coverage = new();

    initial begin
        f_txn = new();
        forever begin
            
            f_txn.data_in = dut_if.data_in;
            f_txn.wr_en = dut_if.wr_en;
            f_txn.rd_en = dut_if.rd_en;
            f_txn.rst_n = dut_if.rst_n;
            @(negedge dut_if.clk);
            f_txn.data_out = dut_if.data_out;
            f_txn.full = dut_if.full;
            f_txn.almostfull = dut_if.almostfull;
            f_txn.empty = dut_if.empty;
            f_txn.almostempty = dut_if.almostempty;
            f_txn.overflow = dut_if.overflow;
            f_txn.underflow = dut_if.underflow;
            f_txn.wr_ack = dut_if.wr_ack;
            @(posedge dut_if.clk);
            fork
                //process 1
                begin
                    f_coverage.sample_data(f_txn);
                end
                //process 2
                begin
                    
                    f_scoreboard.check_data(f_txn);
                end

            join

            if (shared_pkg::test_finished) begin
                $display("Test finished. Correct: %0d, Errors: %0d", correct_count, error_count);
                $stop;    
            end
        end
    end
endmodule
