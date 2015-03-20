FILE(REMOVE_RECURSE
  "CMakeFiles/tester.dir/tester.f.o"
  "../bin/tester.pdb"
  "../bin/tester"
)

# Per-language clean rules from dependency scanning.
FOREACH(lang Fortran)
  INCLUDE(CMakeFiles/tester.dir/cmake_clean_${lang}.cmake OPTIONAL)
ENDFOREACH(lang)
