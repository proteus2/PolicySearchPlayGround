FILE(REMOVE_RECURSE
  "CMakeFiles/lcmtype_agg_hpp"
  "lcmgen/lcmtypes/drake/examples/Pendulum/lcmt_pendulum_y.hpp"
  "lcmgen/lcmtypes/drake/lcmt_viewer_link_data.hpp"
  "lcmgen/lcmtypes/drake/lcmt_robot_state.hpp"
  "lcmgen/lcmtypes/drake/lcmt_viewer_command.hpp"
  "lcmgen/lcmtypes/drake/examples/Pendulum/lcmt_pendulum_x.hpp"
  "lcmgen/lcmtypes/drake/lcmt_viewer_draw.hpp"
  "lcmgen/lcmtypes/drake/lcmt_scope_data.hpp"
  "lcmgen/lcmtypes/lcmt_drake_signal.hpp"
  "lcmgen/lcmtypes/drake/lcmt_viewer_geometry_data.hpp"
  "lcmgen/lcmtypes/drake/examples/Pendulum/lcmt_pendulum_u.hpp"
  "lcmgen/lcmtypes/drake/lcmt_viewer_load_robot.hpp"
)

# Per-language clean rules from dependency scanning.
FOREACH(lang)
  INCLUDE(CMakeFiles/lcmtype_agg_hpp.dir/cmake_clean_${lang}.cmake OPTIONAL)
ENDFOREACH(lang)
