FILE(REMOVE_RECURSE
  "CMakeFiles/lcmtypes_py"
  "lcmgen/lcmtypes/drake/examples/Pendulum/lcmt_pendulum_y.py"
  "lcmgen/lcmtypes/drake/lcmt_viewer_link_data.py"
  "lcmgen/lcmtypes/drake/lcmt_robot_state.py"
  "lcmgen/lcmtypes/drake/lcmt_viewer_command.py"
  "lcmgen/lcmtypes/drake/examples/Pendulum/lcmt_pendulum_x.py"
  "lcmgen/lcmtypes/drake/lcmt_viewer_draw.py"
  "lcmgen/lcmtypes/drake/lcmt_scope_data.py"
  "lcmgen/lcmtypes/lcmt_drake_signal.py"
  "lcmgen/lcmtypes/drake/lcmt_viewer_geometry_data.py"
  "lcmgen/lcmtypes/drake/examples/Pendulum/lcmt_pendulum_u.py"
  "lcmgen/lcmtypes/drake/lcmt_viewer_load_robot.py"
)

# Per-language clean rules from dependency scanning.
FOREACH(lang)
  INCLUDE(CMakeFiles/lcmtypes_py.dir/cmake_clean_${lang}.cmake OPTIONAL)
ENDFOREACH(lang)
