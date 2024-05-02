import shared_pkg ::*;

module test (FIFO_intf.tb intf) ; 
	FIFO_transaction trans ;

	initial begin 
		trans = new() ;
      
      assert_reset ; 

      repeat(10000) begin
      assert(trans.randomize());
      intf.data_in=trans.data_in; 
      intf.wr_en=trans.wr_en; 
      intf.rd_en=trans.rd_en;
      intf.rst_n=trans.rst_n;
      @(negedge intf.clk);
      end
      test_finished =  1; 
   end

   task assert_reset ;
      intf.rst_n = 0 ;
      @(negedge intf.clk) ; 
      intf.rst_n= 1 ; 
   endtask

endmodule 