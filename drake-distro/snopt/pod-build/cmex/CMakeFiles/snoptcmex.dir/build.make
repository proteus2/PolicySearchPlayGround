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
include cmex/CMakeFiles/snoptcmex.dir/depend.make

# Include the progress variables for this target.
include cmex/CMakeFiles/snoptcmex.dir/progress.make

# Include the compile flags for this target's objects.
include cmex/CMakeFiles/snoptcmex.dir/flags.make

cmex/CMakeFiles/snoptcmex.dir/snoptcmex.c.o: cmex/CMakeFiles/snoptcmex.dir/flags.make
cmex/CMakeFiles/snoptcmex.dir/snoptcmex.c.o: ../cmex/snoptcmex.c
	$(CMAKE_COMMAND) -E cmake_progress_report /home/beomjoon/Documents/Github/drake-distro/snopt/pod-build/CMakeFiles $(CMAKE_PROGRESS_1)
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Building C object cmex/CMakeFiles/snoptcmex.dir/snoptcmex.c.o"
	cd /home/beomjoon/Documents/Github/drake-distro/snopt/pod-build/cmex && /usr/bin/cc  $(C_DEFINES) $(C_FLAGS) -o CMakeFiles/snoptcmex.dir/snoptcmex.c.o   -c /home/beomjoon/Documents/Github/drake-distro/snopt/cmex/snoptcmex.c

cmex/CMakeFiles/snoptcmex.dir/snoptcmex.c.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing C source to CMakeFiles/snoptcmex.dir/snoptcmex.c.i"
	cd /home/beomjoon/Documents/Github/drake-distro/snopt/pod-build/cmex && /usr/bin/cc  $(C_DEFINES) $(C_FLAGS) -E /home/beomjoon/Documents/Github/drake-distro/snopt/cmex/snoptcmex.c > CMakeFiles/snoptcmex.dir/snoptcmex.c.i

cmex/CMakeFiles/snoptcmex.dir/snoptcmex.c.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling C source to assembly CMakeFiles/snoptcmex.dir/snoptcmex.c.s"
	cd /home/beomjoon/Documents/Github/drake-distro/snopt/pod-build/cmex && /usr/bin/cc  $(C_DEFINES) $(C_FLAGS) -S /home/beomjoon/Documents/Github/drake-distro/snopt/cmex/snoptcmex.c -o CMakeFiles/snoptcmex.dir/snoptcmex.c.s

cmex/CMakeFiles/snoptcmex.dir/snoptcmex.c.o.requires:
.PHONY : cmex/CMakeFiles/snoptcmex.dir/snoptcmex.c.o.requires

cmex/CMakeFiles/snoptcmex.dir/snoptcmex.c.o.provides: cmex/CMakeFiles/snoptcmex.dir/snoptcmex.c.o.requires
	$(MAKE) -f cmex/CMakeFiles/snoptcmex.dir/build.make cmex/CMakeFiles/snoptcmex.dir/snoptcmex.c.o.provides.build
.PHONY : cmex/CMakeFiles/snoptcmex.dir/snoptcmex.c.o.provides

cmex/CMakeFiles/snoptcmex.dir/snoptcmex.c.o.provides.build: cmex/CMakeFiles/snoptcmex.dir/snoptcmex.c.o

cmex/CMakeFiles/snoptcmex.dir/mexUtility.c.o: cmex/CMakeFiles/snoptcmex.dir/flags.make
cmex/CMakeFiles/snoptcmex.dir/mexUtility.c.o: ../cmex/mexUtility.c
	$(CMAKE_COMMAND) -E cmake_progress_report /home/beomjoon/Documents/Github/drake-distro/snopt/pod-build/CMakeFiles $(CMAKE_PROGRESS_2)
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Building C object cmex/CMakeFiles/snoptcmex.dir/mexUtility.c.o"
	cd /home/beomjoon/Documents/Github/drake-distro/snopt/pod-build/cmex && /usr/bin/cc  $(C_DEFINES) $(C_FLAGS) -o CMakeFiles/snoptcmex.dir/mexUtility.c.o   -c /home/beomjoon/Documents/Github/drake-distro/snopt/cmex/mexUtility.c

cmex/CMakeFiles/snoptcmex.dir/mexUtility.c.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing C source to CMakeFiles/snoptcmex.dir/mexUtility.c.i"
	cd /home/beomjoon/Documents/Github/drake-distro/snopt/pod-build/cmex && /usr/bin/cc  $(C_DEFINES) $(C_FLAGS) -E /home/beomjoon/Documents/Github/drake-distro/snopt/cmex/mexUtility.c > CMakeFiles/snoptcmex.dir/mexUtility.c.i

