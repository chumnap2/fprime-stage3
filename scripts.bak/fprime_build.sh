#!/bin/bash

# Set F' framework path
export FPRIME_FRAMEWORK_PATH=~/fprime
DEPLOY_DIR=~/fprime/Stage3/minimal_chibios/motor_control/MotorTestApp

echo "Cleaning old builds..."
rm -rf "$DEPLOY_DIR/build-fprime-automatic-native" "$DEPLOY_DIR/build-artifacts"

# Ensure FprimeComponents directory exists
mkdir -p "$DEPLOY_DIR/FprimeComponents"
# Ensure MotorComponent directory exists
mkdir -p "$DEPLOY_DIR/FprimeComponents/MotorComponent"

# Ensure Top directory exists
mkdir -p "$DEPLOY_DIR/Top"

# Ensure Main.cpp exists in deployment root
if [ ! -f "$DEPLOY_DIR/Main.cpp" ]; then
    echo "Creating minimal Main.cpp..."
    cat > "$DEPLOY_DIR/Main.cpp" <<EOL
#include "Fw/Types/BasicTypes.hpp"

int main() {
    return 0;
}
EOL
fi

# Ensure settings.ini exists
if [ ! -f "$DEPLOY_DIR/settings.ini" ]; then
    echo "Creating default settings.ini..."
    touch "$DEPLOY_DIR/settings.ini"
fi

# Update deployment CMakeLists.txt
DEPLOY_CMAKE="$DEPLOY_DIR/CMakeLists.txt"
cat > "$DEPLOY_CMAKE" <<EOL
cmake_minimum_required(VERSION 3.10)
project(MotorTestApp)

# Include F' macros
include("\$ENV{FPRIME_FRAMEWORK_PATH}/cmake/FPrime.cmake")

# Add custom component
add_fprime_subdirectory("\$CMAKE_CURRENT_LIST_DIR/FprimeComponents/MotorComponent")

# Add Top module
add_fprime_subdirectory("\$CMAKE_CURRENT_LIST_DIR/Top")

# Register deployment
register_fprime_deployment(
    SOURCES
        "\$CMAKE_CURRENT_LIST_DIR/Main.cpp"
    DEPENDS
        ${FPRIME_CURRENT_MODULE}_Top
)
EOL

# Ensure Top/CMakeLists.txt only registers module
TOP_CMAKE="$DEPLOY_DIR/Top/CMakeLists.txt"
cat > "$TOP_CMAKE" <<EOL
register_fprime_module(
    AUTOCODER_INPUTS
        "\$CMAKE_CURRENT_LIST_DIR/instances.fpp"
        "\$CMAKE_CURRENT_LIST_DIR/topology.fpp"
    SOURCES
        "\$CMAKE_CURRENT_LIST_DIR/MotorTestAppTopology.cpp"
    DEPENDS
        Fw_Logger
)
EOL

echo "Environment cleaned and ready."
echo "Now run:"
echo "  cd $DEPLOY_DIR"
echo "  fprime-util generate"
echo "  fprime-util build"
