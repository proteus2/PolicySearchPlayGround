# Install script for directory: /home/beomjoon/Documents/Github/drake-distro/eigen/eigen-eigen-6b38706d90a9/unsupported/Eigen

# Set the install prefix
IF(NOT DEFINED CMAKE_INSTALL_PREFIX)
  SET(CMAKE_INSTALL_PREFIX "/home/beomjoon/Documents/Github/drake-distro/build")
ENDIF(NOT DEFINED CMAKE_INSTALL_PREFIX)
STRING(REGEX REPLACE "/$" "" CMAKE_INSTALL_PREFIX "${CMAKE_INSTALL_PREFIX}")

# Set the install configuration name.
IF(NOT DEFINED CMAKE_INSTALL_CONFIG_NAME)
  IF(BUILD_TYPE)
    STRING(REGEX REPLACE "^[^A-Za-z0-9_]+" ""
           CMAKE_INSTALL_CONFIG_NAME "${BUILD_TYPE}")
  ELSE(BUILD_TYPE)
    SET(CMAKE_INSTALL_CONFIG_NAME "Release")
  ENDIF(BUILD_TYPE)
  MESSAGE(STATUS "Install configuration: \"${CMAKE_INSTALL_CONFIG_NAME}\"")
ENDIF(NOT DEFINED CMAKE_INSTALL_CONFIG_NAME)

# Set the component getting installed.
IF(NOT CMAKE_INSTALL_COMPONENT)
  IF(COMPONENT)
    MESSAGE(STATUS "Install component: \"${COMPONENT}\"")
    SET(CMAKE_INSTALL_COMPONENT "${COMPONENT}")
  ELSE(COMPONENT)
    SET(CMAKE_INSTALL_COMPONENT)
  ENDIF(COMPONENT)
ENDIF(NOT CMAKE_INSTALL_COMPONENT)

# Install shared libraries without execute permission?
IF(NOT DEFINED CMAKE_INSTALL_SO_NO_EXE)
  SET(CMAKE_INSTALL_SO_NO_EXE "1")
ENDIF(NOT DEFINED CMAKE_INSTALL_SO_NO_EXE)

