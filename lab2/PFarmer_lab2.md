---
title: "Lab 1: Sequential Circuits and FSM"
author: "Patrick Farmer 20331828"
date: "2023-10-01"
---

![](https://www.tcd.ie/media/tcd/site-assets/images/tcd-logo.png)

\clearpage

## Introduction
The purpose of this lab is to design an advanced testbench for an existing design created in the previous lab. In this lab we used the Universal Verification Methodology (UVM) in System Verilog to create an advanced testbench.\
The testbench used a number of different blocks, the DUT, the stimulus generator and the scoreboard which will all be discussed more in later sections. The testbench designed is self-checking and reports the result of the checks in an automatically generated log file (HVM.log).

## Implementation Details
The first thing produced in this Lab was a TCL script that was able to run the testbench by creating a virtual temporary project adding the relevant files setting the top module and running the simulation until the testbench signals $finish. Then a bash (for linux) and batch (for windows) scripts were written as wrappers which renamed files that are to be saved and removed unwanted files from the project.\
Initially the stimulus_generator module was set as the top for development as this module generations the clock signals and the inputs to the DUT. Once this was working the top module was set as the top and the stimulus generator was instantiated inside it which worked as expected. Then the counter was also instantiated inside the top module and a simple scoreboard module written to check the outputs of the DUT.\
This scoreboard module printed when the testbench described logic expected an increase or decrease in the count, at this time the actual and expected signals for increment, decrement and count were compared and printed with a 'PASS' or 'FAIL' label. This uncovered a bug in the FSM written in the last lab. The design still worked but the signals did not match the testbench described signals. This was then fixed and some tests were run on the now working rtl and testbench with bug insertion which will be discussed in the next section.

## Design Approach
#### Role of Testbench Blocks
1. *Stimulus Generator*\
The first testbench block is the stimulus generator. The purpose of the stimulus generator is to generate clock signals and inputs to the DUT. The inputs generated are constrained random inputs. The sequence is of undetermined length and varies but has an expected output which triggers a check in the scoreboard when reached. There are 4 different tasks in the block. They generate the sequences for a successful entrance of a car, failed entrance of a car, successful exit of a car, failed exit of a car. Also checked is how the code handles an entrance of a car to a full car park and an exit of a car from an empty car park, which are both designed to cap and floor at 15 and 0 respectively.

#### Tested Scenarios
And their expected results.

#### Response to Bugs
Intentional and unintentional.
Rewrite of FSM.

#### Results

## Reflections