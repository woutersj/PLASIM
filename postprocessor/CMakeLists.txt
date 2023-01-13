#set (NETCDF_CXX "YES")
#set (NETCDF_FIND_COMPONENTS "CXX")
#find_package (NetCDF REQUIRED)

find_package(PkgConfig REQUIRED)
pkg_check_modules(NETCDF_CXX REQUIRED netcdf-cxx4)

add_executable(burn8 burn8.cpp)

target_link_libraries (burn8 ${NETCDF_CXX_LIBRARIES})

INSTALL(TARGETS burn8 DESTINATION bin)