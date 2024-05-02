////////////////////////////////////////////////////////////////////////////////
// Author: Kareem Waseem
// Course: Digital Verification using SV & UVM
//
// Description: FIFO Design 
// 
////////////////////////////////////////////////////////////////////////////////
module FIFO(FIFO_intf.dut intf);
localparam  FIFO_WIDTH = intf.FIFO_WIDTH;
localparam FIFO_DEPTH = intf.FIFO_DEPTH;
// //___________________________
// input [FIFO_WIDTH-1:0] data_in;
// input clk, rst_n, wr_en, rd_en;
// output reg [FIFO_WIDTH-1:0] data_out;
// output reg wr_ack, overflow;
// output full, empty, almostfull, almostempty, underflow;
// //_____________________________________________________

//___________________________
logic [FIFO_WIDTH-1:0] data_in;
logic clk, rst_n, wr_en, rd_en;
logic [FIFO_WIDTH-1:0] data_out;
logic wr_ack, overflow;
logic full, empty, almostfull, almostempty, underflow;
//_____________________________________________________

// ! input
assign data_in=intf.data_in;
assign clk=intf.clk;
assign rst_n=intf.rst_n;
assign wr_en=intf.wr_en;
assign rd_en=intf.rd_en;
//___________________________
// ! output
assign intf.data_out=data_out;
assign intf.wr_ack=wr_ack;
assign intf.overflow=overflow;
assign intf.full=full;
assign intf.empty=empty;
assign intf.almostfull=almostfull;
assign intf.almostempty=almostempty;
assign intf.underflow=underflow;

localparam max_fifo_addr = $clog2(FIFO_DEPTH);

reg [FIFO_WIDTH-1:0] mem [FIFO_DEPTH-1:0];

reg [max_fifo_addr-1:0] wr_ptr, rd_ptr;
reg [max_fifo_addr:0] count;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
		wr_ptr <= 0;
	end
	else if (wr_en && count < FIFO_DEPTH) begin
		mem[wr_ptr] <= data_in;
		//wr_ack <= 1; //!error here 
		wr_ptr <= wr_ptr + 1;
	end
	// else begin //!error here 
	// 	wr_ack <= 0; 
	// 	if (full & wr_en)
	// 		overflow <= 1;
	// 	else
	// 		overflow <= 0;
	// end
end

always @(posedge clk or negedge rst_n) begin
	if (!rst_n) begin
		rd_ptr <= 0;
	end
	else if (rd_en && count != 0) begin
		data_out <= mem[rd_ptr];
		rd_ptr <= rd_ptr + 1;
	end
end

always @(posedge clk or negedge rst_n) begin
	if (!rst_n) begin
		count <= 0;
	end
	else begin
		if	( ({wr_en, rd_en} == 2'b10) && !full) 
			count <= count + 1;
		else if ( ({wr_en, rd_en} == 2'b01) && !empty)
			count <= count - 1;
	end
end

assign full = (count == FIFO_DEPTH)? 1 : 0;
assign empty = (count == 0)? 1 : 0;
assign underflow = (empty && rd_en)? 1 : 0; 
//assign almostfull = (count == FIFO_DEPTH-2)? 1 : 0; // !error here
assign almostempty = (count == 1)? 1 : 0;
//*added code */
assign wr_ack=((count!=FIFO_DEPTH) &&wr_en)?1:0;
assign overflow=(full && wr_en)?1:0;
assign almostfull = (count == FIFO_DEPTH-1)? 1 : 0;

`ifdef SIM

	rd_count_assert:assert property (@(posedge clk) disable iff(!rst_n) (rd_en&&!wr_en&&count!=0) |=>($past(count)-1'b1==count));
	wr_count_assert:assert property (@(posedge clk) disable iff(!rst_n) (!rd_en&&wr_en&&count!=FIFO_DEPTH) |=>($past(count)+1'b1==count));
	rd_wr_count_assert:assert property (@(posedge clk) disable iff(!rst_n) (rd_en&&wr_en&&count!=0&&count!=FIFO_DEPTH) |=>($past(count)==count));
	
	rd_ptr_assert:assert property (@(posedge clk) disable iff(!rst_n) (rd_en&&count!=0) |=>($past(rd_ptr)+1'b1==rd_ptr));
	wr_ptr_assert:assert property (@(posedge clk) disable iff(!rst_n) (wr_en&&count!=FIFO_DEPTH) |=>($past(wr_ptr)+1'b1==wr_ptr));


	rd_count_cover:cover property (@(posedge clk) disable iff(!rst_n) (rd_en&&!wr_en&&count!=0) |=>($past(count)-1'b1==count));
	wr_count_cover:cover property (@(posedge clk) disable iff(!rst_n) (!rd_en&&wr_en&&count!=FIFO_DEPTH) |=>($past(count)+1'b1==count));
	rd_wr_count_cover:cover property (@(posedge clk) disable iff(!rst_n) (rd_en&&wr_en&&count!=0&&count!=FIFO_DEPTH) |=>($past(count)==count));
	
	rd_ptr_cover:cover property (@(posedge clk) disable iff(!rst_n) (rd_en&&count!=0) |=>($past(rd_ptr)+1'b1==rd_ptr));
	wr_ptr_cover:cover property (@(posedge clk) disable iff(!rst_n) (wr_en&&count!=FIFO_DEPTH) |=>($past(wr_ptr)+1'b1==wr_ptr));

	always_comb begin  
		if(!rst_n)begin
		rst_count_assert:assert final (count==0);
		rst_rd_ptr_assert:assert final (rd_ptr==0);
		rst_wr_ptr_assert:assert final (wr_ptr==0);
		end

		if(count==0)begin
			empty_assert:assert final(empty==1);
		end

		if(count==0 && rd_en)begin
			underflow_assert:assert final(underflow==1);
		end

		if (count==1) begin
			almostempty_assert:assert final(almostempty==1);
		end

		if (count==FIFO_DEPTH-1) begin
			almostfull_assert:assert final(almostfull==1);
		end

		if(count==FIFO_DEPTH)begin
			full_assert:assert final(full==1);
		end

		if(count==FIFO_DEPTH && wr_en)begin
			overflow_assert:assert final(overflow==1);
		end

		if(count!=FIFO_DEPTH && wr_en)begin
			wr_ack_assert:assert final(wr_ack==1);
		end
	end
`endif

endmodule