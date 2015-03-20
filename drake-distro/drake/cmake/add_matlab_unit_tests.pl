#!/usr/bin/perl -w

# Note: this must be run from the root directory of the pod, or the root must be passed in as the first argument
if ($#ARGV>-1) {
  print("changing directory to $ARGV[0]\n");
  chdir($ARGV[0]);
}

$CMAKE_INSTALL_PREFIX = `cmake pod-build -L | grep CMAKE_INSTALL_PREFIX | cut -d "=" -f2 | tr -d '[:space:]'`;
$CMAKE_SOURCE_DIR = `pwd | tr -d '[:space:]'`;
$POD_NAME = `cmake pod-build -L | grep POD_NAME | cut -d "=" -f2 | tr -d '[:space:]'`;

# write unit tests to .matlab_ctests
system("matlab -nodisplay -r \"addpath('$CMAKE_INSTALL_PREFIX/matlab'); addpath_$POD_NAME; options.gui = false; options.autorun = false; options.test_list_file = 'pod-build/matlab_ctests'; unitTest(options); exit;\"");

open(my $in, 'pod-build/matlab_ctests');
open(my $ctestfile, '>>', 'pod-build/CTestTestfile.cmake');

while (<$in>) {
  ($test,$testdir,$props) = split(' ',$_,3);
  $testname = $testdir."/".$test;
  $testname =~ s/\Q$CMAKE_SOURCE_DIR\///;

#  $failcondition = "1";   # missing dependency => failure
  $failcondition = "~strncmp(ex.identifier,'Drake:MissingDependency',23)";  # missing dependency => pass

  print $ctestfile "ADD_TEST($testname \"$CMAKE_SOURCE_DIR/cmake/matlab_clean.pl\" \"-nosplash\" \"-nodisplay\" \"-r\" \"rng('shuffle'); rng_state=rng; disp(sprintf('To reproduce this test use rng(%d,''%s'')',rng_state.Seed,rng_state.Type)); disp(' '); addpath('$CMAKE_INSTALL_PREFIX/matlab'); addpath_$POD_NAME; global g_disable_visualizers; g_disable_visualizers=true; try, fevalPackageSafe('$test'); catch ex, disp(getReport(ex,'extended')); disp(' '); fprintf('<test_name>$testname</test_name> <error_id>%s</error_id> <error_message>%s</error_message>',ex.identifier,ex.message); disp(' '); force_close_system; exit($failcondition); end; force_close_system; exit(0)\")\n";
  $props = "WORKING_DIRECTORY \"$testdir\" $props";
  print $ctestfile "SET_TESTS_PROPERTIES($testname PROPERTIES " . $props .")\n";
}
