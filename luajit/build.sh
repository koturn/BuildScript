#!/bin/sh -eu

make -j4 CCOPT='-std=gnu11 -Ofast -mtune=native -march=native -funroll-loops -ffast-math -DNDEBUG' LDFLAGS='-s -Wl,-O1'
