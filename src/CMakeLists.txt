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

option(WITH_MPI "use MPI" ON)
message(STATUS "use MPI='${WITH_MPI}'")

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
if(WITH_MPI)
	set(npros 1 4 CACHE STRING "number of processors")
else()
	message(STATUS "MPI disabled: using 1 processor")
	set(npros 1  CACHE STRING "number of processors")
endif()

message(STATUS "number of processors='${npros}'")

#
# MPI
#

if(WITH_MPI)
  find_package(MPI REQUIRED COMPONENTS Fortran)
  include_directories(${MPI_Fortran_INCLUDE_DIRS})
endif()
#
# build flags
#

set (CMAKE_Fortran_FLAGS_RELEASE "-cpp -funroll-all-loops -fno-f2c -O3 -std=legacy")
set (CMAKE_Fortran_FLAGS "-cpp -funroll-all-loops -fno-f2c -O3 -std=legacy")
set (CMAKE_Fortran_FLAGS_DEBUG   "-fno-f2c -O0 -g")

#
# Select source files
#

set(PLASIM_F_SRCS plasimmod.f90 icemod.f90 oceanmod.f90 resmod_stub.f90
                    tracermod.f90 surfmod.f90 rainmod.f90 outmod.f90
                    radmod.f90 legmod.f90 landmod.f90
                    calmod.f90  fftmod.f90 p_${planet}.f90
                    fluxmod.f90 miscmod.f90 restartmod.f90 tpcore.f90 gaussmod.f90
                    seamod.f90 simba.f90 trc_routines.f90)

if(WITH_MPI)
  list(APPEND PLASIM_F_SRCS mpimod.f90)
else()
  list(APPEND PLASIM_F_SRCS mpimod_stub.f90)
endif()

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

    # Add test that runs PLASIM for 5 days
    add_test(NAME ${PLASIM_BIN}_5day_test
    COMMAND ${MPIEXEC_EXECUTABLE} -n ${npro} ../${PLASIM_BIN} -plasim_output test_5day_${nlat}_${nlev}_${npro}
        WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/test_run)

    # Set test properties
    set_tests_properties(${PLASIM_BIN}_5day_test
        PROPERTIES
        TIMEOUT 300
        LABELS "plasim;integration")
endforeach()
endforeach()
endforeach()

# Create a test directory if it doesn't exist
file(MAKE_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/test_run)

# Create a simple namelist file for 5-day test run
set(PLASIM_NAMELIST_CONTENT "
 &plasim_nl
   n_run_days = 5,
   n_run_steps = 0,
   n_run_months = 0,
   n_run_years = 0,
 /
")
file(WRITE ${CMAKE_CURRENT_BINARY_DIR}/test_run/plasim_namelist " ${PLASIM_NAMELIST_CONTENT}")

# Create miscmod_namelist file
set(MISC_NAMELIST_CONTENT "
 &miscmod_nl
 /
")
file(WRITE ${CMAKE_CURRENT_BINARY_DIR}/test_run/miscmod_namelist " ${MISC_NAMELIST_CONTENT}")

# Create fluxmod_namelist file
set(FLUX_NAMELIST_CONTENT "
 &fluxmod_nl
 /
")
file(WRITE ${CMAKE_CURRENT_BINARY_DIR}/test_run/fluxmod_namelist " ${FLUX_NAMELIST_CONTENT}")

# Create icemod_namelist file
set(ICE_NAMELIST_CONTENT "
 &icemod_nl
 /
")
file(WRITE ${CMAKE_CURRENT_BINARY_DIR}/test_run/icemod_namelist " ${ICE_NAMELIST_CONTENT}")

# Create landmod_namelist file
set(LAND_NAMELIST_CONTENT "
 &landmod_nl
 /
")
file(WRITE ${CMAKE_CURRENT_BINARY_DIR}/test_run/landmod_namelist " ${LAND_NAMELIST_CONTENT}")

# Create planet_namelist file
set(PLANET_NAMELIST_CONTENT "
 &planet_nl
 /
")
file(WRITE ${CMAKE_CURRENT_BINARY_DIR}/test_run/planet_namelist " ${PLANET_NAMELIST_CONTENT}")

# Create radmod_namelist file
set(RAD_NAMELIST_CONTENT "
 &radmod_nl
 /
")
file(WRITE ${CMAKE_CURRENT_BINARY_DIR}/test_run/radmod_namelist " ${RAD_NAMELIST_CONTENT}")

# Create rainmod_namelist file
set(RAIN_NAMELIST_CONTENT "
 &rainmod_nl
 /
")
file(WRITE ${CMAKE_CURRENT_BINARY_DIR}/test_run/rainmod_namelist " ${RAIN_NAMELIST_CONTENT}")

# Create seamod_namelist file
set(SEA_NAMELIST_CONTENT "
 &seamod_nl
 /
")
file(WRITE ${CMAKE_CURRENT_BINARY_DIR}/test_run/seamod_namelist " ${SEA_NAMELIST_CONTENT}")

# Create surfmod_namelist file
set(SURF_NAMELIST_CONTENT "
 &surfmod_nl
 /
")
file(WRITE ${CMAKE_CURRENT_BINARY_DIR}/test_run/surfmod_namelist " ${SURF_NAMELIST_CONTENT}")

# Create vegmod_namelist file
set(VEG_NAMELIST_CONTENT "
 &vegmod_nl
 /
")
file(WRITE ${CMAKE_CURRENT_BINARY_DIR}/test_run/vegmod_namelist " ${VEG_NAMELIST_CONTENT}")
