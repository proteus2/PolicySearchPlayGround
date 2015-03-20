FILE(REMOVE_RECURSE
  "../lcmtypes/c"
  "../lcmtypes/cpp"
  "../lcmtypes/java"
  "../lcmtypes/python"
  "CMakeFiles/lcmtypes_bot2-frames_jar"
  "lcmtypes_bot2-frames.jar"
  "../lcmtypes/java/bot_frames/update_t.class"
)

# Per-language clean rules from dependency scanning.
FOREACH(lang)
  INCLUDE(CMakeFiles/lcmtypes_bot2-frames_jar.dir/cmake_clean_${lang}.cmake OPTIONAL)
ENDFOREACH(lang)
