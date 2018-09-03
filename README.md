## Root-ORAM

This repository contains the simulation code used in [Differentially Private Oblivious RAM](https://www.petsymposium.org/2018/files/papers/issue4/popets-2018-0032.pdf). Part of the code is built on the [Path ORAM codebase](https://github.com/wangxiao1254/oram_simulator).

## Usage

### New
The code can be compiled by compiling `test_path_oram.cpp`  
To compile run: `g++ -std=c++11 -O3 -o oram test_path_oram.cpp`  
The code can then be run using: `./oram LOG_N BUCKET_SIZE I_VALUE EPSILON`  
For end to end run, use: `./script.sh`  

### DP Defense
Simply run the `plots.m` file using Matlab.  

### EC2
Navigate to appropriate folder and compile `sample.c` using: `gcc -o sample sample.c`  
Then run the `loop_client.sh` and `loop_server.sh` on appropriate amazon machines (with open network security group).  

### Old
Compile using: `g++ finished_product.cpp`  
Set appropriate for loops in `script.sh` and then run using: `./script.sh`  

## Other references
* [Path ORAM](https://eprint.iacr.org/2013/280.pdf)
