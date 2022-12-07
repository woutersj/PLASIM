cmake_minimum_required(VERSION 3.0)
project(PLASIM C CXX Fortran)

set (CMAKE_MODULE_PATH ${PLASIM_SOURCE_DIR}/cmake)

add_subdirectory (src)
add_subdirectory (postprocessor)

# install data
INSTALL(DIRECTORY dat/ DESTINATION share/plasim)

# install scripts
INSTALL(PROGRAMS scripts/srv2nc DESTINATION bin)

#SET(CPACK_GENERATOR "DEB" "RPM")
#SET(CPACK_DEBIAN_PACKAGE_MAINTAINER "Jeroen Wouters") #required
 
#INCLUDE(CPack)