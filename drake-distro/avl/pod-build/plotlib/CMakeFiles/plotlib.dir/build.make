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
include plotlib/CMakeFiles/plotlib.dir/depend.make

# Include the progress variables for this target.
include plotlib/CMakeFiles/plotlib.dir/progress.make

# Include the compile flags for this target's objects.
include plotlib/CMakeFiles/plotlib.dir/flags.make

plotlib/CMakeFiles/plotlib.dir/plt_base.f.o: plotlib/CMakeFiles/plotlib.dir/flags.make
plotlib/CMakeFiles/plotlib.dir/plt_base.f.o: ../plotlib/plt_base.f
	$(CMAKE_COMMAND) -E cmake_progress_report /home/beomjoon/Documents/Github/drake-distro/avl/pod-build/CMakeFiles $(CMAKE_PROGRESS_1)
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Building Fortran object plotlib/CMakeFiles/plotlib.dir/plt_base.f.o"
	cd /home/beomjoon/Documents/Github/drake-distro/avl/pod-build/plotlib && /usr/bin/gfortran  $(Fortran_DEFINES) $(Fortran_FLAGS) -c /home/beomjoon/Documents/Github/drake-distro/avl/plotlib/plt_base.f -o CMakeFiles/plotlib.dir/plt_base.f.o

plotlib/CMakeFiles/plotlib.dir/plt_base.f.o.requires:
.PHONY : plotlib/CMakeFiles/plotlib.dir/plt_base.f.o.requires

plotlib/CMakeFiles/plotlib.dir/plt_base.f.o.provides: plotlib/CMakeFiles/plotlib.dir/plt_base.f.o.requires
	$(MAKE) -f plotlib/CMakeFiles/plotlib.dir/build.make plotlib/CMakeFiles/plotlib.dir/plt_base.f.o.provides.build
.PHONY : plotlib/CMakeFiles/plotlib.dir/plt_base.f.o.provides

plotlib/CMakeFiles/plotlib.dir/plt_base.f.o.provides.build: plotlib/CMakeFiles/plotlib.dir/plt_base.f.o

plotlib/CMakeFiles/plotlib.dir/plt_font.f.o: plotlib/CMakeFiles/plotlib.dir/flags.make
plotlib/CMakeFiles/plotlib.dir/plt_font.f.o: ../plotlib/plt_font.f
	$(CMAKE_COMMAND) -E cmake_progress_report /home/beomjoon/Documents/Github/drake-distro/avl/pod-build/CMakeFiles $(CMAKE_PROGRESS_2)
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Building Fortran object plotlib/CMakeFiles/plotlib.dir/plt_font.f.o"
	cd /home/beomjoon/Documents/Github/drake-distro/avl/pod-build/plotlib && /usr/bin/gfortran  $(Fortran_DEFINES) $(Fortran_FLAGS) -c /home/beomjoon/Documents/Github/drake-distro/avl/plotlib/plt_font.f -o CMakeFiles/plotlib.dir/plt_font.f.o

plotlib/CMakeFiles/plotlib.dir/plt_font.f.o.requires:
.PHONY : plotlib/CMakeFiles/plotlib.dir/plt_font.f.o.requires

plotlib/CMakeFiles/plotlib.dir/plt_font.f.o.provides: plotlib/CMakeFiles/plotlib.dir/plt_font.f.o.requires
	$(MAKE) -f plotlib/CMakeFiles/plotlib.dir/build.make plotlib/CMakeFiles/plotlib.dir/plt_font.f.o.provides.build
.PHONY : plotlib/CMakeFiles/plotlib.dir/plt_font.f.o.provides

plotlib/CMakeFiles/plotlib.dir/plt_font.f.o.provides.build: plotlib/CMakeFiles/plotlib.dir/plt_font.f.o