cmex/CMakeFiles/snoptcmex.dir/mexUtility.c.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling C source to assembly CMakeFiles/snoptcmex.dir/mexUtility.c.s"
	cd /home/beomjoon/Documents/Github/drake-distro/snopt/pod-build/cmex && /usr/bin/cc  $(C_DEFINES) $(C_FLAGS) -S /home/beomjoon/Documents/Github/drake-distro/snopt/cmex/mexUtility.c -o CMakeFiles/snoptcmex.dir/mexUtility.c.s

cmex/CMakeFiles/snoptcmex.dir/mexUtility.c.o.requires:
.PHONY : cmex/CMakeFiles/snoptcmex.dir/mexUtility.c.o.requires

cmex/CMakeFiles/snoptcmex.dir/mexUtility.c.o.provides: cmex/CMakeFiles/snoptcmex.dir/mexUtility.c.o.requires
	$(MAKE) -f cmex/CMakeFiles/snoptcmex.dir/build.make cmex/CMakeFiles/snoptcmex.dir/mexUtility.c.o.provides.build
.PHONY : cmex/CMakeFiles/snoptcmex.dir/mexUtility.c.o.provides

cmex/CMakeFiles/snoptcmex.dir/mexUtility.c.o.provides.build: cmex/CMakeFiles/snoptcmex.dir/mexUtility.c.o

cmex/CMakeFiles/snoptcmex.dir/snoptprobdef.c.o: cmex/CMakeFiles/snoptcmex.dir/flags.make
cmex/CMakeFiles/snoptcmex.dir/snoptprobdef.c.o: ../cmex/snoptprobdef.c
	$(CMAKE_COMMAND) -E cmake_progress_report /home/beomjoon/Documents/Github/drake-distro/snopt/pod-build/CMakeFiles $(CMAKE_PROGRESS_3)
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Building C object cmex/CMakeFiles/snoptcmex.dir/snoptprobdef.c.o"
	cd /home/beomjoon/Documents/Github/drake-distro/snopt/pod-build/cmex && /usr/bin/cc  $(C_DEFINES) $(C_FLAGS) -o CMakeFiles/snoptcmex.dir/snoptprobdef.c.o   -c /home/beomjoon/Documents/Github/drake-distro/snopt/cmex/snoptprobdef.c

cmex/CMakeFiles/snoptcmex.dir/snoptprobdef.c.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing C source to CMakeFiles/snoptcmex.dir/snoptprobdef.c.i"
	cd /home/beomjoon/Documents/Github/drake-distro/snopt/pod-build/cmex && /usr/bin/cc  $(C_DEFINES) $(C_FLAGS) -E /home/beomjoon/Documents/Github/drake-distro/snopt/cmex/snoptprobdef.c > CMakeFiles/snoptcmex.dir/snoptprobdef.c.i

cmex/CMakeFiles/snoptcmex.dir/snoptprobdef.c.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling C source to assembly CMakeFiles/snoptcmex.dir/snoptprobdef.c.s"
	cd /home/beomjoon/Documents/Github/drake-distro/snopt/pod-build/cmex && /usr/bin/cc  $(C_DEFINES) $(C_FLAGS) -S /home/beomjoon/Documents/Github/drake-distro/snopt/cmex/snoptprobdef.c -o CMakeFiles/snoptcmex.dir/snoptprobdef.c.s

cmex/CMakeFiles/snoptcmex.dir/snoptprobdef.c.o.requires:
.PHONY : cmex/CMakeFiles/snoptcmex.dir/snoptprobdef.c.o.requires

cmex/CMakeFiles/snoptcmex.dir/snoptprobdef.c.o.provides: cmex/CMakeFiles/snoptcmex.dir/snoptprobdef.c.o.requires
	$(MAKE) -f cmex/CMakeFiles/snoptcmex.dir/build.make cmex/CMakeFiles/snoptcmex.dir/snoptprobdef.c.o.provides.build
.PHONY : cmex/CMakeFiles/snoptcmex.dir/snoptprobdef.c.o.provides

cmex/CMakeFiles/snoptcmex.dir/snoptprobdef.c.o.provides.build: cmex/CMakeFiles/snoptcmex.dir/snoptprobdef.c.o

