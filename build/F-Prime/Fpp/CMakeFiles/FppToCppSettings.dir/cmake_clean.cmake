file(REMOVE_RECURSE
  "PhasesEnumAc.cpp"
  "PhasesEnumAc.hpp"
)

# Per-language clean rules from dependency scanning.
foreach(lang )
  include(CMakeFiles/FppToCppSettings.dir/cmake_clean_${lang}.cmake OPTIONAL)
endforeach()
