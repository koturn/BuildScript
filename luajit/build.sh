#!/bin/sh -eu

make CCOPT='-Ofast -march=native -flto -fomit-frame-pointer -DNDEBUG'
