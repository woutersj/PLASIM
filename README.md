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

## Dependencies

On Fedora, install `openmpi-devel` for MPI and load it with `module load mpi`. For the postprocessor install `netcdf-cxx4-devel`

On Debian, install `openmpi-bin` and `libopenmpi-dev` for MPI. For the postprocessor install `libnetcdf-c++4-devel`.

## Usage

Run the plasim command of the desired resolution and parallelism (for example, plasim_t21_l10_p1) from a directory containing the namelists for the model run. The namelists contain the configuration settings for the model. Required namelist files are:
  - plasim_namelist
  - miscmod_namelist
  - fluxmod_namelist
  - rainmod_namelist
  - vegmod_namelist
  - landmod_namelist
  - radmod_namelist
  - surfmod_namelist

These are sample contents for the plasim_namelist:
```
  &plasim_nl
   n_run_days = 5,
   n_run_steps = 0,
   n_run_months = 0,
   n_run_years = 0,
 /
```
Namelists are required, but can be practically empty, for example `rainmod_namelist` can contain `&rainmod_nl /`.

The output file is called `plasim_output` by default and can be specified with the command line argument `-output _filename_`. It can be converted into NetCDF using the `srv2nc` scipt or the postprocessor `burn8`.
