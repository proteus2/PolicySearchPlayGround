#!/bin/bash

# Usage:
#   % drake_debug_mex.sh [args]
# will set up the environment and then run:
#   % args pod-build/bin/drake-debug-mex
#
# For example,
#   % drake_debug_mex.sh
# will simply run the executable,
#   % drake_debug_mex.sh gdb
# will run gdb on drake-debug-mex, and
#   % drake_debug_mex.sh valgrind --leak-check=full --dsymutil=yes --track-origins=yes --xml=yes
# will run valgrind with the appropriate arguments passed in.
#
# It's not pretty, but seems to work for the use
# cases I've imagined so far. - RussT

export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/MATLAB/R2012b/bin/
export LD_PRELOAD=/tmp/drake-eigen-21008/drake/pod-build/lib/libdebugMex.so

"$@" /tmp/drake-eigen-21008/drake/pod-build/bin/drake_debug_mex