plotlib/CMakeFiles/plotlib.dir/plt_util.f.o: plotlib/CMakeFiles/plotlib.dir/flags.make
plotlib/CMakeFiles/plotlib.dir/plt_util.f.o: ../plotlib/plt_util.f
	$(CMAKE_COMMAND) -E cmake_progress_report /home/beomjoon/Documents/Github/drake-distro/avl/pod-build/CMakeFiles $(CMAKE_PROGRESS_3)
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Building Fortran object plotlib/CMakeFiles/plotlib.dir/plt_util.f.o"
	cd /home/beomjoon/Documents/Github/drake-distro/avl/pod-build/plotlib && /usr/bin/gfortran  $(Fortran_DEFINES) $(Fortran_FLAGS) -c /home/beomjoon/Documents/Github/drake-distro/avl/plotlib/plt_util.f -o CMakeFiles/plotlib.dir/plt_util.f.o

plotlib/CMakeFiles/plotlib.dir/plt_util.f.o.requires:
.PHONY : plotlib/CMakeFiles/plotlib.dir/plt_util.f.o.requires

plotlib/CMakeFiles/plotlib.dir/plt_util.f.o.provides: plotlib/CMakeFiles/plotlib.dir/plt_util.f.o.requires
	$(MAKE) -f plotlib/CMakeFiles/plotlib.dir/build.make plotlib/CMakeFiles/plotlib.dir/plt_util.f.o.provides.build
.PHONY : plotlib/CMakeFiles/plotlib.dir/plt_util.f.o.provides

plotlib/CMakeFiles/plotlib.dir/plt_util.f.o.provides.build: plotlib/CMakeFiles/plotlib.dir/plt_util.f.o

plotlib/CMakeFiles/plotlib.dir/plt_color.f.o: plotlib/CMakeFiles/plotlib.dir/flags.make
plotlib/CMakeFiles/plotlib.dir/plt_color.f.o: ../plotlib/plt_color.f
	$(CMAKE_COMMAND) -E cmake_progress_report /home/beomjoon/Documents/Github/drake-distro/avl/pod-build/CMakeFiles $(CMAKE_PROGRESS_4)
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Building Fortran object plotlib/CMakeFiles/plotlib.dir/plt_color.f.o"
	cd /home/beomjoon/Documents/Github/drake-distro/avl/pod-build/plotlib && /usr/bin/gfortran  $(Fortran_DEFINES) $(Fortran_FLAGS) -c /home/beomjoon/Documents/Github/drake-distro/avl/plotlib/plt_color.f -o CMakeFiles/plotlib.dir/plt_color.f.o

plotlib/CMakeFiles/plotlib.dir/plt_color.f.o.requires:
.PHONY : plotlib/CMakeFiles/plotlib.dir/plt_color.f.o.requires

plotlib/CMakeFiles/plotlib.dir/plt_color.f.o.provides: plotlib/CMakeFiles/plotlib.dir/plt_color.f.o.requires
	$(MAKE) -f plotlib/CMakeFiles/plotlib.dir/build.make plotlib/CMakeFiles/plotlib.dir/plt_color.f.o.provides.build
.PHONY : plotlib/CMakeFiles/plotlib.dir/plt_color.f.o.provides

plotlib/CMakeFiles/plotlib.dir/plt_color.f.o.provides.build: plotlib/CMakeFiles/plotlib.dir/plt_color.f.o

plotlib/CMakeFiles/plotlib.dir/set_subs.f.o: plotlib/CMakeFiles/plotlib.dir/flags.make
plotlib/CMakeFiles/plotlib.dir/set_subs.f.o: ../plotlib/set_subs.f
	$(CMAKE_COMMAND) -E cmake_progress_report /home/beomjoon/Documents/Github/drake-distro/avl/pod-build/CMakeFiles $(CMAKE_PROGRESS_5)
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Building Fortran object plotlib/CMakeFiles/plotlib.dir/set_subs.f.o"
	cd /home/beomjoon/Documents/Github/drake-distro/avl/pod-build/plotlib && /usr/bin/gfortran  $(Fortran_DEFINES) $(Fortran_FLAGS) -c /home/beomjoon/Documents/Github/drake-distro/avl/plotlib/set_subs.f -o CMakeFiles/plotlib.dir/set_subs.f.o

plotlib/CMakeFiles/plotlib.dir/set_subs.f.o.requires:
.PHONY : plotlib/CMakeFiles/plotlib.dir/set_subs.f.o.requires

