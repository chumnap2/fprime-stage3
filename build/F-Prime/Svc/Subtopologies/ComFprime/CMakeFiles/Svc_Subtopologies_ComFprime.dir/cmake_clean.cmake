file(REMOVE_RECURSE
  "FramingSubtopologyTopologyAc.cpp"
  "FramingSubtopologyTopologyAc.hpp"
  "Ports_ComBufferQueueEnumAc.cpp"
  "Ports_ComBufferQueueEnumAc.hpp"
  "Ports_ComPacketQueueEnumAc.cpp"
  "Ports_ComPacketQueueEnumAc.hpp"
  "SubtopologyTopologyAc.cpp"
  "SubtopologyTopologyAc.hpp"
)

# Per-language clean rules from dependency scanning.
foreach(lang )
  include(CMakeFiles/Svc_Subtopologies_ComFprime.dir/cmake_clean_${lang}.cmake OPTIONAL)
endforeach()
