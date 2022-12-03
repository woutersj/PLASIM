cmake_minimum_required(VERSION 2.8)
project(PLASIM C CXX Fortran)

set (CMAKE_MODULE_PATH ${PLASIM_SOURCE_DIR}/cmake)

add_subdirectory (plasim/src)
add_subdirectory (postprocessor)