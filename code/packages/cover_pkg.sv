package cover_pkg;
    import FIFO_transaction_pkg::*;

    class FIFO_coverage;

        FIFO_transaction F_cvg_txn;

        covergroup cg;
            
            wr_en_point:coverpoint F_cvg_txn.wr_en;
            rd_en_point:coverpoint F_cvg_txn.rd_en;
            wr_ack_point:coverpoint F_cvg_txn.wr_ack;
            overflow_point:coverpoint F_cvg_txn.overflow;
            full_point:coverpoint F_cvg_txn.full;
            empty_point:coverpoint F_cvg_txn.empty;
            almostfull_point:coverpoint F_cvg_txn.almostfull;
            almostempty_point:coverpoint F_cvg_txn.almostempty;
            underflow_point:coverpoint F_cvg_txn.underflow;
            
            wr_ack_point_cross:cross wr_en_point,rd_en_point,wr_ack_point{
                illegal_bins wr_and_wr_ack=binsof(wr_en_point)intersect{0}&&binsof(wr_ack_point)intersect{1};
            }
            overflow_point_cross:cross wr_en_point,rd_en_point,overflow_point{
                illegal_bins wr_and_over=binsof(wr_en_point)intersect{0}&&binsof(overflow_point)intersect{1};
            }
            full_point_cross:cross wr_en_point,rd_en_point,full_point{
                illegal_bins full_wr_rd=binsof(wr_en_point)intersect{0}&&binsof(rd_en_point)intersect{1}&&binsof(full_point)intersect{1};
            }
            empty_point_cross:cross wr_en_point,rd_en_point,empty_point;
            almostfull_point_cross:cross wr_en_point,rd_en_point,almostfull_point;
            almostempty_point_cross:cross wr_en_point,rd_en_point,almostempty_point;
            underflow_point_cross:cross wr_en_point,rd_en_point,underflow_point{
                illegal_bins underflow_and_rd=binsof(rd_en_point)intersect{0}&&binsof(underflow_point)intersect{1};
            }

        endgroup

        function new;
            cg=new();
            cg.start();//? TODO 
        endfunction

        function void sample_data(FIFO_transaction F_txn);
            F_cvg_txn=F_txn;
            cg.sample();//? TODO 
    endfunction

    endclass
endpackage