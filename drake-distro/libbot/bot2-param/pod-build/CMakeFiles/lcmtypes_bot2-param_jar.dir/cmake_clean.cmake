FILE(REMOVE_RECURSE
  "../lcmtypes/c"
  "../lcmtypes/cpp"
  "../lcmtypes/java"
  "../lcmtypes/python"
  "CMakeFiles/lcmtypes_bot2-param_jar"
  "lcmtypes_bot2-param.jar"
  "../lcmtypes/java/bot_param/update_t.class"
  "../lcmtypes/java/bot_param/request_t.class"
  "../lcmtypes/java/bot_param/entry_t.class"
  "../lcmtypes/java/bot_param/set_t.class"
)

# Per-language clean rules from dependency scanning.
FOREACH(lang)
  INCLUDE(CMakeFiles/lcmtypes_bot2-param_jar.dir/cmake_clean_${lang}.cmake OPTIONAL)
ENDFOREACH(lang)
