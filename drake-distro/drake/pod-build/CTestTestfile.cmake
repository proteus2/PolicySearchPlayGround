# CMake generated Testfile for 
# Source directory: /home/beomjoon/Documents/Github/drake-distro/drake
# Build directory: /home/beomjoon/Documents/Github/drake-distro/drake/pod-build
# 
# This file includes the relevant testing commands required for 
# testing this directory and lists subdirectories to be tested as well.
ADD_TEST(RigidBodyManipulatorMemoryTest "matlab" "-nosplash" "-nodisplay" "-r" "addpath('/home/beomjoon/Documents/Github/drake-distro/build/matlab'); addpath_drake; try, r = RigidBodyManipulator('Acrobot.urdf'); megaclear; catch ex, disp(getReport(ex,'extended')); disp(''); force_close_system; exit(1); end; force_close_system; exit(0)")
SET_TESTS_PROPERTIES(RigidBodyManipulatorMemoryTest PROPERTIES  TIMEOUT "60" WORKING_DIRECTORY "/home/beomjoon/Documents/Github/drake-distro/drake/examples/Acrobot")
SUBDIRS(util)
SUBDIRS(solvers)
SUBDIRS(systems)
SUBDIRS(thirdParty/GetFullPath)
