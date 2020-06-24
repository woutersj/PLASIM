#!/bin/bash
INSTALLDIR=$HOME/.local/
mkdir build
cd build
NLAT=64
NLEV=10
NPRO=2
cmake -Dnlat=${NLAT} -Dnlev=${NLEV} -Dnpro=${NPRO} -DCMAKE_INSTALL_PREFIX=${INSTALLDIR} .. && make && make install		