plotlib/CMakeFiles/plotlib.dir/set_subs.f.o.provides: plotlib/CMakeFiles/plotlib.dir/set_subs.f.o.requires
	$(MAKE) -f plotlib/CMakeFiles/plotlib.dir/build.make plotlib/CMakeFiles/plotlib.dir/set_subs.f.o.provides.build
.PHONY : plotlib/CMakeFiles/plotlib.dir/set_subs.f.o.provides

plotlib/CMakeFiles/plotlib.dir/set_subs.f.o.provides.build: plotlib/CMakeFiles/plotlib.dir/set_subs.f.o

plotlib/CMakeFiles/plotlib.dir/gw_subs.f.o: plotlib/CMakeFiles/plotlib.dir/flags.make
plotlib/CMakeFiles/plotlib.dir/gw_subs.f.o: ../plotlib/gw_subs.f
	$(CMAKE_COMMAND) -E cmake_progress_report /home/beomjoon/Documents/Github/drake-distro/avl/pod-build/CMakeFiles $(CMAKE_PROGRESS_6)
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Building Fortran object plotlib/CMakeFiles/plotlib.dir/gw_subs.f.o"
	cd /home/beomjoon/Documents/Github/drake-distro/avl/pod-build/plotlib && /usr/bin/gfortran  $(Fortran_DEFINES) $(Fortran_FLAGS) -c /home/beomjoon/Documents/Github/drake-distro/avl/plotlib/gw_subs.f -o CMakeFiles/plotlib.dir/gw_subs.f.o

plotlib/CMakeFiles/plotlib.dir/gw_subs.f.o.requires:
.PHONY : plotlib/CMakeFiles/plotlib.dir/gw_subs.f.o.requires

plotlib/CMakeFiles/plotlib.dir/gw_subs.f.o.provides: plotlib/CMakeFiles/plotlib.dir/gw_subs.f.o.requires
	$(MAKE) -f plotlib/CMakeFiles/plotlib.dir/build.make plotlib/CMakeFiles/plotlib.dir/gw_subs.f.o.provides.build
.PHONY : plotlib/CMakeFiles/plotlib.dir/gw_subs.f.o.provides

plotlib/CMakeFiles/plotlib.dir/gw_subs.f.o.provides.build: plotlib/CMakeFiles/plotlib.dir/gw_subs.f.o

plotlib/CMakeFiles/plotlib.dir/ps_subs.f.o: plotlib/CMakeFiles/plotlib.dir/flags.make
plotlib/CMakeFiles/plotlib.dir/ps_subs.f.o: ../plotlib/ps_subs.f
	$(CMAKE_COMMAND) -E cmake_progress_report /home/beomjoon/Documents/Github/drake-distro/avl/pod-build/CMakeFiles $(CMAKE_PROGRESS_7)
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Building Fortran object plotlib/CMakeFiles/plotlib.dir/ps_subs.f.o"
	cd /home/beomjoon/Documents/Github/drake-distro/avl/pod-build/plotlib && /usr/bin/gfortran  $(Fortran_DEFINES) $(Fortran_FLAGS) -c /home/beomjoon/Documents/Github/drake-distro/avl/plotlib/ps_subs.f -o CMakeFiles/plotlib.dir/ps_subs.f.o

plotlib/CMakeFiles/plotlib.dir/ps_subs.f.o.requires:
.PHONY : plotlib/CMakeFiles/plotlib.dir/ps_subs.f.o.requires

plotlib/CMakeFiles/plotlib.dir/ps_subs.f.o.provides: plotlib/CMakeFiles/plotlib.dir/ps_subs.f.o.requires
	$(MAKE) -f plotlib/CMakeFiles/plotlib.dir/build.make plotlib/CMakeFiles/plotlib.dir/ps_subs.f.o.provides.build
.PHONY : plotlib/CMakeFiles/plotlib.dir/ps_subs.f.o.provides

plotlib/CMakeFiles/plotlib.dir/ps_subs.f.o.provides.build: plotlib/CMakeFiles/plotlib.dir/ps_subs.f.o

# Object files for target plotlib
plotlib_OBJECTS = \
"CMakeFiles/plotlib.dir/plt_base.f.o" \
"CMakeFiles/plotlib.dir/plt_font.f.o" \
"CMakeFiles/plotlib.dir/plt_util.f.o" \
"CMakeFiles/plotlib.dir/plt_color.f.o" \
"CMakeFiles/plotlib.dir/set_subs.f.o" \
"CMakeFiles/plotlib.dir/gw_subs.f.o" \
"CMakeFiles/plotlib.dir/ps_subs.f.o"

