vlog -f code/list.list -mfcu +define+SIM +cover

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
add wave -position insertpoint  \
sim:/top/mon/f_scoreboard
coverage save fiforpt.ucdb -onexit -du work.top
run -all
coverage report -detail -cvg -directive -comments -output fcover_report.txt /cover_pkg/FIFO_coverage/cg
#quit -sim
vcover report fiforpt.ucdb -details -annotate -all -output fiforpt.txt
