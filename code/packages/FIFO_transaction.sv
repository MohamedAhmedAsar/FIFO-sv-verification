package FIFO_transaction_pkg ; 
parameter FIFO_WIDTH = 16;
parameter FIFO_DEPTH = 8;
int WR_EN_ON_DIST=70 ; 
int RD_EN_ON_DIST=30 ; 

    class FIFO_transaction ;
    rand bit [FIFO_WIDTH-1:0] data_in;
    rand bit rst_n,  wr_en, rd_en;
    bit clk ;  
    bit [FIFO_WIDTH-1:0] data_out;
    bit wr_ack, overflow;
    bit full, empty, almostfull, almostempty, underflow; 
        
        constraint rst_con {
        rst_n dist {0:=2 , 1:=98 } ; 	
        }
    
        constraint wr_en_con {
        wr_en dist {1:=WR_EN_ON_DIST , 0:=100-WR_EN_ON_DIST } ; 	
        }

        constraint rd_en_con {
        rd_en dist {1:=RD_EN_ON_DIST , 0:=100-RD_EN_ON_DIST } ; 	
        }   

    endclass
endpackage 