PLASIM
======

Gerneral Circulation Models Planet Simulator (PlaSim) and PUMA. These models are research models of intermediate complexity used in Meteorology and Earth Sciences.

## Documentation
Manuals are located in:

- puma/doc for the PUMA model
- plasim/doc for the Planet Simulator

## Installation ##
To build PlaSim using CMake:

```
mkdir build && cd build
cmake ..
make -j4
make install
```

The installation directory can be specified by adding the argument `-DCMAKE_INSTALL_PREFIX=...` to `cmake`.