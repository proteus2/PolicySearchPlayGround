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
CMAKE_SOURCE_DIR = /home/beomjoon/Documents/Github/drake-distro/snopt

# The top-level build directory on which CMake was run.
CMAKE_BINARY_DIR = /home/beomjoon/Documents/Github/drake-distro/snopt/pod-build

# Include any dependencies generated for this target.
include examples/CMakeFiles/tester.dir/depend.make

# Include the progress variables for this target.
include examples/CMakeFiles/tester.dir/progress.make

# Include the compile flags for this target's objects.
include examples/CMakeFiles/tester.dir/flags.make

examples/CMakeFiles/tester.dir/tester.f.o: examples/CMakeFiles/tester.dir/flags.make
examples/CMakeFiles/tester.dir/tester.f.o: ../examples/tester.f
	$(CMAKE_COMMAND) -E cmake_progress_report /home/beomjoon/Documents/Github/drake-distro/snopt/pod-build/CMakeFiles $(CMAKE_PROGRESS_1)
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Building Fortran object examples/CMakeFiles/tester.dir/tester.f.o"
	cd /home/beomjoon/Documents/Github/drake-distro/snopt/pod-build/examples && /usr/bin/gfortran  $(Fortran_DEFINES) $(Fortran_FLAGS) -c /home/beomjoon/Documents/Github/drake-distro/snopt/examples/tester.f -o CMakeFiles/tester.dir/tester.f.o

examples/CMakeFiles/tester.dir/tester.f.o.requires:
.PHONY : examples/CMakeFiles/tester.dir/tester.f.o.requires

examples/CMakeFiles/tester.dir/tester.f.o.provides: examples/CMakeFiles/tester.dir/tester.f.o.requires
	$(MAKE) -f examples/CMakeFiles/tester.dir/build.make examples/CMakeFiles/tester.dir/tester.f.o.provides.build
.PHONY : examples/CMakeFiles/tester.dir/tester.f.o.provides

examples/CMakeFiles/tester.dir/tester.f.o.provides.build: examples/CMakeFiles/tester.dir/tester.f.o

# Object files for target tester
tester_OBJECTS = \
"CMakeFiles/tester.dir/tester.f.o"

# External object files for target tester
tester_EXTERNAL_OBJECTS =

bin/tester: examples/CMakeFiles/tester.dir/tester.f.o
bin/tester: examples/CMakeFiles/tester.dir/build.make
bin/tester: lib/libsnopt.a
bin/tester: lib/libsnprint.a
bin/tester: lib/libsnblas.a
bin/tester: examples/CMakeFiles/tester.dir/link.txt
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --red --bold "Linking Fortran executable ../bin/tester"
	cd /home/beomjoon/Documents/Github/drake-distro/snopt/pod-build/examples && $(CMAKE_COMMAND) -E cmake_link_script CMakeFiles/tester.dir/link.txt --verbose=$(VERBOSE)

# Rule to build all files generated by this target.
examples/CMakeFiles/tester.dir/build: bin/tester
.PHONY : examples/CMakeFiles/tester.dir/build

examples/CMakeFiles/tester.dir/requires: examples/CMakeFiles/tester.dir/tester.f.o.requires
.PHONY : examples/CMakeFiles/tester.dir/requires

examples/CMakeFiles/tester.dir/clean:
	cd /home/beomjoon/Documents/Github/drake-distro/snopt/pod-build/examples && $(CMAKE_COMMAND) -P CMakeFiles/tester.dir/cmake_clean.cmake
.PHONY : examples/CMakeFiles/tester.dir/clean

examples/CMakeFiles/tester.dir/depend:
	cd /home/beomjoon/Documents/Github/drake-distro/snopt/pod-build && $(CMAKE_COMMAND) -E cmake_depends "Unix Makefiles" /home/beomjoon/Documents/Github/drake-distro/snopt /home/beomjoon/Documents/Github/drake-distro/snopt/examples /home/beomjoon/Documents/Github/drake-distro/snopt/pod-build /home/beomjoon/Documents/Github/drake-distro/snopt/pod-build/examples /home/beomjoon/Documents/Github/drake-distro/snopt/pod-build/examples/CMakeFiles/tester.dir/DependInfo.cmake --color=$(COLOR)
.PHONY : examples/CMakeFiles/tester.dir/depend
