vlib work
vcom -93 ../src/servomoteur_avalon.vhd
vcom -93 tb_servomoteur_avalon.vhd
vsim tb_servomoteur_avalon
add wave -radix unsigned *
run -all
