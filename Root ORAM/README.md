# DP ORAM Simulation

We add the top varI levels to the stash and then perform PathORAM
over the rest. Epsilon changes the mapping to a non-uniform one. 

The code can be compiled by compiling `test_path_oram.cpp`
To compile run:


```
g++ -std=c++11 -O3 -o oram test_path_oram.cpp
```

The code can then be run using
```
./oram LOG_N BUCKET_SIZE I_VALUE EPSILON
```

The code will perform the max{N, 2^15} accesses as warmup where
data will be inserted into the tree using an intial random mapping.
Then it will keep running linear accesses (1,2,...,N) till the
program is quit and output the stash size histogram in an 
appropriately named file in the folder res. The statistics are:

* I_Value 
* Epsilon 
* Mean Stash Usage
* Max Stash Usage