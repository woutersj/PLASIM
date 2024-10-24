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

Further options can be enabled/disabled:
- `WITH_GUI` (to display a diagnostic GUI while running, default `OFF`),
- `WITH_LSG`, `WITH_COUPLER` (compile and couple the LSG ocean model, default `OFF`),
- `WITH_MPI` (enable MPI for multiprocessor runs, default `ON`).

Further settings can be set using these variables:
- `nlats` (number of latitudes, default `32 64`)
- `nlevs` (number of vertical levels, default `10 20`)
- `npros` (number of processors, default `1 4`, `1` if MPI is not enabled.).

These variables can be lists of multiple values, in which case a binary for each possible combination will be compiled.

For example, instead of `cmake ..` in the above, one can do
```
cmake -Dnlats=32 -Dnlevs=10 -DWITH_MPI=OFF ..
```
to compile a single binary.
