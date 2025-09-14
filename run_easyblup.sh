#!/bin/bash

echo "========================================"
echo "   easyblup Application Launcher"
echo "========================================"
echo

# Check if R is installed
if ! command -v R &> /dev/null; then
    echo "ERROR: R is not installed or not in PATH"
    echo "Please install R from https://cran.r-project.org/"
    exit 1
fi

echo "R found! Starting easyblup..."
echo

# Change to the directory containing this script
cd "$(dirname "$0")"

# Run the quick start script
Rscript quick_start.R

echo
echo "Application closed."
