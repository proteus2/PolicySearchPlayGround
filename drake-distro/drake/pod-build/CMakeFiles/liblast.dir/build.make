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
CMAKE_SOURCE_DIR = /home/beomjoon/Documents/Github/drake-distro/drake

# The top-level build directory on which CMake was run.
CMAKE_BINARY_DIR = /home/beomjoon/Documents/Github/drake-distro/drake/pod-build

# Include any dependencies generated for this target.
include CMakeFiles/liblast.dir/depend.make

# Include the progress variables for this target.
include CMakeFiles/liblast.dir/progress.make

# Include the compile flags for this target's objects.
include CMakeFiles/liblast.dir/flags.make

dummy.c:
	$(CMAKE_COMMAND) -E cmake_progress_report /home/beomjoon/Documents/Github/drake-distro/drake/pod-build/CMakeFiles $(CMAKE_PROGRESS_1)
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --blue --bold "Generating dummy.c"
	/usr/bin/cmake -E touch /home/beomjoon/Documents/Github/drake-distro/drake/pod-build/dummy.c

CMakeFiles/liblast.dir/dummy.c.o: CMakeFiles/liblast.dir/flags.make
CMakeFiles/liblast.dir/dummy.c.o: dummy.c
	$(CMAKE_COMMAND) -E cmake_progress_report /home/beomjoon/Documents/Github/drake-distro/drake/pod-build/CMakeFiles $(CMAKE_PROGRESS_2)
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Building C object CMakeFiles/liblast.dir/dummy.c.o"
	/usr/bin/cc  $(C_DEFINES) $(C_FLAGS) -o CMakeFiles/liblast.dir/dummy.c.o   -c /home/beomjoon/Documents/Github/drake-distro/drake/pod-build/dummy.c

CMakeFiles/liblast.dir/dummy.c.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing C source to CMakeFiles/liblast.dir/dummy.c.i"
	/usr/bin/cc  $(C_DEFINES) $(C_FLAGS) -E /home/beomjoon/Documents/Github/drake-distro/drake/pod-build/dummy.c > CMakeFiles/liblast.dir/dummy.c.i

CMakeFiles/liblast.dir/dummy.c.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling C source to assembly CMakeFiles/liblast.dir/dummy.c.s"
	/usr/bin/cc  $(C_DEFINES) $(C_FLAGS) -S /home/beomjoon/Documents/Github/drake-distro/drake/pod-build/dummy.c -o CMakeFiles/liblast.dir/dummy.c.s

CMakeFiles/liblast.dir/dummy.c.o.requires:
.PHONY : CMakeFiles/liblast.dir/dummy.c.o.requires

CMakeFiles/liblast.dir/dummy.c.o.provides: CMakeFiles/liblast.dir/dummy.c.o.requires
	$(MAKE) -f CMakeFiles/liblast.dir/build.make CMakeFiles/liblast.dir/dummy.c.o.provides.build
.PHONY : CMakeFiles/liblast.dir/dummy.c.o.provides

CMakeFiles/liblast.dir/dummy.c.o.provides.build: CMakeFiles/liblast.dir/dummy.c.o

# Object files for target liblast
liblast_OBJECTS = \
"CMakeFiles/liblast.dir/dummy.c.o"

# External object files for target liblast
liblast_EXTERNAL_OBJECTS =

lib/libliblast.a: CMakeFiles/liblast.dir/dummy.c.o
lib/libliblast.a: CMakeFiles/liblast.dir/build.make
lib/libliblast.a: CMakeFiles/liblast.dir/link.txt
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --red --bold "Linking C static library lib/libliblast.a"
	$(CMAKE_COMMAND) -P CMakeFiles/liblast.dir/cmake_clean_target.cmake
	$(CMAKE_COMMAND) -E cmake_link_script CMakeFiles/liblast.dir/link.txt --verbose=$(VERBOSE)

# Rule to build all files generated by this target.
CMakeFiles/liblast.dir/build: lib/libliblast.a
.PHONY : CMakeFiles/liblast.dir/build

CMakeFiles/liblast.dir/requires: CMakeFiles/liblast.dir/dummy.c.o.requires
.PHONY : CMakeFiles/liblast.dir/requires

CMakeFiles/liblast.dir/clean:
	$(CMAKE_COMMAND) -P CMakeFiles/liblast.dir/cmake_clean.cmake
.PHONY : CMakeFiles/liblast.dir/clean

CMakeFiles/liblast.dir/depend: dummy.c
	cd /home/beomjoon/Documents/Github/drake-distro/drake/pod-build && $(CMAKE_COMMAND) -E cmake_depends "Unix Makefiles" /home/beomjoon/Documents/Github/drake-distro/drake /home/beomjoon/Documents/Github/drake-distro/drake /home/beomjoon/Documents/Github/drake-distro/drake/pod-build /home/beomjoon/Documents/Github/drake-distro/drake/pod-build /home/beomjoon/Documents/Github/drake-distro/drake/pod-build/CMakeFiles/liblast.dir/DependInfo.cmake --color=$(COLOR)
.PHONY : CMakeFiles/liblast.dir/depend
