FILE(REMOVE_RECURSE
  "../lcmtypes/c"
  "../lcmtypes/cpp"
  "../lcmtypes/java"
  "../lcmtypes/python"
  "CMakeFiles/lcmtypes_bot2-core_jar"
  "lcmtypes_bot2-core.jar"
  "../lcmtypes/java/bot_core/image_sync_t.class"
  "../lcmtypes/java/bot_core/raw_t.class"
  "../lcmtypes/java/bot_core/image_t.class"
  "../lcmtypes/java/bot_core/pose_t.class"
  "../lcmtypes/java/bot_core/image_metadata_t.class"
  "../lcmtypes/java/bot_core/sensor_status_t.class"
  "../lcmtypes/java/bot_core/planar_lidar_t.class"
  "../lcmtypes/java/bot_core/rigid_transform_t.class"
)

# Per-language clean rules from dependency scanning.
FOREACH(lang)
  INCLUDE(CMakeFiles/lcmtypes_bot2-core_jar.dir/cmake_clean_${lang}.cmake OPTIONAL)
ENDFOREACH(lang)
