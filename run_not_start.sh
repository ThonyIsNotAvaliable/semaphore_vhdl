ghdl -a --std=08 --workdir=work src/d_latch.vhd src/d_flipflop.vhd src/contador.vhd src/traffic_controller.vhd tb/tb_not_start.vhd
ghdl -e --std=08 --workdir=work tb_not_start
ghdl -r --std=08 --workdir=work tb_not_start --vcd=ondas.vcd
gtkwave ondas.vcd
