vlib work 
vcom -93 genere10us.vhd
vcom -93 tb_10us.vhd
vsim tb_10us
add wave *
add wave sim:/tb_10us/ins/counter
run -all


