vlib work 

vcom -93 ../src/telemetre_us.vhd
vcom -93 tb_telemetre_us.vhd
vsim tb_telemetre_us
add wave *
run -all