# External object files for target plotlib
plotlib_EXTERNAL_OBJECTS =

lib/libplotlib.a: plotlib/CMakeFiles/plotlib.dir/plt_base.f.o
lib/libplotlib.a: plotlib/CMakeFiles/plotlib.dir/plt_font.f.o
lib/libplotlib.a: plotlib/CMakeFiles/plotlib.dir/plt_util.f.o
lib/libplotlib.a: plotlib/CMakeFiles/plotlib.dir/plt_color.f.o
lib/libplotlib.a: plotlib/CMakeFiles/plotlib.dir/set_subs.f.o
lib/libplotlib.a: plotlib/CMakeFiles/plotlib.dir/gw_subs.f.o
lib/libplotlib.a: plotlib/CMakeFiles/plotlib.dir/ps_subs.f.o
lib/libplotlib.a: plotlib/CMakeFiles/plotlib.dir/build.make
lib/libplotlib.a: plotlib/CMakeFiles/plotlib.dir/link.txt
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --red --bold "Linking Fortran static library ../lib/libplotlib.a"
	cd /home/beomjoon/Documents/Github/drake-distro/avl/pod-build/plotlib && $(CMAKE_COMMAND) -P CMakeFiles/plotlib.dir/cmake_clean_target.cmake
	cd /home/beomjoon/Documents/Github/drake-distro/avl/pod-build/plotlib && $(CMAKE_COMMAND) -E cmake_link_script CMakeFiles/plotlib.dir/link.txt --verbose=$(VERBOSE)

# Rule to build all files generated by this target.
plotlib/CMakeFiles/plotlib.dir/build: lib/libplotlib.a
.PHONY : plotlib/CMakeFiles/plotlib.dir/build

plotlib/CMakeFiles/plotlib.dir/requires: plotlib/CMakeFiles/plotlib.dir/plt_base.f.o.requires
plotlib/CMakeFiles/plotlib.dir/requires: plotlib/CMakeFiles/plotlib.dir/plt_font.f.o.requires
plotlib/CMakeFiles/plotlib.dir/requires: plotlib/CMakeFiles/plotlib.dir/plt_util.f.o.requires
plotlib/CMakeFiles/plotlib.dir/requires: plotlib/CMakeFiles/plotlib.dir/plt_color.f.o.requires
plotlib/CMakeFiles/plotlib.dir/requires: plotlib/CMakeFiles/plotlib.dir/set_subs.f.o.requires
plotlib/CMakeFiles/plotlib.dir/requires: plotlib/CMakeFiles/plotlib.dir/gw_subs.f.o.requires
plotlib/CMakeFiles/plotlib.dir/requires: plotlib/CMakeFiles/plotlib.dir/ps_subs.f.o.requires
.PHONY : plotlib/CMakeFiles/plotlib.dir/requires

plotlib/CMakeFiles/plotlib.dir/clean:
	cd /home/beomjoon/Documents/Github/drake-distro/avl/pod-build/plotlib && $(CMAKE_COMMAND) -P CMakeFiles/plotlib.dir/cmake_clean.cmake
.PHONY : plotlib/CMakeFiles/plotlib.dir/clean

plotlib/CMakeFiles/plotlib.dir/depend:
	cd /home/beomjoon/Documents/Github/drake-distro/avl/pod-build && $(CMAKE_COMMAND) -E cmake_depends "Unix Makefiles" /home/beomjoon/Documents/Github/drake-distro/avl /home/beomjoon/Documents/Github/drake-distro/avl/plotlib /home/beomjoon/Documents/Github/drake-distro/avl/pod-build /home/beomjoon/Documents/Github/drake-distro/avl/pod-build/plotlib /home/beomjoon/Documents/Github/drake-distro/avl/pod-build/plotlib/CMakeFiles/plotlib.dir/DependInfo.cmake --color=$(COLOR)
.PHONY : plotlib/CMakeFiles/plotlib.dir/depend

