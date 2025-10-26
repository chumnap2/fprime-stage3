cmake_minimum_required(VERSION 3.13)
project(Stage3_valid CXX)

# 1️⃣ Include the main F´ CMake macros
include("${FPRIME_FRAMEWORK_PATH}/cmake/FPrime.cmake")

# 2️⃣ Initialize the build system
fprime_initialize_build_system()

# 3️⃣ Register this deployment
add_fprime_deployment(DEPLOYMENT Stage3_valid)
