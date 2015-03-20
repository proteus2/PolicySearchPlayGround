FILE(REMOVE_RECURSE
  "../lcmtypes/c"
  "../lcmtypes/cpp"
  "CMakeFiles/lcmgen_c"
)

# Per-language clean rules from dependency scanning.
FOREACH(lang)
  INCLUDE(CMakeFiles/lcmgen_c.dir/cmake_clean_${lang}.cmake OPTIONAL)
ENDFOREACH(lang)
