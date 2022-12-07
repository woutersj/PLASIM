set(PLASIM_BIN0 plasim)

#
# Set build options
#

option(WITH_GUI "Include the GUI" OFF)
message(STATUS "GUI compilation='${WITH_GUI}'")

option(WITH_COUPLER "Include the coupler" OFF)
message(STATUS "coupler compilation='${WITH_COUPLER}'")

option(WITH_LSG "LSG Ocean" OFF)
message(STATUS "LSG ocean='${WITH_LSG}'")

set(planet "earth" CACHE STRING "Planet configuration")
set_property(CACHE planet PROPERTY STRINGS earth mars exo)
message(STATUS "Planet='${planet}'")

# 32 64
set(nlats 32 64 CACHE STRING "number of atmospheric latitudes")
# Allowed values
# set_property(CACHE nlats PROPERTY STRINGS 16 24 32 48 64 96 128 160 192 256 512 1024 2048)
message(STATUS "number of latitudes='${nlats}'")

# 10 20
set(nlevs 10 20 CACHE STRING "number of atmospheric levels")
message(STATUS "number of levels='${nlevs}'")

# 4 8
set(npros 1 4 CACHE STRING "number of processors")
message(STATUS "number of processors='${npros}'")

#
# MPI
#

find_package(MPI REQUIRED)
include_directories(${MPI_Fortran_INCLUDE_PATH})

#
# build flags
#

set (CMAKE_Fortran_FLAGS_RELEASE "-cpp -funroll-all-loops -fno-f2c -O3 -std=legacy")
set (CMAKE_Fortran_FLAGS "-cpp -funroll-all-loops -fno-f2c -O3 -std=legacy")
set (CMAKE_Fortran_FLAGS_DEBUG   "-fno-f2c -O0 -g")

#
# Select source files
#

set(PLASIM_F_SRCS plasimmod.f90 icemod.f90 oceanmod.f90 resmod_stub.f90 mpimod.f90
                    tracermod.f90 surfmod.f90 rainmod.f90 outmod.f90
                    radmod.f90 legmod.f90 landmod.f90
                    calmod.f90  fftmod.f90 p_${planet}.f90
                    fluxmod.f90 miscmod.f90 restartmod.f90 tpcore.f90 gaussmod.f90 
                    seamod.f90 simba.f90 trc_routines.f90)

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

list(TRANSFORM PLASIM_F_SRCS PREPEND plasim/)
list(TRANSFORM PLASIM_C_SRCS PREPEND plasim/)

if(WITH_LSG)
    list(APPEND PLASIM_F_SRCS lsg/lsgmod.f90)
    set(PLASIM_BIN0 ${PLASIM_BIN0}-lsg)
else()
    list(APPEND PLASIM_F_SRCS plasim/lsgmod_stub.f90)
endif() 

#
# Create the build targets
#

foreach(nlat ${nlats})
foreach(nlev ${nlevs})
foreach(npro ${npros})
    # ntru = floor( (2*nlat-1) / 3 ), floor is performed automatically upon conversion to int
    math(EXPR ntru "(2*${nlat} - 1)/3")
    # message(STATUS "spectral truncation='${ntru}'")

    # Set a directory to store resolution specific Fortran modules. We are building many copies with the same name, but different resolutions. Otherwise their modules clash in a parellel make (e.g. -j4).
    set( CMAKE_Fortran_MODULE_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/Mod_t${ntru}_l${nlev}_p${npro} )
    
    set(PLASIM_BIN ${PLASIM_BIN0}_t${ntru}_l${nlev}_p${npro})
    message(STATUS "PLASIM_BIN='${PLASIM_BIN}'")
    
    add_executable(${PLASIM_BIN} plasim/plasim.f90 ${PLASIM_C_SRCS} ${PLASIM_F_SRCS})

    target_compile_definitions(${PLASIM_BIN} PUBLIC NLAT_ATM=${nlat})
    target_compile_definitions(${PLASIM_BIN} PUBLIC NLEV_ATM=${nlev})
    target_compile_definitions(${PLASIM_BIN} PUBLIC NPRO_ATM=${npro})

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

    # install binary
    INSTALL(TARGETS ${PLASIM_BIN} DESTINATION bin)
endforeach()
endforeach()
endforeach()