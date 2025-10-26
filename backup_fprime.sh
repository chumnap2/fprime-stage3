#!/bin/bash

# F´ backup script
# Saves Stage3, virtualenv, framework, and build artifacts

# Timestamp
TS=$(date +%Y%m%d_%H%M%S)

# Directories
FPRIME_DIR=~/fprime
STAGE3_DIR=$FPRIME_DIR/Stage3_valid
VENV_DIR=$FPRIME_DIR/fprime-venv
FRAMEWORK_DIR=$FPRIME_DIR/fprime-framework
BUILD_DIR=$FPRIME_DIR/build-fprime-automatic-native

# Output backups directory
BACKUP_DIR=$FPRIME_DIR/fprime_backups
mkdir -p $BACKUP_DIR

echo "Backing up Stage3..."
tar czvf $BACKUP_DIR/Stage3_valid_backup_$TS.tar.gz -C $FPRIME_DIR Stage3_valid

echo "Backing up virtual environment..."
tar czvf $BACKUP_DIR/fprime-venv_backup_$TS.tar.gz -C $FPRIME_DIR fprime-venv

echo "Backing up framework..."
tar czvf $BACKUP_DIR/fprime-framework_backup_$TS.tar.gz -C $FPRIME_DIR fprime-framework

echo "Backing up build artifacts..."
tar czvf $BACKUP_DIR/fprime_build_backup_$TS.tar.gz -C $FPRIME_DIR build-fprime-automatic-native

echo "Backup complete! Files saved in $BACKUP_DIR"
