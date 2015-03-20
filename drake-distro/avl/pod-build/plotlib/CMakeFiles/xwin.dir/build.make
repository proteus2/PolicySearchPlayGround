# CMAKE generated file: DO NOT EDIT!
# Generated by "Unix Makefiles" Generator, CMake Version 2.8

#=============================================================================
# Special targets provided by cmake.

# Disable implicit rules so canonical targets will work.
.SUFFIXES:

# Remove some rules from gmake that .SUFFIXES does not remove.
SUFFIXES =

.SUFFIXES: .hpux_make_needs_suffix_list

# Suppress display of executed commands.
$(VERBOSE).SILENT:

# A target that is always out of date.
cmake_force:
.PHONY : cmake_force

#=============================================================================
# Set environment variables for the build.

# The shell in which to execute make rules.
SHELL = /bin/sh

# The CMake executable.
CMAKE_COMMAND = /usr/bin/cmake

# The command to remove a file.
RM = /usr/bin/cmake -E remove -f

# Escaping for special characters.
EQUALS = =

# The top-level source directory on which CMake was run.
CMAKE_SOURCE_DIR = /home/beomjoon/Documents/Github/drake-distro/avl

# The top-level build directory on which CMake was run.
CMAKE_BINARY_DIR = /home/beomjoon/Documents/Github/drake-distro/avl/pod-build

# Include any dependencies generated for this target.
include plotlib/CMakeFiles/xwin.dir/depend.make

# Include the progress variables for this target.
include plotlib/CMakeFiles/xwin.dir/progress.make

# Include the compile flags for this target's objects.
include plotlib/CMakeFiles/xwin.dir/flags.make

plotlib/CMakeFiles/xwin.dir/Xwin.c.o: plotlib/CMakeFiles/xwin.dir/flags.make
plotlib/CMakeFiles/xwin.dir/Xwin.c.o: ../plotlib/Xwin.c
	$(CMAKE_COMMAND) -E cmake_progress_report /home/beomjoon/Documents/Github/drake-distro/avl/pod-build/CMakeFiles $(CMAKE_PROGRESS_1)
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Building C object plotlib/CMakeFiles/xwin.dir/Xwin.c.o"
	cd /home/beomjoon/Documents/Github/drake-distro/avl/pod-build/plotlib && /usr/bin/cc  $(C_DEFINES) $(C_FLAGS) -o CMakeFiles/xwin.dir/Xwin.c.o   -c /home/beomjoon/Documents/Github/drake-distro/avl/plotlib/Xwin.c

plotlib/CMakeFiles/xwin.dir/Xwin.c.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing C source to CMakeFiles/xwin.dir/Xwin.c.i"
	cd /home/beomjoon/Documents/Github/drake-distro/avl/pod-build/plotlib && /usr/bin/cc  $(C_DEFINES) $(C_FLAGS) -E /home/beomjoon/Documents/Github/drake-distro/avl/plotlib/Xwin.c > CMakeFiles/xwin.dir/Xwin.c.i

plotlib/CMakeFiles/xwin.dir/Xwin.c.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling C source to assembly CMakeFiles/xwin.dir/Xwin.c.s"
	cd /home/beomjoon/Documents/Github/drake-distro/avl/pod-build/plotlib && /usr/bin/cc  $(C_DEFINES) $(C_FLAGS) -S /home/beomjoon/Documents/Github/drake-distro/avl/plotlib/Xwin.c -o CMakeFiles/xwin.dir/Xwin.c.s

plotlib/CMakeFiles/xwin.dir/Xwin.c.o.requires:
.PHONY : plotlib/CMakeFiles/xwin.dir/Xwin.c.o.requires

plotlib/CMakeFiles/xwin.dir/Xwin.c.o.provides: plotlib/CMakeFiles/xwin.dir/Xwin.c.o.requires
	$(MAKE) -f plotlib/CMakeFiles/xwin.dir/build.make plotlib/CMakeFiles/xwin.dir/Xwin.c.o.provides.build
.PHONY : plotlib/CMakeFiles/xwin.dir/Xwin.c.o.provides

plotlib/CMakeFiles/xwin.dir/Xwin.c.o.provides.build: plotlib/CMakeFiles/xwin.dir/Xwin.c.o

# Object files for target xwin
xwin_OBJECTS = \
"CMakeFiles/xwin.dir/Xwin.c.o"

# External object files for target xwin
xwin_EXTERNAL_OBJECTS =

lib/libxwin.a: plotlib/CMakeFiles/xwin.dir/Xwin.c.o
lib/libxwin.a: plotlib/CMakeFiles/xwin.dir/build.make
lib/libxwin.a: plotlib/CMakeFiles/xwin.dir/link.txt
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --red --bold "Linking C static library ../lib/libxwin.a"
	cd /home/beomjoon/Documents/Github/drake-distro/avl/pod-build/plotlib && $(CMAKE_COMMAND) -P CMakeFiles/xwin.dir/cmake_clean_target.cmake
	cd /home/beomjoon/Documents/Github/drake-distro/avl/pod-build/plotlib && $(CMAKE_COMMAND) -E cmake_link_script CMakeFiles/xwin.dir/link.txt --verbose=$(VERBOSE)

# Rule to build all files generated by this target.
plotlib/CMakeFiles/xwin.dir/build: lib/libxwin.a
.PHONY : plotlib/CMakeFiles/xwin.dir/build

plotlib/CMakeFiles/xwin.dir/requires: plotlib/CMakeFiles/xwin.dir/Xwin.c.o.requires
.PHONY : plotlib/CMakeFiles/xwin.dir/requires

plotlib/CMakeFiles/xwin.dir/clean:
	cd /home/beomjoon/Documents/Github/drake-distro/avl/pod-build/plotlib && $(CMAKE_COMMAND) -P CMakeFiles/xwin.dir/cmake_clean.cmake
.PHONY : plotlib/CMakeFiles/xwin.dir/clean

plotlib/CMakeFiles/xwin.dir/depend:
	cd /home/beomjoon/Documents/Github/drake-distro/avl/pod-build && $(CMAKE_COMMAND) -E cmake_depends "Unix Makefiles" /home/beomjoon/Documents/Github/drake-distro/avl /home/beomjoon/Documents/Github/drake-distro/avl/plotlib /home/beomjoon/Documents/Github/drake-distro/avl/pod-build /home/beomjoon/Documents/Github/drake-distro/avl/pod-build/plotlib /home/beomjoon/Documents/Github/drake-distro/avl/pod-build/plotlib/CMakeFiles/xwin.dir/DependInfo.cmake --color=$(COLOR)
.PHONY : plotlib/CMakeFiles/xwin.dir/depend

