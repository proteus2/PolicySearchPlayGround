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
include examples/CMakeFiles/maxi.dir/depend.make

# Include the progress variables for this target.
include examples/CMakeFiles/maxi.dir/progress.make

# Include the compile flags for this target's objects.
include examples/CMakeFiles/maxi.dir/flags.make

examples/CMakeFiles/maxi.dir/maxi.f.o: examples/CMakeFiles/maxi.dir/flags.make
examples/CMakeFiles/maxi.dir/maxi.f.o: ../examples/maxi.f
	$(CMAKE_COMMAND) -E cmake_progress_report /home/beomjoon/Documents/Github/drake-distro/snopt/pod-build/CMakeFiles $(CMAKE_PROGRESS_1)
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Building Fortran object examples/CMakeFiles/maxi.dir/maxi.f.o"
	cd /home/beomjoon/Documents/Github/drake-distro/snopt/pod-build/examples && /usr/bin/gfortran  $(Fortran_DEFINES) $(Fortran_FLAGS) -c /home/beomjoon/Documents/Github/drake-distro/snopt/examples/maxi.f -o CMakeFiles/maxi.dir/maxi.f.o

examples/CMakeFiles/maxi.dir/maxi.f.o.requires:
.PHONY : examples/CMakeFiles/maxi.dir/maxi.f.o.requires

examples/CMakeFiles/maxi.dir/maxi.f.o.provides: examples/CMakeFiles/maxi.dir/maxi.f.o.requires
	$(MAKE) -f examples/CMakeFiles/maxi.dir/build.make examples/CMakeFiles/maxi.dir/maxi.f.o.provides.build
.PHONY : examples/CMakeFiles/maxi.dir/maxi.f.o.provides

examples/CMakeFiles/maxi.dir/maxi.f.o.provides.build: examples/CMakeFiles/maxi.dir/maxi.f.o

# Object files for target maxi
maxi_OBJECTS = \
"CMakeFiles/maxi.dir/maxi.f.o"

# External object files for target maxi
maxi_EXTERNAL_OBJECTS =

bin/maxi: examples/CMakeFiles/maxi.dir/maxi.f.o
bin/maxi: examples/CMakeFiles/maxi.dir/build.make
bin/maxi: lib/libsnopt.a
bin/maxi: lib/libsnprint.a
bin/maxi: lib/libsnblas.a
bin/maxi: examples/CMakeFiles/maxi.dir/link.txt
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --red --bold "Linking Fortran executable ../bin/maxi"
	cd /home/beomjoon/Documents/Github/drake-distro/snopt/pod-build/examples && $(CMAKE_COMMAND) -E cmake_link_script CMakeFiles/maxi.dir/link.txt --verbose=$(VERBOSE)

# Rule to build all files generated by this target.
examples/CMakeFiles/maxi.dir/build: bin/maxi
.PHONY : examples/CMakeFiles/maxi.dir/build

examples/CMakeFiles/maxi.dir/requires: examples/CMakeFiles/maxi.dir/maxi.f.o.requires
.PHONY : examples/CMakeFiles/maxi.dir/requires

examples/CMakeFiles/maxi.dir/clean:
	cd /home/beomjoon/Documents/Github/drake-distro/snopt/pod-build/examples && $(CMAKE_COMMAND) -P CMakeFiles/maxi.dir/cmake_clean.cmake
.PHONY : examples/CMakeFiles/maxi.dir/clean

examples/CMakeFiles/maxi.dir/depend:
	cd /home/beomjoon/Documents/Github/drake-distro/snopt/pod-build && $(CMAKE_COMMAND) -E cmake_depends "Unix Makefiles" /home/beomjoon/Documents/Github/drake-distro/snopt /home/beomjoon/Documents/Github/drake-distro/snopt/examples /home/beomjoon/Documents/Github/drake-distro/snopt/pod-build /home/beomjoon/Documents/Github/drake-distro/snopt/pod-build/examples /home/beomjoon/Documents/Github/drake-distro/snopt/pod-build/examples/CMakeFiles/maxi.dir/DependInfo.cmake --color=$(COLOR)
.PHONY : examples/CMakeFiles/maxi.dir/depend
