# THIS REPOSITORY HAS BEEN ARCHIVED AND MOVED TO codeberg.org/woutersj/PlaSim


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

Run the PlaSim command of the desired resolution and parallelism (for example, `plasim_t21_l10_p1` for `T21` horizontal spectral resolution with 10 vertical levels on one processor). Binaries compiled with MPI need to be run on the correct number of processors, e.g. through `mpiexec -np 4 plasim_t21_l10_p4`.

Some settings (run length and filenames for data and settings) can be set from the command line. Most settings are set by running PlaSim from a directory containing Fortran namelist files containing the model settings. Possible namelist files are:
  - `plasim_namelist`
  - `miscmod_namelist`
  - `fluxmod_namelist`
  - `rainmod_namelist`
  - `vegmod_namelist`
  - `landmod_namelist`
  - `radmod_namelist`
  - `surfmod_namelist`

Variables inside a namelist are specified by a sequence of `key=value` pairs in a group. Keys are case-insensitive. There must be at least one comma, space, tab or newline between variables. The namelist starts with `&<group name>` and ends with a single `/`. The namelist filename for module called `mymod` is `mymod_namelist`, containing a group name `mymod_nl`. For example, `plasim_namelist` could contain the following:
```
  &plasim_nl
   n_run_days = 5,
   n_run_steps = 0,
   n_run_months = 0,
   n_run_years = 0,
 /
```
Model parameters can also be controlled in this way. For example, the atmospheric carbon dioxide concentration can be set in `radmod_namelist` as follows:
```
&radmod_nl CO2=400 /
```
Settings in namelists override corresponding command line settings.

The run length can be set to either a number of days (with the `-days` argument or `n_run_days` in `plasim_namelist`), or to a number of years and months (with `-months` and `-years`, or `n_run_years` and `n_run_years`). If `days` is set it will override `years` and `months` settings. For example, a run set with 50 days and 1 month will finish after 50 days.

The output file is called `plasim_output` by default and can be specified with the command line argument `-output _filename_`. It can be converted into NetCDF using the `srv2nc` scipt or the postprocessor `burn8`.

The complete state of the model will be written to `plasim_dump` at the end of the run. This filename can be specified with the `-dump` option. This state can later be used to re-initialise the model with the `-restart` option. This can be useful to occassionally save model states in long runs. If the run is interrupted for any reason it can later be restarted from the state dump file.
