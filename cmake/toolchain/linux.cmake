# -----------------------------------------------------------------------------
# F' Linux Native Toolchain File
# Use this for building F' components natively on a Linux host
# -----------------------------------------------------------------------------

# STEP 1: Set the name of the target system
set(CMAKE_SYSTEM_NAME Linux)

# STEP 2: Specify the C and C++ compilers (native host compilers)
set(CMAKE_C_COMPILER gcc)
set(CMAKE_CXX_COMPILER g++)

# STEP 3: Use the system paths, no cross-compilation root
set(CMAKE_FIND_ROOT_PATH "")

# STEP 4: Control how CMake searches for programs, libraries, and includes
# Programs are searched on host normally
set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
# Libraries, includes, packages are searched only in root path (empty here)
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_PACKAGE ONLY)

# STEP 5: Optional compilation flags (adjust if needed)
set(CMAKE_C_FLAGS "-O2 -g")
set(CMAKE_CXX_FLAGS "-O2 -g")
set(CMAKE_EXE_LINKER_FLAGS "")

# STEP 6: Optional: enforce C++17 standard
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

# -----------------------------------------------------------------------------
# End of Linux Native Toolchain
# -----------------------------------------------------------------------------
