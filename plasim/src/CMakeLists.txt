cmake_minimum_required(VERSION 2.8)
project(PLASIM C Fortran)

option(WITH_GUI "Include the GUI" OFF)

find_package(MPI REQUIRED)
include_directories(${MPI_Fortran_INCLUDE_PATH})

if(WITH_GUI)
    find_package(X11 REQUIRED)
    add_compile_definitions(USE_GUI)
    include_directories(${X11_INCLUDE_PATH})
endif()

set (CMAKE_Fortran_FLAGS_RELEASE "-cpp -funroll-all-loops -fno-f2c -O3")
set (CMAKE_Fortran_FLAGS "-cpp -funroll-all-loops -fno-f2c -O3")
set (CMAKE_Fortran_FLAGS_DEBUG   "-fno-f2c -O0 -g")

set(PLASIM_F_SRCS plasimmod.f90 calmod.f90     fftmod.f90  guimod.f90  guimod_stub.f90  lsgmod.f90    p_earth.f90    rainmod.f90          resmod.f90     surfmod.f90 cpl_stub.f90        fluxmod.f90   icemod.f90       miscmod.f90       oceanmod.f90       restartmod.f90  tpcore.f90  gaussmod.f90  landmod.f90      mpimod.f90        radmod.f90            seamod.f90      tracermod.f90   guimod_stub.f90    legmod.f90      outmod.f90       plasim.f90       simba.f90       trc_routines.f90)

set(PLASIM_C_SRCS pumax.c pumax_stub.c)
add_executable(plasim ${PLASIM_C_SRCS} ${PLASIM_F_SRCS})

if(WITH_GUI)
    target_link_libraries(plasim ${MPI_Fortran_LIBRARIES} ${X11_LIBRARIES})
else()
    target_link_libraries(plasim ${MPI_Fortran_LIBRARIES})
endif()

if(MPI_COMPILE_FLAGS)
  set_target_properties(plasim PROPERTIES
    COMPILE_FLAGS "${MPI_Fortran_COMPILE_FLAGS}")
endif()

if(MPI_LINK_FLAGS)
  set_target_properties(plasim PROPERTIES
    LINK_FLAGS "${MPI_Fortran_LINK_FLAGS}")
endif() 

# installation
INSTALL(TARGETS plasim DESTINATION plasim)

#SET(CPACK_GENERATOR "DEB" "RPM")
#SET(CPACK_DEBIAN_PACKAGE_MAINTAINER "Jeroen Wouters") #required
 
#INCLUDE(CPack)
