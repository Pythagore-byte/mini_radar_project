vlib work
vcom -93 ../src/servomoteur.vhd
vcom -93 tb_servomoteur.vhd
vsim tb_servomoteur
add wave *
add wave -color red sim:/tb_servomoteur/commande
add wave -color yellow -radix unsigned sim:/tb_servomoteur/position
run -all