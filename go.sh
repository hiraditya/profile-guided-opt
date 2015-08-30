#!/bin/bash -xe
#mkdir build
#cd build
SRC_DIR=..
SRC_NAME=test.cpp
SRC=$SRC_DIR/$SRC_NAME

echo "Test instrumented program"
g++ -O3 -march=native -mtune=native -fprofile-arcs -ftest-coverage -o test.instr $SRC
perf stat ./test.instr 32 3 

# gcov needs source file in the same directory as the profile (by default).
cp $SRC .
gcov $SRC_NAME
rm $SRC_NAME

echo "Test profile opt program"
g++ -O3 -march=native -mtune=native -fprofile-use -o test.prof.opt $SRC
perf stat ./test.prof.opt 32 3 

echo "Test optmized program"
g++ -O3 -march=native -mtune=native -o test.opt $SRC
perf stat ./test.opt 32 3 


generate_gprof_data () {
    g++ -O3 -march=native -mtune=native -pg -fprofile-generate -o test.instr $SRC
    perf stat ./test.instr 32 3
}

# This is meant to run from the build directory.
clean() {
    rm *
}
