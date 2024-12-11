vlib work 
vcom -93 ../src/telemetre_us_avalon.vhd
vcom -93 tb_telemetre_us_avalon.vhd
vsim tb_telemetre_us_avalon
add wave *
run -all