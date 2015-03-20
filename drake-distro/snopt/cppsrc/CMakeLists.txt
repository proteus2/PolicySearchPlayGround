
include_directories( ${CMAKE_SOURCE_DIR}/csrc )

add_library(snopt_cpp snoptProblem.cc)
target_link_libraries(snopt_cpp snopt_c)

pods_install_headers(snoptProblem.hh DESTINATION snopt)

pods_install_libraries(snopt_cpp)

pods_install_pkg_config_file(snopt_cpp
    CFLAGS -I${CMAKE_INSTALL_PREFIX}/include/snopt
    LIBS -L${CMAKE_INSTALL_PREFIX}/lib -lsnopt_cpp
    REQUIRES snopt_c
    VERSION 0.0.1)