cmex/CMakeFiles/snoptcmex.dir/snoptprint.c.o: cmex/CMakeFiles/snoptcmex.dir/flags.make
cmex/CMakeFiles/snoptcmex.dir/snoptprint.c.o: ../cmex/snoptprint.c
	$(CMAKE_COMMAND) -E cmake_progress_report /home/beomjoon/Documents/Github/drake-distro/snopt/pod-build/CMakeFiles $(CMAKE_PROGRESS_4)
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Building C object cmex/CMakeFiles/snoptcmex.dir/snoptprint.c.o"
	cd /home/beomjoon/Documents/Github/drake-distro/snopt/pod-build/cmex && /usr/bin/cc  $(C_DEFINES) $(C_FLAGS) -o CMakeFiles/snoptcmex.dir/snoptprint.c.o   -c /home/beomjoon/Documents/Github/drake-distro/snopt/cmex/snoptprint.c

cmex/CMakeFiles/snoptcmex.dir/snoptprint.c.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing C source to CMakeFiles/snoptcmex.dir/snoptprint.c.i"
	cd /home/beomjoon/Documents/Github/drake-distro/snopt/pod-build/cmex && /usr/bin/cc  $(C_DEFINES) $(C_FLAGS) -E /home/beomjoon/Documents/Github/drake-distro/snopt/cmex/snoptprint.c > CMakeFiles/snoptcmex.dir/snoptprint.c.i

cmex/CMakeFiles/snoptcmex.dir/snoptprint.c.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling C source to assembly CMakeFiles/snoptcmex.dir/snoptprint.c.s"
	cd /home/beomjoon/Documents/Github/drake-distro/snopt/pod-build/cmex && /usr/bin/cc  $(C_DEFINES) $(C_FLAGS) -S /home/beomjoon/Documents/Github/drake-distro/snopt/cmex/snoptprint.c -o CMakeFiles/snoptcmex.dir/snoptprint.c.s

cmex/CMakeFiles/snoptcmex.dir/snoptprint.c.o.requires:
.PHONY : cmex/CMakeFiles/snoptcmex.dir/snoptprint.c.o.requires

cmex/CMakeFiles/snoptcmex.dir/snoptprint.c.o.provides: cmex/CMakeFiles/snoptcmex.dir/snoptprint.c.o.requires
	$(MAKE) -f cmex/CMakeFiles/snoptcmex.dir/build.make cmex/CMakeFiles/snoptcmex.dir/snoptprint.c.o.provides.build
.PHONY : cmex/CMakeFiles/snoptcmex.dir/snoptprint.c.o.provides

cmex/CMakeFiles/snoptcmex.dir/snoptprint.c.o.provides.build: cmex/CMakeFiles/snoptcmex.dir/snoptprint.c.o

cmex/CMakeFiles/snoptcmex.dir/sncmexlog.c.o: cmex/CMakeFiles/snoptcmex.dir/flags.make
cmex/CMakeFiles/snoptcmex.dir/sncmexlog.c.o: ../cmex/sncmexlog.c
	$(CMAKE_COMMAND) -E cmake_progress_report /home/beomjoon/Documents/Github/drake-distro/snopt/pod-build/CMakeFiles $(CMAKE_PROGRESS_5)
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Building C object cmex/CMakeFiles/snoptcmex.dir/sncmexlog.c.o"
	cd /home/beomjoon/Documents/Github/drake-distro/snopt/pod-build/cmex && /usr/bin/cc  $(C_DEFINES) $(C_FLAGS) -o CMakeFiles/snoptcmex.dir/sncmexlog.c.o   -c /home/beomjoon/Documents/Github/drake-distro/snopt/cmex/sncmexlog.c

cmex/CMakeFiles/snoptcmex.dir/sncmexlog.c.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing C source to CMakeFiles/snoptcmex.dir/sncmexlog.c.i"
	cd /home/beomjoon/Documents/Github/drake-distro/snopt/pod-build/cmex && /usr/bin/cc  $(C_DEFINES) $(C_FLAGS) -E /home/beomjoon/Documents/Github/drake-distro/snopt/cmex/sncmexlog.c > CMakeFiles/snoptcmex.dir/sncmexlog.c.i

cmex/CMakeFiles/snoptcmex.dir/sncmexlog.c.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling C source to assembly CMakeFiles/snoptcmex.dir/sncmexlog.c.s"
	cd /home/beomjoon/Documents/Github/drake-distro/snopt/pod-build/cmex && /usr/bin/cc  $(C_DEFINES) $(C_FLAGS) -S /home/beomjoon/Documents/Github/drake-distro/snopt/cmex/sncmexlog.c -o CMakeFiles/snoptcmex.dir/sncmexlog.c.s

cmex/CMakeFiles/snoptcmex.dir/sncmexlog.c.o.requires:
.PHONY : cmex/CMakeFiles/snoptcmex.dir/sncmexlog.c.o.requires

