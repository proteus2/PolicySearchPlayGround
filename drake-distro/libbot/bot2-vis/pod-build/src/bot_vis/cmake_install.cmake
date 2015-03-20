# Install script for directory: /home/beomjoon/Documents/Github/drake-distro/libbot/bot2-vis/src/bot_vis

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
  FOREACH(file
      "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/libbot2-vis.so.1"
      "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/libbot2-vis.so"
      )
    IF(EXISTS "${file}" AND
       NOT IS_SYMLINK "${file}")
      FILE(RPATH_CHECK
           FILE "${file}"
           RPATH "/home/beomjoon/Documents/Github/drake-distro/build/lib")
    ENDIF()
  ENDFOREACH()
  FILE(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib" TYPE SHARED_LIBRARY FILES
    "/home/beomjoon/Documents/Github/drake-distro/libbot/bot2-vis/pod-build/lib/libbot2-vis.so.1"
    "/home/beomjoon/Documents/Github/drake-distro/libbot/bot2-vis/pod-build/lib/libbot2-vis.so"
    )
  FOREACH(file
      "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/libbot2-vis.so.1"
      "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/libbot2-vis.so"
      )
    IF(EXISTS "${file}" AND
       NOT IS_SYMLINK "${file}")
      FILE(RPATH_CHANGE
           FILE "${file}"
           OLD_RPATH "/home/beomjoon/Documents/Github/drake-distro/libbot/bot2-vis/pod-build/lib:/home/beomjoon/Documents/Github/drake-distro/build/lib:"
           NEW_RPATH "/home/beomjoon/Documents/Github/drake-distro/build/lib")
      IF(CMAKE_INSTALL_DO_STRIP)
        EXECUTE_PROCESS(COMMAND "/usr/bin/strip" "${file}")
      ENDIF(CMAKE_INSTALL_DO_STRIP)
    ENDIF()
  ENDFOREACH()
ENDIF(NOT CMAKE_INSTALL_COMPONENT OR "${CMAKE_INSTALL_COMPONENT}" STREQUAL "Unspecified")

IF(NOT CMAKE_INSTALL_COMPONENT OR "${CMAKE_INSTALL_COMPONENT}" STREQUAL "Unspecified")
  FILE(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/include/bot_vis" TYPE FILE FILES
    "/home/beomjoon/Documents/Github/drake-distro/libbot/bot2-vis/src/bot_vis/param_widget.h"
    "/home/beomjoon/Documents/Github/drake-distro/libbot/bot2-vis/src/bot_vis/rwx.h"
    "/home/beomjoon/Documents/Github/drake-distro/libbot/bot2-vis/src/bot_vis/default_view_handler.h"
    "/home/beomjoon/Documents/Github/drake-distro/libbot/bot2-vis/src/bot_vis/bot_vis.h"
    "/home/beomjoon/Documents/Github/drake-distro/libbot/bot2-vis/src/bot_vis/wavefront.h"
    "/home/beomjoon/Documents/Github/drake-distro/libbot/bot2-vis/src/bot_vis/gl_drawing_area.h"
    "/home/beomjoon/Documents/Github/drake-distro/libbot/bot2-vis/src/bot_vis/fbgl_drawing_area.h"
    "/home/beomjoon/Documents/Github/drake-distro/libbot/bot2-vis/src/bot_vis/tokenize.h"
    "/home/beomjoon/Documents/Github/drake-distro/libbot/bot2-vis/src/bot_vis/gtk_util.h"
    "/home/beomjoon/Documents/Github/drake-distro/libbot/bot2-vis/src/bot_vis/glmint.h"
    "/home/beomjoon/Documents/Github/drake-distro/libbot/bot2-vis/src/bot_vis/scrollplot2d.h"
    "/home/beomjoon/Documents/Github/drake-distro/libbot/bot2-vis/src/bot_vis/batch_gl.h"
    "/home/beomjoon/Documents/Github/drake-distro/libbot/bot2-vis/src/bot_vis/glm.h"
    "/home/beomjoon/Documents/Github/drake-distro/libbot/bot2-vis/src/bot_vis/gl_image_area.h"
    "/home/beomjoon/Documents/Github/drake-distro/libbot/bot2-vis/src/bot_vis/view.h"
    "/home/beomjoon/Documents/Github/drake-distro/libbot/bot2-vis/src/bot_vis/gl_util.h"
    "/home/beomjoon/Documents/Github/drake-distro/libbot/bot2-vis/src/bot_vis/viewer.h"
    "/home/beomjoon/Documents/Github/drake-distro/libbot/bot2-vis/src/bot_vis/texture.h"
    "/home/beomjoon/Documents/Github/drake-distro/libbot/bot2-vis/src/bot_vis/console.h"
    )
ENDIF(NOT CMAKE_INSTALL_COMPONENT OR "${CMAKE_INSTALL_COMPONENT}" STREQUAL "Unspecified")

IF(NOT CMAKE_INSTALL_COMPONENT OR "${CMAKE_INSTALL_COMPONENT}" STREQUAL "Unspecified")
  FILE(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib/pkgconfig" TYPE FILE FILES "/home/beomjoon/Documents/Github/drake-distro/libbot/bot2-vis/pod-build/lib/pkgconfig/bot2-vis.pc")
ENDIF(NOT CMAKE_INSTALL_COMPONENT OR "${CMAKE_INSTALL_COMPONENT}" STREQUAL "Unspecified")

