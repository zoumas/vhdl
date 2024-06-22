# Learning VHDL

Resources for learning Digital Design and Hardware Description.

## VHDL on Linux

Using [GHDL](http://ghdl.free.fr/site/pmwiki.php)

Installation:
`$ sudo apt-get install ghdl gtkwave`

Usage:

Analyze the design: `ghdl -a adder_tb.vhdl`

Build an executable for the testbench:
`ghdl -e adder_tb` (name of the entity defined in the file)

Run:
`ghdl -r adder_tb`

Export to wave viewer:
`ghdl -r adder_tb --vcd=adder.vcd`

Run wave viewer:
`gtkwave adder.vcd`
