#!/bin/bash
mkdir build
cd build
cmake -Dnlat=64 -Dnlev=10 -Dnpro=4 -DCMAKE_INSTALL_PREFIX=/home/jeroen/.local/ .. && make && make install
