# Note that this script can accept some limited command-line arguments, run
# `julia build_tarballs.jl --help` to see a usage message.
using BinaryBuilder, Pkg

name = "PlaSim"
version = v"0.1.0"

# Collection of sources required to complete build
sources = [
    GitSource("https://github.com/woutersj/PLASIM.git", "d28d3b09d12bd14ea24fdfa027e70ffa5c0ef858"),
    ArchiveSource("https://github.com/Unidata/netcdf-cxx4/archive/refs/tags/v4.3.1.tar.gz", "e3fe3d2ec06c1c2772555bf1208d220aab5fee186d04bd265219b0bc7a978edc")
]

# Bash recipe for building across all platforms
script = raw"""
cd $WORKSPACE/srcdir
cd netcdf-cxx4-4.3.1/
./configure --prefix=${prefix} --build=${MACHTYPE} --host=${target}
make -j${nproc}
make install
cd ..
cd PLASIM/
mkdir build
cd build/
cmake -DCMAKE_INSTALL_PREFIX=$prefix -DCMAKE_TOOLCHAIN_FILE=${CMAKE_TARGET_TOOLCHAIN} -DCMAKE_BUILD_TYPE=Release ..
make -j${nproc}
make install
cd ..
exit
"""

# These are the platforms we will build for by default, unless further
# platforms are passed in on the command line
platforms = [
    Platform("x86_64", "linux"; libc = "glibc"),
    Platform("aarch64", "linux"; libc = "glibc")
]


# The products that we will ensure are always built
products = [
    ExecutableProduct("plasim_t21_l20_p4", :plasim_t21_l20_p4),
    ExecutableProduct("plasim_t21_l20_p1", :plasim_t21_l20_p1),
    ExecutableProduct("plasim_t42_l10_p1", :plasim_t42_l10_p1),
    ExecutableProduct("plasim_t42_l10_p4", :plasim_t42_l10_p4),
    ExecutableProduct("plasim_t21_l10_p1", :plasim_t21_l10_p1),
    ExecutableProduct("plasim_t42_l20_p4", :plasim_t42_l20_p4),
    ExecutableProduct("plasim_t42_l20_p1", :plasim_t42_l20_p1),
    ExecutableProduct("plasim_t21_l10_p4", :plasim_t21_l10_p4),
    ExecutableProduct("burn8", :burn8)
]

# Dependencies that must be installed before this package can be built
dependencies = [
    Dependency(PackageSpec(name="OpenMPI_jll", uuid="fe0851c0-eecd-5654-98d4-656369965a5c"))
    Dependency(PackageSpec(name="NetCDF_jll", uuid="7243133f-43d8-5620-bbf4-c2c921802cf3"))
]

# Build the tarballs, and possibly a `build.jl` as well.
build_tarballs(ARGS, name, version, sources, script, platforms, products, dependencies; julia_compat="1.6", preferred_gcc_version = v"5.2.0")