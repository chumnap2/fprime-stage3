file(REMOVE_RECURSE
  "PlatformAssertArgTypeAliasAc.hpp"
  "PlatformIndexTypeAliasAc.hpp"
  "PlatformQueuePriorityTypeAliasAc.hpp"
  "PlatformSignedSizeTypeAliasAc.hpp"
  "PlatformSizeTypeAliasAc.hpp"
  "PlatformTaskIdTypeAliasAc.hpp"
  "PlatformTaskPriorityTypeAliasAc.hpp"
)

# Per-language clean rules from dependency scanning.
foreach(lang )
  include(CMakeFiles/UnixPlatformTypes.dir/cmake_clean_${lang}.cmake OPTIONAL)
endforeach()
