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
include examples/CMakeFiles/t1dieta.dir/depend.make

# Include the progress variables for this target.
include examples/CMakeFiles/t1dieta.dir/progress.make

# Include the compile flags for this target's objects.
include examples/CMakeFiles/t1dieta.dir/flags.make

examples/CMakeFiles/t1dieta.dir/t1dieta.f.o: examples/CMakeFiles/t1dieta.dir/flags.make
examples/CMakeFiles/t1dieta.dir/t1dieta.f.o: ../examples/t1dieta.f
	$(CMAKE_COMMAND) -E cmake_progress_report /home/beomjoon/Documents/Github/drake-distro/snopt/pod-build/CMakeFiles $(CMAKE_PROGRESS_1)
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Building Fortran object examples/CMakeFiles/t1dieta.dir/t1dieta.f.o"
	cd /home/beomjoon/Documents/Github/drake-distro/snopt/pod-build/examples && /usr/bin/gfortran  $(Fortran_DEFINES) $(Fortran_FLAGS) -c /home/beomjoon/Documents/Github/drake-distro/snopt/examples/t1dieta.f -o CMakeFiles/t1dieta.dir/t1dieta.f.o

examples/CMakeFiles/t1dieta.dir/t1dieta.f.o.requires:
.PHONY : examples/CMakeFiles/t1dieta.dir/t1dieta.f.o.requires

examples/CMakeFiles/t1dieta.dir/t1dieta.f.o.provides: examples/CMakeFiles/t1dieta.dir/t1dieta.f.o.requires
	$(MAKE) -f examples/CMakeFiles/t1dieta.dir/build.make examples/CMakeFiles/t1dieta.dir/t1dieta.f.o.provides.build
.PHONY : examples/CMakeFiles/t1dieta.dir/t1dieta.f.o.provides

examples/CMakeFiles/t1dieta.dir/t1dieta.f.o.provides.build: examples/CMakeFiles/t1dieta.dir/t1dieta.f.o

# Object files for target t1dieta
t1dieta_OBJECTS = \
"CMakeFiles/t1dieta.dir/t1dieta.f.o"

# External object files for target t1dieta
t1dieta_EXTERNAL_OBJECTS =

bin/t1dieta: examples/CMakeFiles/t1dieta.dir/t1dieta.f.o
bin/t1dieta: examples/CMakeFiles/t1dieta.dir/build.make
bin/t1dieta: lib/libsnopt.a
bin/t1dieta: lib/libsnprint.a
bin/t1dieta: lib/libsnblas.a
bin/t1dieta: examples/CMakeFiles/t1dieta.dir/link.txt
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --red --bold "Linking Fortran executable ../bin/t1dieta"
	cd /home/beomjoon/Documents/Github/drake-distro/snopt/pod-build/examples && $(CMAKE_COMMAND) -E cmake_link_script CMakeFiles/t1dieta.dir/link.txt --verbose=$(VERBOSE)

# Rule to build all files generated by this target.
examples/CMakeFiles/t1dieta.dir/build: bin/t1dieta
.PHONY : examples/CMakeFiles/t1dieta.dir/build

examples/CMakeFiles/t1dieta.dir/requires: examples/CMakeFiles/t1dieta.dir/t1dieta.f.o.requires
.PHONY : examples/CMakeFiles/t1dieta.dir/requires

examples/CMakeFiles/t1dieta.dir/clean:
	cd /home/beomjoon/Documents/Github/drake-distro/snopt/pod-build/examples && $(CMAKE_COMMAND) -P CMakeFiles/t1dieta.dir/cmake_clean.cmake
.PHONY : examples/CMakeFiles/t1dieta.dir/clean

examples/CMakeFiles/t1dieta.dir/depend:
	cd /home/beomjoon/Documents/Github/drake-distro/snopt/pod-build && $(CMAKE_COMMAND) -E cmake_depends "Unix Makefiles" /home/beomjoon/Documents/Github/drake-distro/snopt /home/beomjoon/Documents/Github/drake-distro/snopt/examples /home/beomjoon/Documents/Github/drake-distro/snopt/pod-build /home/beomjoon/Documents/Github/drake-distro/snopt/pod-build/examples /home/beomjoon/Documents/Github/drake-distro/snopt/pod-build/examples/CMakeFiles/t1dieta.dir/DependInfo.cmake --color=$(COLOR)
.PHONY : examples/CMakeFiles/t1dieta.dir/depend
