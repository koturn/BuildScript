#!/bin/sh -eu

make linux MYCFLAGS='-s -Ofast -march=native -flto -DNDEBUG -U_FORTIFY_SOURCE'
