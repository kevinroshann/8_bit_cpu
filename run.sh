#!/usr/bin/env bash

# Compilation step
echo " Compiling..."
iverilog -o sim/cpu.out tb/cpu_tb.v src/cpu_top.v src/register_file.v src/alu.v src/data_memory.v src/instruction_memory.v src/control_unit.v

# Check if compilation was successful
if [ $? -ne 0 ]; then
    echo " Compilation failed!"
    exit 1
fi

# Simulation step
echo " Running simulation..."
vvp sim/cpu.out
