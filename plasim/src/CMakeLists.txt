cmake_minimum_required(VERSION 2.8)
project(PLASIM C Fortran)

option(WITH_GUI "Include the GUI" OFF)
message(STATUS "GUI compilation='${WITH_GUI}'")

option(WITH_COUPLER "Include the coupler" OFF)
message(STATUS "coupler compilation='${WITH_COUPLER}'")

set(planet "earth" CACHE STRING "Planet configuration")
set_property(CACHE planet PROPERTY STRINGS earth mars exo)
message(STATUS "Planet='${planet}'")

set(nlat 64 CACHE STRING "number of atmospheric latitudes")
set_property(CACHE nlat PROPERTY STRINGS 16 24 32 48 64 96 128 160 192 256 512 1024 2048)
message(STATUS "number of latitudes='${nlat}'")
# ntru = floor( (2*nlat-1) / 3 ), floor is performed automatically upon conversion to int
math(EXPR ntru "(2*${nlat} - 1)/3")
message(STATUS "spectral truncation='${ntru}'")

set(nlev 10 CACHE STRING "number of atmospheric levels")
message(STATUS "number of levels='${nlev}'")

set(npro 2 CACHE STRING "number of processors")
message(STATUS "number of processors='${npro}'")

find_package(MPI REQUIRED)
include_directories(${MPI_Fortran_INCLUDE_PATH})

add_compile_definitions(NLAT_ATM=${nlat})
add_compile_definitions(NLEV_ATM=${nlev})
add_compile_definitions(NPRO_ATM=${npro})

set (CMAKE_Fortran_FLAGS_RELEASE "-cpp -funroll-all-loops -fno-f2c -O3")
set (CMAKE_Fortran_FLAGS "-cpp -funroll-all-loops -fno-f2c -O3")
set (CMAKE_Fortran_FLAGS_DEBUG   "-fno-f2c -O0 -g")

set(PLASIM_F_SRCS  plasimmod.f90  calmod.f90  fftmod.f90  lsgmod.f90
                   p_${planet}.f90  rainmod.f90  surfmod.f90
                   fluxmod.f90  icemod.f90  miscmod.f90  oceanmod.f90
                   restartmod.f90  tpcore.f90  gaussmod.f90  landmod.f90
                   mpimod.f90  radmod.f90  seamod.f90  tracermod.f90
                   guimod_stub.f90  legmod.f90  outmod.f90  plasim.f90
                   simba.f90  trc_routines.f90)

if(WITH_COUPLER)
    list(APPEND PLASIM_F_SRCS cpl.f90)
else()
    list(APPEND PLASIM_F_SRCS cpl_stub.f90)
endif()

if(WITH_GUI)
    find_package(X11 REQUIRED)
    include_directories(${X11_INCLUDE_PATH})
    list(APPEND PLASIM_F_SRCS guimod.f90)
    set(PLASIM_C_SRCS pumax.c)
else()
    list(APPEND PLASIM_F_SRCS guimod_stub.f90)
    set(PLASIM_C_SRCS pumax_stub.c)
endif()

set(PLASIM_BIN plasim_t${ntru}_l${nlev}_p${npro})
add_executable(${PLASIM_BIN} ${PLASIM_C_SRCS} ${PLASIM_F_SRCS})

if(WITH_GUI)
    target_link_libraries(${PLASIM_BIN} ${MPI_Fortran_LIBRARIES} ${X11_LIBRARIES})
else()
    target_link_libraries(${PLASIM_BIN} ${MPI_Fortran_LIBRARIES})
endif()

if(MPI_COMPILE_FLAGS)
  set_target_properties(${PLASIM_BIN} PROPERTIES
    COMPILE_FLAGS "${MPI_Fortran_COMPILE_FLAGS}")
endif()

if(MPI_LINK_FLAGS)
  set_target_properties(${PLASIM_BIN} PROPERTIES
    LINK_FLAGS "${MPI_Fortran_LINK_FLAGS}")
endif() 

# installation
INSTALL(TARGETS ${PLASIM_BIN} DESTINATION bin)

#SET(CPACK_GENERATOR "DEB" "RPM")
#SET(CPACK_DEBIAN_PACKAGE_MAINTAINER "Jeroen Wouters") #required
 
#INCLUDE(CPack)
