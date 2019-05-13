transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vcom -93 -work work {C:/Users/Eduardo/Downloads/utfpr-8_periodo/logica_reconfiguravel/lab0805/ex2.vhd}
vcom -93 -work work {C:/Users/Eduardo/Downloads/utfpr-8_periodo/logica_reconfiguravel/lab0805/debounce.vhd}

