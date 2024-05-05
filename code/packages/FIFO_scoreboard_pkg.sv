package FIFO_scoreboard_pkg;
    import FIFO_transaction_pkg::*; 
    import shared_pkg::*;


    class FIFO_scoreboard #(FIFO_WIDTH=16,FIFO_DEPTH=8);
        
        localparam max_fifo_addr=$clog2(FIFO_DEPTH);
        bit [FIFO_WIDTH-1:0] data_out_ref;
        bit full_ref, empty_ref, almost_full_ref, almost_empty_ref, overflow_ref, underflow_ref;

        bit [FIFO_WIDTH]fifo_mem[FIFO_DEPTH];
        bit [max_fifo_addr]read_ptr = 0;
        bit [max_fifo_addr] write_ptr = 0;
        bit [max_fifo_addr+1] count;

        function void reference_model(FIFO_transaction trans);
            
        if (!trans.rst_n) begin
            read_ptr = 0;
            write_ptr = 0;
            count = 0;
            data_out_ref=0;
        end
        else begin
            

            if (trans.rd_en && count!=0) begin
                data_out_ref=fifo_mem[read_ptr];
                read_ptr++;
            end
            if (trans.wr_en&& count !=FIFO_DEPTH) begin
                fifo_mem[write_ptr]=trans.data_in;
                write_ptr++;
            end
            if(trans.wr_en && !trans.rd_en &&count !=FIFO_DEPTH) count++;
            if(!trans.wr_en && trans.rd_en &&count !=0) count--;
        end
        endfunction

        function void check_data(FIFO_transaction trans);
            reference_model(trans); 
            if (trans.data_out != data_out_ref) begin
                $display("Error dataout=%0d expected=%0d",trans.data_out,data_out_ref);
                shared_pkg::error_count++;
            end else begin
                //$display("Correct data.");
                shared_pkg::correct_count++;
            end
        endfunction

    endclass
endpackage
