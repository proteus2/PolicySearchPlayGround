
================================
SNOPT mex Files in $SNOPT/matlab
================================

The distribution includes several precompiled mex files
  % snopt7/matlab/snoptcmex.mexa64
  % snopt7/matlab/snoptcmex.mexglx
  % snopt7/matlab/snoptcmex.mexmaci
  % snopt7/matlab/snoptcmex.mexmaci64
  % snopt7/matlab/snoptcmex.mexw32
  % snopt7/matlab/snoptcmex.mexw64


You may also compile your own mex files.  To do so, you must configure
SNOPT with 64-bit integers and provide the location of MATLAB on your
machine using:

  ./configure --with-matlab=/path/to/matlab --with64

The mex file will be compiled during the make process and placed in the
snopt7/matlab directory.


==========================================
Using the SNOPT mex Files in $SNOPT/matlab
==========================================

 Run Matlab in the directory $SNOPT/matlab.

 Typing
  >> more on
  >> help Contents
from Matlab provides an overview of the package.

 At the Matlab prompt, type

  >> runAllExamples

This script sets an appropriate matlab path.

The subdirectory  ./examples  contains sample problems that
demonstrate how to use the various snOpt Matlab interfaces.
Read the "Contents" for more information.

Problems may be run individually from $SNOPT/matlab as follows.

    >> setpath    % (if you haven't already called runAllExamples)

    >> addpath examples
    >> addpath examples/snmain
    >> snoptmain  % (this is one of the examples)
