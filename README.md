# Synchronous FIFO Design Using Verilog HDL

A small synchronous first-in, first-out (FIFO) buffer implemented in Verilog HDL, with a testbench and simulation artifacts.

## Design specifications

- Data width: 8 bits
- Capacity: 8 entries
- Clock: Single clock
- Reset: Synchronous, active-high
- Status outputs: `full` and `empty`

## Files

- `sync_fifo.v` - FIFO RTL implementation with read/write pointers and occupancy tracking.
- `tb_sync_fifo.v` - Testbench for reset behavior and FIFO ordering.
- `hello.v` - Minimal simulator smoke test.
- `fifo.vcd` - Captured waveform from the FIFO testbench run; regenerate it by rerunning the testbench.
- `fifo_sim` - Prebuilt simulation executable. It may not run on every operating system; rebuild it with the commands below.
- `README.md` - Project overview and simulation instructions.

## Run the FIFO testbench

Install Icarus Verilog, then run from the project directory:

```sh
iverilog -g2012 -s tb_sync_fifo -o fifo_sim sync_fifo.v tb_sync_fifo.v
vvp fifo_sim
```

The testbench writes three values (10, 20, and 30), reads them back in order, checks reset/empty behavior, and writes a waveform to `fifo.vcd`. Open the waveform with GTKWave if desired:

```sh
gtkwave fifo.vcd
```

## Run the simulator smoke test

```sh
iverilog -g2012 -s hello -o hello_sim hello.v
vvp hello_sim
```
