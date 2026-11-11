ghdl -a --std=08 --workdir=work src/d_latch.vhd src/d_flipflop.vhd src/contador.vhd src/traffic_controller.vhd tb/tb_semaphore.vhd
ghdl -e --std=08 --workdir=work tb_semaphore
ghdl -r --std=08 --workdir=work tb_semaphore --vcd=ondas.vcd
gtkwave ondas.vcd
