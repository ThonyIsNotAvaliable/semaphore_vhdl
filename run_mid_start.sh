ghdl -a --std=08 --workdir=work src/d_latch.vhd src/d_flipflop.vhd src/contador.vhd src/traffic_controller.vhd tb/tb_mid_start.vhd
ghdl -e --std=08 --workdir=work tb_mid_start
ghdl -r --std=08 --workdir=work tb_mid_start --vcd=ondas.vcd
gtkwave ondas.vcd
