vlib work
vcom -93 mesure_echo.vhd
vcom -93 tb_mesure_echo.vhd
vsim tb_mesure_echo

add wave *
run -all