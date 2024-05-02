package FIFO_scoreboard_pkg;
    import FIFO_transaction_pkg::*; 
    import shared_pkg::*;


    class FIFO_scoreboard;
        bit [15-1:0] data_out_ref;
        bit full_ref, empty_ref, almost_full_ref, almost_empty_ref, overflow_ref, underflow_ref;

        function new();
        endfunction

        function void reference_model(FIFO_transaction trans);
        static bit [15:0] fifo_mem[FIFO_DEPTH]; 
        static bit [2:0]read_ptr = 0;
        static bit [2:0] write_ptr = 0;
        static bit [3:0] count;

        if (!trans.rst_n) begin
            read_ptr = 0;
            write_ptr = 0;
            count = 0;
            empty_ref = 1;
            full_ref = 0;
            almost_empty_ref = 1;
            almost_full_ref = 0;
            overflow_ref = 0;
            underflow_ref = 0;
            return;
        end


        if (trans.wr_en && !full_ref) begin
            fifo_mem[write_ptr] = trans.data_in;
            write_ptr = write_ptr + 1;
            count = count + 1;
            overflow_ref = 0;
        end else if (trans.wr_en && full_ref) begin
            overflow_ref = 1;
        end

        if (trans.rd_en && !empty_ref) begin
            data_out_ref = fifo_mem[read_ptr];
            read_ptr = read_ptr + 1;
            count = count - 1;
            underflow_ref = 0;
        end else if (trans.rd_en && empty_ref) begin
            underflow_ref = 1;
        end

        full_ref = (count == FIFO_DEPTH);
        empty_ref = (count == 0);
        almost_full_ref = (count == FIFO_DEPTH - 1);
        almost_empty_ref = (count == 1);

        endfunction

        function void check_data(FIFO_transaction trans);
            reference_model(trans); 
            if (trans.data_out !== data_out_ref || trans.full !== full_ref ||
                trans.empty !== empty_ref || trans.almost_full !== almost_full_ref ||
                trans.almost_empty !== almost_empty_ref || trans.overflow !== overflow_ref ||
                trans.underflow !== underflow_ref) begin
                $display("Error");
                shared_pkg::error_count++;
            end else begin
                $display("Correct data.");
                shared_pkg::correct_count++;
            end
        endfunction

    endclass
endpackage
