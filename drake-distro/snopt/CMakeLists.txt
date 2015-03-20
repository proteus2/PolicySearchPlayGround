cmake_minimum_required(VERSION 2.6.0)   
# for "optimum Fortran support" http://www.cmake.org/Wiki/CMake_Fortran_Issues 

option(BUILD_SHARED_LIBS "build-shared-libraries" OFF)
#if (APPLE)
  option(USE_SYSTEM_F2C "use-system-f2c" OFF)
#else()
#  option(USE_SYSTEM_F2C "use-system-f2c" ON)
#endif()

enable_language (Fortran)

# set up pods
set(POD_NAME snopt)
include(cmake/pods.cmake)

# set up matlab build
include(cmake/mex.cmake)

if (NOT MSVC)
   add_definitions("-fPIC")
endif()

enable_testing()

if (USE_SYSTEM_F2C)
  message(STATUS "using system f2c")
  find_path(F2C_INCLUDE_DIR NAMES f2c.h)
  find_library(F2C_LIBRARY NAMES libf2c.a)  # was f2c, but link statically to help cmex on ubuntu
  if ((NOT F2C_INCLUDE_DIR) OR (NOT F2C_LIBRARY))
    message(FATAL_ERROR "f2c not found.  please install libf2c from your package manager")
  endif()

  set(F2C_LIBRARY_FLAG ${F2C_LIBRARY})
else()
   message(STATUS "using snopt f2c")
   add_subdirectory(libf2c)
   include_directories(libf2c)
   set(F2C_LIBRARY f2c)
   set(F2C_LIBRARY_FLAG -lf2c)
endif()

if (NOT MSVC)
  # this should build fine on windows, but it was not being forced to build (and then failing on install).  Since it's not being used, simply disable it for now
  add_subdirectory(src)
  add_subdirectory(examples)
endif()
add_subdirectory(csrc)   
add_subdirectory(cexamples)
add_subdirectory(cppsrc) 
add_subdirectory(cppexamples)
add_subdirectory(cmex)

message(STATUS "Writing addpath_snopt.m and rmpath_snopt.m to ${CMAKE_INSTALL_PREFIX}/matlab") 
file(WRITE ${CMAKE_INSTALL_PREFIX}/matlab/addpath_snopt.m
	   "function addpath_snopt()\n"
	   "  addpath(fullfile('${CMAKE_SOURCE_DIR}','matlab'));\n"
    )

file(WRITE ${CMAKE_INSTALL_PREFIX}/matlab/rmpath_snopt.m
	   "function rmpath_snopt()\n"
	   "  rmpath(fullfile('${CMAKE_SOURCE_DIR}','matlab'));\n"
    )
