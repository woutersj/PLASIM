# Note that this script can accept some limited command-line arguments, run
# `julia build_tarballs.jl --help` to see a usage message.
using BinaryBuilder, Pkg

name = "PlaSim"
version = v"0.1.0"

# Collection of sources required to complete build
sources = [
    GitSource("https://github.com/woutersj/PLASIM.git", "9f767d8b6e7f4b4008dfd3f3376a07bfe6147fcd")
]

# Bash recipe for building across all platforms
script = raw"""
cd $WORKSPACE/srcdir/PLASIM/
mkdir build
cd build/
cmake -DWITH_MPI=OFF -DCMAKE_INSTALL_PREFIX=$prefix -DCMAKE_TOOLCHAIN_FILE=${CMAKE_TARGET_TOOLCHAIN} -DCMAKE_BUILD_TYPE=Release ..
make -j${nproc}
make install
"""

# These are the platforms we will build for by default, unless further
# platforms are passed in on the command line
# Set equal to the supported platforms in HDF5
platforms = [
    Platform("x86_64", "linux"; libc = "glibc"),
    # HDF5_jll on armv7l should use the same glibc as the root filesystem
    # before it can be used
    # https://github.com/JuliaPackaging/Yggdrasil/pull/1090#discussion_r432683488
    # Platform("armv7l", "linux"; libc="glibc"),
    #Platform("aarch64", "linux"; libc="glibc"),
    #Platform("x86_64", "macos"),
    #Platform("aarch64","macos"),
    #Platform("x86_64", "windows"),
    #Platform("i686", "windows"),
]
platforms = expand_gfortran_versions(platforms)

# The products that we will ensure are always built
products = [
    ExecutableProduct("plasim_t21_l10_p1", :plasim_t21_l10_p1),
    ExecutableProduct("plasim_t21_l20_p1", :plasim_t21_l20_p1),
    ExecutableProduct("plasim_t42_l10_p1", :plasim_t42_l10_p1),
    ExecutableProduct("plasim_t42_l20_p1", :plasim_t42_l20_p1),
    #ExecutableProduct("plasim_t21_l10_p4", :plasim_t21_l10_p4),
    #ExecutableProduct("plasim_t21_l20_p4", :plasim_t21_l20_p4),
    #ExecutableProduct("plasim_t42_l10_p4", :plasim_t42_l10_p4),
    #ExecutableProduct("plasim_t42_l20_p4", :plasim_t42_l20_p4)
]

# Dependencies that must be installed before this package can be built
dependencies = [
    #Dependency(PackageSpec(name="OpenMPI_jll", uuid="fe0851c0-eecd-5654-98d4-656369965a5c"))
    #Dependency(PackageSpec(name="MPICH_jll", uuid="7cb0a576-ebde-5e09-9194-50597f1243b4"))
    #Dependency(PackageSpec(name="NetCDF_jll", uuid="7243133f-43d8-5620-bbf4-c2c921802cf3"))
    #Dependency(PackageSpec(;name="NetCDFCXX_jll", uuid="4504df56-95e4-5f68-9397-6f265f6c54a6",
    #                       url="https://github.com/woutersj/NetCDFCXX_jll.jl.git"))
    Dependency(PackageSpec(name="CompilerSupportLibraries_jll", uuid="e66e0078-7015-5450-92f7-15fbd957f2ae"))
]

# Build the tarballs, and possibly a `build.jl` as well.
#build_tarballs(ARGS, name, version, sources, script, platforms, products, dependencies; julia_compat="1.6", preferred_gcc_version = v"5")
build_tarballs(ARGS, name, version, sources, script, platforms, products, dependencies;)
# need to specify the compiler version to be the same as the one used for OpenMPI_jll, otherwise it complains about `mpi.mod` not being a "GNU Fortran module file"
