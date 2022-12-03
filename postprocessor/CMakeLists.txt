set (NETCDF_CXX "YES")
find_package (NetCDF REQUIRED)

add_executable(burn7 burn7.cpp)

target_link_libraries (burn7 ${NETCDF_LIBRARIES_CXX})

INSTALL(TARGETS burn7 DESTINATION bin)