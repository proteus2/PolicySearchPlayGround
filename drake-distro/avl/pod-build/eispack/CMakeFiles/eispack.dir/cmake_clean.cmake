FILE(REMOVE_RECURSE
  "CMakeFiles/eispack.dir/eispack.f.o"
  "../lib/libeispack.pdb"
  "../lib/libeispack.a"
)

# Per-language clean rules from dependency scanning.
FOREACH(lang Fortran)
  INCLUDE(CMakeFiles/eispack.dir/cmake_clean_${lang}.cmake OPTIONAL)
ENDFOREACH(lang)
