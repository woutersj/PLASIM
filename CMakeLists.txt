cmake_minimum_required(VERSION 3.10)
project(PLASIM C CXX Fortran)
cmake_policy(SET CMP0074 NEW)

set (CMAKE_MODULE_PATH ${PLASIM_SOURCE_DIR}/cmake)

include (CTest)
enable_testing ()

add_subdirectory (src)
add_subdirectory (postprocessor)

# install data
INSTALL(DIRECTORY dat/ DESTINATION share/plasim)

# install scripts
INSTALL(PROGRAMS scripts/srv2nc DESTINATION bin)

#SET(CPACK_GENERATOR "DEB" "RPM")
#SET(CPACK_DEBIAN_PACKAGE_MAINTAINER "Jeroen Wouters") #required

#INCLUDE(CPack)
