FILE(REMOVE_RECURSE
  "CMakeFiles/jar"
  "bot2-lcmgl.jar"
  "java-build/bot_lcmgl/data_t.class"
  "java-build/bot_lcmgl/LCMGL.class"
)

# Per-language clean rules from dependency scanning.
FOREACH(lang)
  INCLUDE(CMakeFiles/jar.dir/cmake_clean_${lang}.cmake OPTIONAL)
ENDFOREACH(lang)
