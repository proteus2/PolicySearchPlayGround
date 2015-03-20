function rmpath_spotless()
  mfiledir = fileparts(which(mfilename));
  rmpath(fullfile(mfiledir,'../../spotless/spotless'));
  rmpath(fullfile(mfiledir,'../../spotless/spotless/mex'));
  rmpath(fullfile(mfiledir,'../../spotless/spotless/mss'));
  rmpath(fullfile(mfiledir,'../../spotless/spotless/spotopt'));
  rmpath(fullfile(mfiledir,'../../spotless/spotless/spotopt/solvers'));
  rmpath(fullfile(mfiledir,'../../spotless/spotless/spotopt/util'));
  rmpath(fullfile(mfiledir,'../../spotless/spotless/util'));
