#!/bin/bash
# fast_motor_test.sh
# Quick build/test script for MotorTestApp F' deployment

set -e  # Exit on first error
echo "✅ Starting Fast Motor Test script..."

# --- Set environment variables for F' ---
export FPRIME_FRAMEWORK_PATH=~/fprime
export FPRIME_PROJECT_ROOT=~/fprime
export FPRIME_LIBRARY_LOCATIONS="$FPRIME_FRAMEWORK_PATH"

# --- Paths ---
COMPONENT_DIR=~/fprime/Stage3/minimal_chibios/motor_control/MotorTestApp/FprimeComponents/MotorComponent
DEPLOYMENT_DIR=~/fprime/Stage3/minimal_chibios/motor_control/MotorTestApp
BUILD_DIR=$DEPLOYMENT_DIR/build-fprime-automatic-native

# --- Clean old build cache ---
if [ -d "$BUILD_DIR" ]; then
    echo "🧹 Removing old build cache..."
    rm -rf "$BUILD_DIR"
fi

# --- Ensure component exists ---
if [ ! -d "$COMPONENT_DIR" ]; then
    echo "❌ Component not found at $COMPONENT_DIR"
    exit 1
fi

# --- Generate deployment ---
cd "$DEPLOYMENT_DIR"
echo "⚙️ Generating deployment..."
fprime-util generate

# --- Build deployment ---
echo "🏗️ Building deployment..."
fprime-util build -j $(nproc)

# --- Check build result ---
if [ -f "$BUILD_DIR/deployable_executable" ]; then
    echo "✅ Deployment built successfully!"
else
    echo "⚠️ Deployment executable not found! Check build logs."
fi

echo "✅ Fast Motor Test script finished!"
