module top();

	bit clk ;

	initial begin 
    clk= 0 ;
    forever #1 clk = ~clk ; 
  end 

  FIFO_intf intf (clk) ;
  FIFO  dut (intf);
  monitor mon (intf) ;
  test tb (intf); 

endmodule



