PLASIM
======

Gerneral Circulation Models Planet Simulator (PlaSim) and PUMA. These models are research models of intermediate complexity used in Meteorology and Earth Sciences.

## Documentation
Manuals are located in:

- [puma/doc](./puma/doc) for the PUMA model
- [plasim/doc](./plasim/doc) for the Planet Simulator

## Installation ##
To build PlaSim using CMake:

```
mkdir build && cd build
cmake ..
make -j4
make install
```

The installation directory can be specified by adding the argument `-DCMAKE_INSTALL_PREFIX=...` to `cmake`.
Further options can be enabled/disabled with `WITH_GUI` (to display a diagnostic GUI while running), `WITH_LSG`, `WITH_COUPLER` (compile and couple the LSG ocean modeal), `WITH_MPI` (enable MPI for multiprocessor runs). The variables `nlats`, `nlevs`, and `npros` configure the number of latitudes, levels and processors to compile for. These variables can be lists of multiple variables, in which case a binary for each possible combination will be compiled.
