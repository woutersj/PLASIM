#!/bin/bash
INSTALLDIR=$HOME/.local/
mkdir build
cd build
for NLAT in 32 64
do
  for NLEV in 10 20
  do
    for NPRO in 2 4
    do
      cmake -Dnlat=${NLAT} -Dnlev=${NLEV} -Dnpro=${NPRO} -DCMAKE_INSTALL_PREFIX=${INSTALLDIR} .. && make && make install		
    done
  done
done
