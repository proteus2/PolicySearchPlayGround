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
include examples/CMakeFiles/sqmain.dir/depend.make

# Include the progress variables for this target.
include examples/CMakeFiles/sqmain.dir/progress.make

# Include the compile flags for this target's objects.
include examples/CMakeFiles/sqmain.dir/flags.make

examples/CMakeFiles/sqmain.dir/sqmain.f.o: examples/CMakeFiles/sqmain.dir/flags.make
examples/CMakeFiles/sqmain.dir/sqmain.f.o: ../examples/sqmain.f
	$(CMAKE_COMMAND) -E cmake_progress_report /home/beomjoon/Documents/Github/drake-distro/snopt/pod-build/CMakeFiles $(CMAKE_PROGRESS_1)
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Building Fortran object examples/CMakeFiles/sqmain.dir/sqmain.f.o"
	cd /home/beomjoon/Documents/Github/drake-distro/snopt/pod-build/examples && /usr/bin/gfortran  $(Fortran_DEFINES) $(Fortran_FLAGS) -c /home/beomjoon/Documents/Github/drake-distro/snopt/examples/sqmain.f -o CMakeFiles/sqmain.dir/sqmain.f.o

examples/CMakeFiles/sqmain.dir/sqmain.f.o.requires:
.PHONY : examples/CMakeFiles/sqmain.dir/sqmain.f.o.requires

examples/CMakeFiles/sqmain.dir/sqmain.f.o.provides: examples/CMakeFiles/sqmain.dir/sqmain.f.o.requires
	$(MAKE) -f examples/CMakeFiles/sqmain.dir/build.make examples/CMakeFiles/sqmain.dir/sqmain.f.o.provides.build
.PHONY : examples/CMakeFiles/sqmain.dir/sqmain.f.o.provides

examples/CMakeFiles/sqmain.dir/sqmain.f.o.provides.build: examples/CMakeFiles/sqmain.dir/sqmain.f.o

# Object files for target sqmain
sqmain_OBJECTS = \
"CMakeFiles/sqmain.dir/sqmain.f.o"

# External object files for target sqmain
sqmain_EXTERNAL_OBJECTS =

bin/sqmain: examples/CMakeFiles/sqmain.dir/sqmain.f.o
bin/sqmain: examples/CMakeFiles/sqmain.dir/build.make
bin/sqmain: lib/libsnopt.a
bin/sqmain: lib/libsnprint.a
bin/sqmain: lib/libsnblas.a
bin/sqmain: examples/CMakeFiles/sqmain.dir/link.txt
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --red --bold "Linking Fortran executable ../bin/sqmain"
	cd /home/beomjoon/Documents/Github/drake-distro/snopt/pod-build/examples && $(CMAKE_COMMAND) -E cmake_link_script CMakeFiles/sqmain.dir/link.txt --verbose=$(VERBOSE)

# Rule to build all files generated by this target.
examples/CMakeFiles/sqmain.dir/build: bin/sqmain
.PHONY : examples/CMakeFiles/sqmain.dir/build

examples/CMakeFiles/sqmain.dir/requires: examples/CMakeFiles/sqmain.dir/sqmain.f.o.requires
.PHONY : examples/CMakeFiles/sqmain.dir/requires

examples/CMakeFiles/sqmain.dir/clean:
	cd /home/beomjoon/Documents/Github/drake-distro/snopt/pod-build/examples && $(CMAKE_COMMAND) -P CMakeFiles/sqmain.dir/cmake_clean.cmake
.PHONY : examples/CMakeFiles/sqmain.dir/clean

examples/CMakeFiles/sqmain.dir/depend:
	cd /home/beomjoon/Documents/Github/drake-distro/snopt/pod-build && $(CMAKE_COMMAND) -E cmake_depends "Unix Makefiles" /home/beomjoon/Documents/Github/drake-distro/snopt /home/beomjoon/Documents/Github/drake-distro/snopt/examples /home/beomjoon/Documents/Github/drake-distro/snopt/pod-build /home/beomjoon/Documents/Github/drake-distro/snopt/pod-build/examples /home/beomjoon/Documents/Github/drake-distro/snopt/pod-build/examples/CMakeFiles/sqmain.dir/DependInfo.cmake --color=$(COLOR)
.PHONY : examples/CMakeFiles/sqmain.dir/depend
