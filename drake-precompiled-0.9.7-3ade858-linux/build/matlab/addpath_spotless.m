function addpath_spotless()
  mfiledir = fileparts(which(mfilename));
  addpath(fullfile(mfiledir,'../../spotless/spotless'));
  addpath(fullfile(mfiledir,'../../spotless/spotless/mex'));
  addpath(fullfile(mfiledir,'../../spotless/spotless/mss'));
  addpath(fullfile(mfiledir,'../../spotless/spotless/spotopt'));
  addpath(fullfile(mfiledir,'../../spotless/spotless/spotopt/solvers'));
  addpath(fullfile(mfiledir,'../../spotless/spotless/spotopt/util'));
  addpath(fullfile(mfiledir,'../../spotless/spotless/util'));
