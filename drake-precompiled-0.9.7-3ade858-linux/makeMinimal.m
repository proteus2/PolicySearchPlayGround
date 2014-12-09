function makeMinimal

% simple script to build minimal on platforms that i don't yet support
% for compilation from the command line

cd spotless/spotless;
spot_install;

cd ../../drake/systems;
mex DCSFunction.cpp;

cd ../util;
mex realtime.cpp;
mex barycentricInterpolation.cpp;

cd ../..;
