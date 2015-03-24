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
include src/CMakeFiles/snblas.dir/depend.make

# Include the progress variables for this target.
include src/CMakeFiles/snblas.dir/progress.make

# Include the compile flags for this target's objects.
include src/CMakeFiles/snblas.dir/flags.make

src/CMakeFiles/snblas.dir/sn15blas.f.o: src/CMakeFiles/snblas.dir/flags.make
src/CMakeFiles/snblas.dir/sn15blas.f.o: ../src/sn15blas.f
	$(CMAKE_COMMAND) -E cmake_progress_report /home/beomjoon/Documents/Github/drake-distro/snopt/pod-build/CMakeFiles $(CMAKE_PROGRESS_1)
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Building Fortran object src/CMakeFiles/snblas.dir/sn15blas.f.o"
	cd /home/beomjoon/Documents/Github/drake-distro/snopt/pod-build/src && /usr/bin/gfortran  $(Fortran_DEFINES) $(Fortran_FLAGS) -c /home/beomjoon/Documents/Github/drake-distro/snopt/src/sn15blas.f -o CMakeFiles/snblas.dir/sn15blas.f.o

src/CMakeFiles/snblas.dir/sn15blas.f.o.requires:
.PHONY : src/CMakeFiles/snblas.dir/sn15blas.f.o.requires

src/CMakeFiles/snblas.dir/sn15blas.f.o.provides: src/CMakeFiles/snblas.dir/sn15blas.f.o.requires
	$(MAKE) -f src/CMakeFiles/snblas.dir/build.make src/CMakeFiles/snblas.dir/sn15blas.f.o.provides.build
.PHONY : src/CMakeFiles/snblas.dir/sn15blas.f.o.provides

src/CMakeFiles/snblas.dir/sn15blas.f.o.provides.build: src/CMakeFiles/snblas.dir/sn15blas.f.o

# Object files for target snblas
snblas_OBJECTS = \
"CMakeFiles/snblas.dir/sn15blas.f.o"

# External object files for target snblas
snblas_EXTERNAL_OBJECTS =

lib/libsnblas.a: src/CMakeFiles/snblas.dir/sn15blas.f.o
lib/libsnblas.a: src/CMakeFiles/snblas.dir/build.make
lib/libsnblas.a: src/CMakeFiles/snblas.dir/link.txt
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --red --bold "Linking Fortran static library ../lib/libsnblas.a"
	cd /home/beomjoon/Documents/Github/drake-distro/snopt/pod-build/src && $(CMAKE_COMMAND) -P CMakeFiles/snblas.dir/cmake_clean_target.cmake
	cd /home/beomjoon/Documents/Github/drake-distro/snopt/pod-build/src && $(CMAKE_COMMAND) -E cmake_link_script CMakeFiles/snblas.dir/link.txt --verbose=$(VERBOSE)

# Rule to build all files generated by this target.
src/CMakeFiles/snblas.dir/build: lib/libsnblas.a
.PHONY : src/CMakeFiles/snblas.dir/build

src/CMakeFiles/snblas.dir/requires: src/CMakeFiles/snblas.dir/sn15blas.f.o.requires
.PHONY : src/CMakeFiles/snblas.dir/requires

src/CMakeFiles/snblas.dir/clean:
	cd /home/beomjoon/Documents/Github/drake-distro/snopt/pod-build/src && $(CMAKE_COMMAND) -P CMakeFiles/snblas.dir/cmake_clean.cmake
.PHONY : src/CMakeFiles/snblas.dir/clean

src/CMakeFiles/snblas.dir/depend:
	cd /home/beomjoon/Documents/Github/drake-distro/snopt/pod-build && $(CMAKE_COMMAND) -E cmake_depends "Unix Makefiles" /home/beomjoon/Documents/Github/drake-distro/snopt /home/beomjoon/Documents/Github/drake-distro/snopt/src /home/beomjoon/Documents/Github/drake-distro/snopt/pod-build /home/beomjoon/Documents/Github/drake-distro/snopt/pod-build/src /home/beomjoon/Documents/Github/drake-distro/snopt/pod-build/src/CMakeFiles/snblas.dir/DependInfo.cmake --color=$(COLOR)
.PHONY : src/CMakeFiles/snblas.dir/depend
