ghdl -a --std=08 --workdir=work src/d_latch.vhd src/d_flipflop.vhd src/contador.vhd src/traffic_controller.vhd tb/tb_reset_mid.vhd
ghdl -e --std=08 --workdir=work tb_reset_mid
ghdl -r --std=08 --workdir=work tb_reset_mid --vcd=ondas.vcd
gtkwave ondas.vcd
