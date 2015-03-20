FILE(REMOVE_RECURSE
  "../lcmtypes/c"
  "../lcmtypes/cpp"
  "../lcmtypes/java"
  "CMakeFiles/lcmtypes_bot2-procman_jar"
  "lcmtypes_bot2-procman.jar"
  "../lcmtypes/java/bot_procman/orders_t.class"
  "../lcmtypes/java/bot_procman/info_t.class"
  "../lcmtypes/java/bot_procman/discovery_t.class"
  "../lcmtypes/java/bot_procman/printf_t.class"
  "../lcmtypes/java/bot_procman/sheriff_cmd2_t.class"
  "../lcmtypes/java/bot_procman/command2_t.class"
  "../lcmtypes/java/bot_procman/deputy_cmd2_t.class"
  "../lcmtypes/java/bot_procman/deputy_cmd_t.class"
  "../lcmtypes/java/bot_procman/info2_t.class"
  "../lcmtypes/java/bot_procman/sheriff_cmd_t.class"
  "../lcmtypes/java/bot_procman/orders2_t.class"
)

# Per-language clean rules from dependency scanning.
FOREACH(lang)
  INCLUDE(CMakeFiles/lcmtypes_bot2-procman_jar.dir/cmake_clean_${lang}.cmake OPTIONAL)
ENDFOREACH(lang)
