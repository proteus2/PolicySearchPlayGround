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
include examples/CMakeFiles/t5weapon.dir/depend.make

# Include the progress variables for this target.
include examples/CMakeFiles/t5weapon.dir/progress.make

# Include the compile flags for this target's objects.
include examples/CMakeFiles/t5weapon.dir/flags.make

examples/CMakeFiles/t5weapon.dir/t5weapon.f.o: examples/CMakeFiles/t5weapon.dir/flags.make
examples/CMakeFiles/t5weapon.dir/t5weapon.f.o: ../examples/t5weapon.f
	$(CMAKE_COMMAND) -E cmake_progress_report /home/beomjoon/Documents/Github/drake-distro/snopt/pod-build/CMakeFiles $(CMAKE_PROGRESS_1)
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Building Fortran object examples/CMakeFiles/t5weapon.dir/t5weapon.f.o"
	cd /home/beomjoon/Documents/Github/drake-distro/snopt/pod-build/examples && /usr/bin/gfortran  $(Fortran_DEFINES) $(Fortran_FLAGS) -c /home/beomjoon/Documents/Github/drake-distro/snopt/examples/t5weapon.f -o CMakeFiles/t5weapon.dir/t5weapon.f.o

examples/CMakeFiles/t5weapon.dir/t5weapon.f.o.requires:
.PHONY : examples/CMakeFiles/t5weapon.dir/t5weapon.f.o.requires

examples/CMakeFiles/t5weapon.dir/t5weapon.f.o.provides: examples/CMakeFiles/t5weapon.dir/t5weapon.f.o.requires
	$(MAKE) -f examples/CMakeFiles/t5weapon.dir/build.make examples/CMakeFiles/t5weapon.dir/t5weapon.f.o.provides.build
.PHONY : examples/CMakeFiles/t5weapon.dir/t5weapon.f.o.provides

examples/CMakeFiles/t5weapon.dir/t5weapon.f.o.provides.build: examples/CMakeFiles/t5weapon.dir/t5weapon.f.o

# Object files for target t5weapon
t5weapon_OBJECTS = \
"CMakeFiles/t5weapon.dir/t5weapon.f.o"

# External object files for target t5weapon
t5weapon_EXTERNAL_OBJECTS =

bin/t5weapon: examples/CMakeFiles/t5weapon.dir/t5weapon.f.o
bin/t5weapon: examples/CMakeFiles/t5weapon.dir/build.make
bin/t5weapon: lib/libsnopt.a
bin/t5weapon: lib/libsnprint.a
bin/t5weapon: lib/libsnblas.a
bin/t5weapon: examples/CMakeFiles/t5weapon.dir/link.txt
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --red --bold "Linking Fortran executable ../bin/t5weapon"
	cd /home/beomjoon/Documents/Github/drake-distro/snopt/pod-build/examples && $(CMAKE_COMMAND) -E cmake_link_script CMakeFiles/t5weapon.dir/link.txt --verbose=$(VERBOSE)

# Rule to build all files generated by this target.
examples/CMakeFiles/t5weapon.dir/build: bin/t5weapon
.PHONY : examples/CMakeFiles/t5weapon.dir/build

examples/CMakeFiles/t5weapon.dir/requires: examples/CMakeFiles/t5weapon.dir/t5weapon.f.o.requires
.PHONY : examples/CMakeFiles/t5weapon.dir/requires

examples/CMakeFiles/t5weapon.dir/clean:
	cd /home/beomjoon/Documents/Github/drake-distro/snopt/pod-build/examples && $(CMAKE_COMMAND) -P CMakeFiles/t5weapon.dir/cmake_clean.cmake
.PHONY : examples/CMakeFiles/t5weapon.dir/clean

examples/CMakeFiles/t5weapon.dir/depend:
	cd /home/beomjoon/Documents/Github/drake-distro/snopt/pod-build && $(CMAKE_COMMAND) -E cmake_depends "Unix Makefiles" /home/beomjoon/Documents/Github/drake-distro/snopt /home/beomjoon/Documents/Github/drake-distro/snopt/examples /home/beomjoon/Documents/Github/drake-distro/snopt/pod-build /home/beomjoon/Documents/Github/drake-distro/snopt/pod-build/examples /home/beomjoon/Documents/Github/drake-distro/snopt/pod-build/examples/CMakeFiles/t5weapon.dir/DependInfo.cmake --color=$(COLOR)
.PHONY : examples/CMakeFiles/t5weapon.dir/depend

