# Install script for directory: /home/beomjoon/Documents/Github/drake-distro/libbot/bot2-procman

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

IF(NOT CMAKE_INSTALL_COMPONENT OR "${CMAKE_INSTALL_COMPONENT}" STREQUAL "Unspecified")
  FILE(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib" TYPE STATIC_LIBRARY FILES "/home/beomjoon/Documents/Github/drake-distro/libbot/bot2-procman/pod-build/lib/liblcmtypes_bot2-procman.a")
ENDIF(NOT CMAKE_INSTALL_COMPONENT OR "${CMAKE_INSTALL_COMPONENT}" STREQUAL "Unspecified")

IF(NOT CMAKE_INSTALL_COMPONENT OR "${CMAKE_INSTALL_COMPONENT}" STREQUAL "Unspecified")
  FILE(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/include/lcmtypes" TYPE FILE FILES
    "/home/beomjoon/Documents/Github/drake-distro/libbot/bot2-procman/lcmtypes/c/lcmtypes/bot_procman_command2_t.h"
    "/home/beomjoon/Documents/Github/drake-distro/libbot/bot2-procman/lcmtypes/c/lcmtypes/bot_procman_orders2_t.h"
    "/home/beomjoon/Documents/Github/drake-distro/libbot/bot2-procman/lcmtypes/c/lcmtypes/bot_procman_orders_t.h"
    "/home/beomjoon/Documents/Github/drake-distro/libbot/bot2-procman/lcmtypes/c/lcmtypes/bot_procman_sheriff_cmd2_t.h"
    "/home/beomjoon/Documents/Github/drake-distro/libbot/bot2-procman/lcmtypes/c/lcmtypes/bot_procman_deputy_cmd_t.h"
    "/home/beomjoon/Documents/Github/drake-distro/libbot/bot2-procman/lcmtypes/c/lcmtypes/bot_procman_sheriff_cmd_t.h"
    "/home/beomjoon/Documents/Github/drake-distro/libbot/bot2-procman/lcmtypes/c/lcmtypes/bot_procman_info_t.h"
    "/home/beomjoon/Documents/Github/drake-distro/libbot/bot2-procman/lcmtypes/c/lcmtypes/bot_procman_info2_t.h"
    "/home/beomjoon/Documents/Github/drake-distro/libbot/bot2-procman/lcmtypes/c/lcmtypes/bot_procman_deputy_cmd2_t.h"
    "/home/beomjoon/Documents/Github/drake-distro/libbot/bot2-procman/lcmtypes/c/lcmtypes/bot_procman_discovery_t.h"
    "/home/beomjoon/Documents/Github/drake-distro/libbot/bot2-procman/lcmtypes/c/lcmtypes/bot_procman_printf_t.h"
    "/home/beomjoon/Documents/Github/drake-distro/libbot/bot2-procman/lcmtypes/c/lcmtypes/bot2_procman.h"
    )
ENDIF(NOT CMAKE_INSTALL_COMPONENT OR "${CMAKE_INSTALL_COMPONENT}" STREQUAL "Unspecified")

IF(NOT CMAKE_INSTALL_COMPONENT OR "${CMAKE_INSTALL_COMPONENT}" STREQUAL "Unspecified")
  FILE(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib/pkgconfig" TYPE FILE FILES "/home/beomjoon/Documents/Github/drake-distro/libbot/bot2-procman/pod-build/lib/pkgconfig/lcmtypes_bot2-procman.pc")
ENDIF(NOT CMAKE_INSTALL_COMPONENT OR "${CMAKE_INSTALL_COMPONENT}" STREQUAL "Unspecified")

IF(NOT CMAKE_INSTALL_COMPONENT OR "${CMAKE_INSTALL_COMPONENT}" STREQUAL "Unspecified")
  FILE(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/include/lcmtypes/bot_procman" TYPE FILE FILES "/home/beomjoon/Documents/Github/drake-distro/libbot/bot2-procman/lcmtypes/cpp/lcmtypes/bot_procman/printf_t.hpp")
ENDIF(NOT CMAKE_INSTALL_COMPONENT OR "${CMAKE_INSTALL_COMPONENT}" STREQUAL "Unspecified")

IF(NOT CMAKE_INSTALL_COMPONENT OR "${CMAKE_INSTALL_COMPONENT}" STREQUAL "Unspecified")
  FILE(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/include/lcmtypes/bot_procman" TYPE FILE FILES "/home/beomjoon/Documents/Github/drake-distro/libbot/bot2-procman/lcmtypes/cpp/lcmtypes/bot_procman/sheriff_cmd_t.hpp")
ENDIF(NOT CMAKE_INSTALL_COMPONENT OR "${CMAKE_INSTALL_COMPONENT}" STREQUAL "Unspecified")

IF(NOT CMAKE_INSTALL_COMPONENT OR "${CMAKE_INSTALL_COMPONENT}" STREQUAL "Unspecified")
  FILE(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/include/lcmtypes/bot_procman" TYPE FILE FILES "/home/beomjoon/Documents/Github/drake-distro/libbot/bot2-procman/lcmtypes/cpp/lcmtypes/bot_procman/command2_t.hpp")
ENDIF(NOT CMAKE_INSTALL_COMPONENT OR "${CMAKE_INSTALL_COMPONENT}" STREQUAL "Unspecified")

IF(NOT CMAKE_INSTALL_COMPONENT OR "${CMAKE_INSTALL_COMPONENT}" STREQUAL "Unspecified")
  FILE(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/include/lcmtypes/bot_procman" TYPE FILE FILES "/home/beomjoon/Documents/Github/drake-distro/libbot/bot2-procman/lcmtypes/cpp/lcmtypes/bot_procman/info2_t.hpp")
ENDIF(NOT CMAKE_INSTALL_COMPONENT OR "${CMAKE_INSTALL_COMPONENT}" STREQUAL "Unspecified")

IF(NOT CMAKE_INSTALL_COMPONENT OR "${CMAKE_INSTALL_COMPONENT}" STREQUAL "Unspecified")
  FILE(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/include/lcmtypes/bot_procman" TYPE FILE FILES "/home/beomjoon/Documents/Github/drake-distro/libbot/bot2-procman/lcmtypes/cpp/lcmtypes/bot_procman/orders_t.hpp")
ENDIF(NOT CMAKE_INSTALL_COMPONENT OR "${CMAKE_INSTALL_COMPONENT}" STREQUAL "Unspecified")

IF(NOT CMAKE_INSTALL_COMPONENT OR "${CMAKE_INSTALL_COMPONENT}" STREQUAL "Unspecified")
  FILE(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/include/lcmtypes/bot_procman" TYPE FILE FILES "/home/beomjoon/Documents/Github/drake-distro/libbot/bot2-procman/lcmtypes/cpp/lcmtypes/bot_procman/info_t.hpp")
ENDIF(NOT CMAKE_INSTALL_COMPONENT OR "${CMAKE_INSTALL_COMPONENT}" STREQUAL "Unspecified")

IF(NOT CMAKE_INSTALL_COMPONENT OR "${CMAKE_INSTALL_COMPONENT}" STREQUAL "Unspecified")
  FILE(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/include/lcmtypes/bot_procman" TYPE FILE FILES "/home/beomjoon/Documents/Github/drake-distro/libbot/bot2-procman/lcmtypes/cpp/lcmtypes/bot_procman/orders2_t.hpp")
ENDIF(NOT CMAKE_INSTALL_COMPONENT OR "${CMAKE_INSTALL_COMPONENT}" STREQUAL "Unspecified")

IF(NOT CMAKE_INSTALL_COMPONENT OR "${CMAKE_INSTALL_COMPONENT}" STREQUAL "Unspecified")
  FILE(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/include/lcmtypes/bot_procman" TYPE FILE FILES "/home/beomjoon/Documents/Github/drake-distro/libbot/bot2-procman/lcmtypes/cpp/lcmtypes/bot_procman/deputy_cmd2_t.hpp")
ENDIF(NOT CMAKE_INSTALL_COMPONENT OR "${CMAKE_INSTALL_COMPONENT}" STREQUAL "Unspecified")

IF(NOT CMAKE_INSTALL_COMPONENT OR "${CMAKE_INSTALL_COMPONENT}" STREQUAL "Unspecified")
  FILE(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/include/lcmtypes/bot_procman" TYPE FILE FILES "/home/beomjoon/Documents/Github/drake-distro/libbot/bot2-procman/lcmtypes/cpp/lcmtypes/bot_procman/discovery_t.hpp")
ENDIF(NOT CMAKE_INSTALL_COMPONENT OR "${CMAKE_INSTALL_COMPONENT}" STREQUAL "Unspecified")

IF(NOT CMAKE_INSTALL_COMPONENT OR "${CMAKE_INSTALL_COMPONENT}" STREQUAL "Unspecified")
  FILE(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/include/lcmtypes/bot_procman" TYPE FILE FILES "/home/beomjoon/Documents/Github/drake-distro/libbot/bot2-procman/lcmtypes/cpp/lcmtypes/bot_procman/deputy_cmd_t.hpp")
ENDIF(NOT CMAKE_INSTALL_COMPONENT OR "${CMAKE_INSTALL_COMPONENT}" STREQUAL "Unspecified")

IF(NOT CMAKE_INSTALL_COMPONENT OR "${CMAKE_INSTALL_COMPONENT}" STREQUAL "Unspecified")
  FILE(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/include/lcmtypes/bot_procman" TYPE FILE FILES "/home/beomjoon/Documents/Github/drake-distro/libbot/bot2-procman/lcmtypes/cpp/lcmtypes/bot_procman/sheriff_cmd2_t.hpp")
ENDIF(NOT CMAKE_INSTALL_COMPONENT OR "${CMAKE_INSTALL_COMPONENT}" STREQUAL "Unspecified")

IF(NOT CMAKE_INSTALL_COMPONENT OR "${CMAKE_INSTALL_COMPONENT}" STREQUAL "Unspecified")
  FILE(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/include/lcmtypes" TYPE FILE FILES "/home/beomjoon/Documents/Github/drake-distro/libbot/bot2-procman/lcmtypes/cpp/lcmtypes/bot2_procman.hpp")
ENDIF(NOT CMAKE_INSTALL_COMPONENT OR "${CMAKE_INSTALL_COMPONENT}" STREQUAL "Unspecified")

IF(NOT CMAKE_INSTALL_COMPONENT OR "${CMAKE_INSTALL_COMPONENT}" STREQUAL "Unspecified")
  FILE(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/share/java" TYPE FILE FILES "/home/beomjoon/Documents/Github/drake-distro/libbot/bot2-procman/pod-build/lcmtypes_bot2-procman.jar")
ENDIF(NOT CMAKE_INSTALL_COMPONENT OR "${CMAKE_INSTALL_COMPONENT}" STREQUAL "Unspecified")

IF(NOT CMAKE_INSTALL_COMPONENT OR "${CMAKE_INSTALL_COMPONENT}" STREQUAL "Unspecified")
  FILE(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/share/lcmtypes" TYPE FILE FILES
    "/home/beomjoon/Documents/Github/drake-distro/libbot/bot2-procman/lcmtypes/bot_procman_discovery_t.lcm"
    "/home/beomjoon/Documents/Github/drake-distro/libbot/bot2-procman/lcmtypes/bot_procman_deputy_cmd_t.lcm"
    "/home/beomjoon/Documents/Github/drake-distro/libbot/bot2-procman/lcmtypes/bot_procman_info2_t.lcm"
    "/home/beomjoon/Documents/Github/drake-distro/libbot/bot2-procman/lcmtypes/bot_procman_info_t.lcm"
    "/home/beomjoon/Documents/Github/drake-distro/libbot/bot2-procman/lcmtypes/bot_procman_orders2_t.lcm"
    "/home/beomjoon/Documents/Github/drake-distro/libbot/bot2-procman/lcmtypes/bot_procman_sheriff_cmd_t.lcm"
    "/home/beomjoon/Documents/Github/drake-distro/libbot/bot2-procman/lcmtypes/bot_procman_command2_t.lcm"
    "/home/beomjoon/Documents/Github/drake-distro/libbot/bot2-procman/lcmtypes/bot_procman_deputy_cmd2_t.lcm"
    "/home/beomjoon/Documents/Github/drake-distro/libbot/bot2-procman/lcmtypes/bot_procman_printf_t.lcm"
    "/home/beomjoon/Documents/Github/drake-distro/libbot/bot2-procman/lcmtypes/bot_procman_orders_t.lcm"
    "/home/beomjoon/Documents/Github/drake-distro/libbot/bot2-procman/lcmtypes/bot_procman_sheriff_cmd2_t.lcm"
    )
ENDIF(NOT CMAKE_INSTALL_COMPONENT OR "${CMAKE_INSTALL_COMPONENT}" STREQUAL "Unspecified")

IF(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for each subdirectory.
  INCLUDE("/home/beomjoon/Documents/Github/drake-distro/libbot/bot2-procman/pod-build/src/deputy/cmake_install.cmake")
  INCLUDE("/home/beomjoon/Documents/Github/drake-distro/libbot/bot2-procman/pod-build/python/cmake_install.cmake")

ENDIF(NOT CMAKE_INSTALL_LOCAL_ONLY)

IF(CMAKE_INSTALL_COMPONENT)
  SET(CMAKE_INSTALL_MANIFEST "install_manifest_${CMAKE_INSTALL_COMPONENT}.txt")
ELSE(CMAKE_INSTALL_COMPONENT)
  SET(CMAKE_INSTALL_MANIFEST "install_manifest.txt")
ENDIF(CMAKE_INSTALL_COMPONENT)

FILE(WRITE "/home/beomjoon/Documents/Github/drake-distro/libbot/bot2-procman/pod-build/${CMAKE_INSTALL_MANIFEST}" "")
FOREACH(file ${CMAKE_INSTALL_MANIFEST_FILES})
  FILE(APPEND "/home/beomjoon/Documents/Github/drake-distro/libbot/bot2-procman/pod-build/${CMAKE_INSTALL_MANIFEST}" "${file}\n")
ENDFOREACH(file)
