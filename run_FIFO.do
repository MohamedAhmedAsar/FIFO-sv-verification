vlog code/* +define+SIM +cover

vsim -voptargs=+acc work.top -cover 

add wave -position insertpoint  \
sim:/top/intf/FIFO_WIDTH \
sim:/top/intf/FIFO_DEPTH \
sim:/top/intf/clk \
sim:/top/intf/data_in \
sim:/top/intf/rst_n \
sim:/top/intf/wr_en \
sim:/top/intf/rd_en \
sim:/top/intf/data_out \
sim:/top/intf/wr_ack \
sim:/top/intf/overflow \
sim:/top/intf/full \
sim:/top/intf/empty \
sim:/top/intf/almostfull \
sim:/top/intf/almostempty \
sim:/top/intf/underflow

run -all