cmex/CMakeFiles/snoptcmex.dir/sncmexlog.c.o.provides: cmex/CMakeFiles/snoptcmex.dir/sncmexlog.c.o.requires
	$(MAKE) -f cmex/CMakeFiles/snoptcmex.dir/build.make cmex/CMakeFiles/snoptcmex.dir/sncmexlog.c.o.provides.build
.PHONY : cmex/CMakeFiles/snoptcmex.dir/sncmexlog.c.o.provides

cmex/CMakeFiles/snoptcmex.dir/sncmexlog.c.o.provides.build: cmex/CMakeFiles/snoptcmex.dir/sncmexlog.c.o

# Object files for target snoptcmex
snoptcmex_OBJECTS = \
"CMakeFiles/snoptcmex.dir/snoptcmex.c.o" \
"CMakeFiles/snoptcmex.dir/mexUtility.c.o" \
"CMakeFiles/snoptcmex.dir/snoptprobdef.c.o" \
"CMakeFiles/snoptcmex.dir/snoptprint.c.o" \
"CMakeFiles/snoptcmex.dir/sncmexlog.c.o"

# External object files for target snoptcmex
snoptcmex_EXTERNAL_OBJECTS =

../matlab/snoptcmex.mexa64: cmex/CMakeFiles/snoptcmex.dir/snoptcmex.c.o
../matlab/snoptcmex.mexa64: cmex/CMakeFiles/snoptcmex.dir/mexUtility.c.o
../matlab/snoptcmex.mexa64: cmex/CMakeFiles/snoptcmex.dir/snoptprobdef.c.o
../matlab/snoptcmex.mexa64: cmex/CMakeFiles/snoptcmex.dir/snoptprint.c.o
../matlab/snoptcmex.mexa64: cmex/CMakeFiles/snoptcmex.dir/sncmexlog.c.o
../matlab/snoptcmex.mexa64: cmex/CMakeFiles/snoptcmex.dir/build.make
../matlab/snoptcmex.mexa64: lib/libliblast.a
../matlab/snoptcmex.mexa64: lib/libsnopt_c.a
../matlab/snoptcmex.mexa64: lib/libf2c.a
../matlab/snoptcmex.mexa64: cmex/CMakeFiles/snoptcmex.dir/link.txt
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --red --bold "Linking C shared module ../../matlab/snoptcmex.mexa64"
	cd /home/beomjoon/Documents/Github/drake-distro/snopt/pod-build/cmex && $(CMAKE_COMMAND) -E cmake_link_script CMakeFiles/snoptcmex.dir/link.txt --verbose=$(VERBOSE)

# Rule to build all files generated by this target.
cmex/CMakeFiles/snoptcmex.dir/build: ../matlab/snoptcmex.mexa64
.PHONY : cmex/CMakeFiles/snoptcmex.dir/build

cmex/CMakeFiles/snoptcmex.dir/requires: cmex/CMakeFiles/snoptcmex.dir/snoptcmex.c.o.requires
cmex/CMakeFiles/snoptcmex.dir/requires: cmex/CMakeFiles/snoptcmex.dir/mexUtility.c.o.requires
cmex/CMakeFiles/snoptcmex.dir/requires: cmex/CMakeFiles/snoptcmex.dir/snoptprobdef.c.o.requires
cmex/CMakeFiles/snoptcmex.dir/requires: cmex/CMakeFiles/snoptcmex.dir/snoptprint.c.o.requires
cmex/CMakeFiles/snoptcmex.dir/requires: cmex/CMakeFiles/snoptcmex.dir/sncmexlog.c.o.requires
.PHONY : cmex/CMakeFiles/snoptcmex.dir/requires

cmex/CMakeFiles/snoptcmex.dir/clean:
	cd /home/beomjoon/Documents/Github/drake-distro/snopt/pod-build/cmex && $(CMAKE_COMMAND) -P CMakeFiles/snoptcmex.dir/cmake_clean.cmake
.PHONY : cmex/CMakeFiles/snoptcmex.dir/clean

cmex/CMakeFiles/snoptcmex.dir/depend:
	cd /home/beomjoon/Documents/Github/drake-distro/snopt/pod-build && $(CMAKE_COMMAND) -E cmake_depends "Unix Makefiles" /home/beomjoon/Documents/Github/drake-distro/snopt /home/beomjoon/Documents/Github/drake-distro/snopt/cmex /home/beomjoon/Documents/Github/drake-distro/snopt/pod-build /home/beomjoon/Documents/Github/drake-distro/snopt/pod-build/cmex /home/beomjoon/Documents/Github/drake-distro/snopt/pod-build/cmex/CMakeFiles/snoptcmex.dir/DependInfo.cmake --color=$(COLOR)
.PHONY : cmex/CMakeFiles/snoptcmex.dir/depend