IF(NOT CMAKE_INSTALL_COMPONENT OR "${CMAKE_INSTALL_COMPONENT}" STREQUAL "Devel")
  list(APPEND CMAKE_ABSOLUTE_DESTINATION_FILES
   "/home/beomjoon/Documents/Github/drake-distro/build/include/eigen3/unsupported/Eigen/AdolcForward;/home/beomjoon/Documents/Github/drake-distro/build/include/eigen3/unsupported/Eigen/BVH;/home/beomjoon/Documents/Github/drake-distro/build/include/eigen3/unsupported/Eigen/IterativeSolvers;/home/beomjoon/Documents/Github/drake-distro/build/include/eigen3/unsupported/Eigen/MatrixFunctions;/home/beomjoon/Documents/Github/drake-distro/build/include/eigen3/unsupported/Eigen/MoreVectorization;/home/beomjoon/Documents/Github/drake-distro/build/include/eigen3/unsupported/Eigen/AutoDiff;/home/beomjoon/Documents/Github/drake-distro/build/include/eigen3/unsupported/Eigen/AlignedVector3;/home/beomjoon/Documents/Github/drake-distro/build/include/eigen3/unsupported/Eigen/Polynomials;/home/beomjoon/Documents/Github/drake-distro/build/include/eigen3/unsupported/Eigen/FFT;/home/beomjoon/Documents/Github/drake-distro/build/include/eigen3/unsupported/Eigen/NonLinearOptimization;/home/beomjoon/Documents/Github/drake-distro/build/include/eigen3/unsupported/Eigen/SparseExtra;/home/beomjoon/Documents/Github/drake-distro/build/include/eigen3/unsupported/Eigen/IterativeSolvers;/home/beomjoon/Documents/Github/drake-distro/build/include/eigen3/unsupported/Eigen/NumericalDiff;/home/beomjoon/Documents/Github/drake-distro/build/include/eigen3/unsupported/Eigen/Skyline;/home/beomjoon/Documents/Github/drake-distro/build/include/eigen3/unsupported/Eigen/MPRealSupport;/home/beomjoon/Documents/Github/drake-distro/build/include/eigen3/unsupported/Eigen/OpenGLSupport;/home/beomjoon/Documents/Github/drake-distro/build/include/eigen3/unsupported/Eigen/KroneckerProduct;/home/beomjoon/Documents/Github/drake-distro/build/include/eigen3/unsupported/Eigen/Splines;/home/beomjoon/Documents/Github/drake-distro/build/include/eigen3/unsupported/Eigen/LevenbergMarquardt")
  IF (CMAKE_WARN_ON_ABSOLUTE_INSTALL_DESTINATION)
    message(WARNING "ABSOLUTE path INSTALL DESTINATION : ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
  ENDIF (CMAKE_WARN_ON_ABSOLUTE_INSTALL_DESTINATION)
  IF (CMAKE_ERROR_ON_ABSOLUTE_INSTALL_DESTINATION)
    message(FATAL_ERROR "ABSOLUTE path INSTALL DESTINATION forbidden (by caller): ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
  ENDIF (CMAKE_ERROR_ON_ABSOLUTE_INSTALL_DESTINATION)
FILE(INSTALL DESTINATION "/home/beomjoon/Documents/Github/drake-distro/build/include/eigen3/unsupported/Eigen" TYPE FILE FILES
    "/home/beomjoon/Documents/Github/drake-distro/eigen/eigen-eigen-6b38706d90a9/unsupported/Eigen/AdolcForward"
    "/home/beomjoon/Documents/Github/drake-distro/eigen/eigen-eigen-6b38706d90a9/unsupported/Eigen/BVH"
    "/home/beomjoon/Documents/Github/drake-distro/eigen/eigen-eigen-6b38706d90a9/unsupported/Eigen/IterativeSolvers"
    "/home/beomjoon/Documents/Github/drake-distro/eigen/eigen-eigen-6b38706d90a9/unsupported/Eigen/MatrixFunctions"
    "/home/beomjoon/Documents/Github/drake-distro/eigen/eigen-eigen-6b38706d90a9/unsupported/Eigen/MoreVectorization"
    "/home/beomjoon/Documents/Github/drake-distro/eigen/eigen-eigen-6b38706d90a9/unsupported/Eigen/AutoDiff"
    "/home/beomjoon/Documents/Github/drake-distro/eigen/eigen-eigen-6b38706d90a9/unsupported/Eigen/AlignedVector3"
    "/home/beomjoon/Documents/Github/drake-distro/eigen/eigen-eigen-6b38706d90a9/unsupported/Eigen/Polynomials"
    "/home/beomjoon/Documents/Github/drake-distro/eigen/eigen-eigen-6b38706d90a9/unsupported/Eigen/FFT"
    "/home/beomjoon/Documents/Github/drake-distro/eigen/eigen-eigen-6b38706d90a9/unsupported/Eigen/NonLinearOptimization"
    "/home/beomjoon/Documents/Github/drake-distro/eigen/eigen-eigen-6b38706d90a9/unsupported/Eigen/SparseExtra"
    "/home/beomjoon/Documents/Github/drake-distro/eigen/eigen-eigen-6b38706d90a9/unsupported/Eigen/IterativeSolvers"
    "/home/beomjoon/Documents/Github/drake-distro/eigen/eigen-eigen-6b38706d90a9/unsupported/Eigen/NumericalDiff"
    "/home/beomjoon/Documents/Github/drake-distro/eigen/eigen-eigen-6b38706d90a9/unsupported/Eigen/Skyline"
    "/home/beomjoon/Documents/Github/drake-distro/eigen/eigen-eigen-6b38706d90a9/unsupported/Eigen/MPRealSupport"
    "/home/beomjoon/Documents/Github/drake-distro/eigen/eigen-eigen-6b38706d90a9/unsupported/Eigen/OpenGLSupport"
    "/home/beomjoon/Documents/Github/drake-distro/eigen/eigen-eigen-6b38706d90a9/unsupported/Eigen/KroneckerProduct"
    "/home/beomjoon/Documents/Github/drake-distro/eigen/eigen-eigen-6b38706d90a9/unsupported/Eigen/Splines"
    "/home/beomjoon/Documents/Github/drake-distro/eigen/eigen-eigen-6b38706d90a9/unsupported/Eigen/LevenbergMarquardt"
    )
ENDIF(NOT CMAKE_INSTALL_COMPONENT OR "${CMAKE_INSTALL_COMPONENT}" STREQUAL "Devel")

IF(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for each subdirectory.
  INCLUDE("/home/beomjoon/Documents/Github/drake-distro/eigen/pod-build/unsupported/Eigen/src/cmake_install.cmake")

ENDIF(NOT CMAKE_INSTALL_LOCAL_ONLY)

