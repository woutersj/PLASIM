#set (NETCDF_CXX "YES")
#set (NETCDF_FIND_COMPONENTS "CXX")
#find_package (NetCDF REQUIRED)

option(WITH_BURNER "Build the postprocessor" OFF)
message(STATUS "postprocessor compilation='${WITH_BURNER}'")

if(WITH_BURNER)
    set(BURNER_BIN burn8)
    find_package(PkgConfig REQUIRED)
    pkg_check_modules(NETCDF_CXX REQUIRED netcdf-cxx4)

    add_executable(${BURNER_BIN} burn8.cpp)

    target_link_libraries (${BURNER_BIN} ${NETCDF_CXX_LIBRARIES})

    INSTALL(TARGETS ${BURNER_BIN} DESTINATION bin)
endif()
