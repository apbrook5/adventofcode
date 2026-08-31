#!/bin/bash

# Script to create a new day for Advent of Code
# Usage: ./new-day.sh [day_number]
# If no day number is provided, it auto-detects the next day.

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
SOURCES_DIR="$SCRIPT_DIR/Sources"
TESTS_DIR="$SCRIPT_DIR/Tests"
DATA_DIR="$SCRIPT_DIR/Sources/Data"
AOC_FILE="$SOURCES_DIR/AdventOfCode.swift"

# Determine the next day number
if [ -n "$1" ]; then
    NEXT_DAY=$1
else
    # Find the highest existing day number and add 1
    LAST_DAY=$(ls "$SOURCES_DIR"/Day[0-9][0-9].swift 2>/dev/null | sed 's/.*Day\([0-9][0-9]\)\.swift/\1/' | sort -n | tail -1)
    if [ -z "$LAST_DAY" ]; then
        NEXT_DAY=1
    else
        NEXT_DAY=$((10#$LAST_DAY + 1))
    fi
fi

# Zero-pad the day number
DAY=$(printf "%02d" "$NEXT_DAY")

echo "Creating files for Day $DAY..."

# Check if files already exist
if [ -f "$SOURCES_DIR/Day${DAY}.swift" ]; then
    echo "Error: Day${DAY}.swift already exists in Sources/"
    exit 1
fi

# Create source file from Day00 template
sed "s/Day00/Day${DAY}/g" "$SOURCES_DIR/Day00.swift" > "$SOURCES_DIR/Day${DAY}.swift"
echo "  Created Sources/Day${DAY}.swift"

# Create test file from Day00 template
sed "s/Day00/Day${DAY}/g" "$TESTS_DIR/Day00.swift" > "$TESTS_DIR/Day${DAY}.swift"
echo "  Created Tests/Day${DAY}.swift"

# Create empty data file
touch "$DATA_DIR/Day${DAY}.txt"
echo "  Created Sources/Data/Day${DAY}.txt"

# Add the new day to the allChallenges array in AdventOfCode.swift
sed -i '' "s/^\]$/  Day${DAY}(),\n]/" "$AOC_FILE"
echo "  Added Day${DAY}() to allChallenges in AdventOfCode.swift"

echo "Done! Day $DAY is ready."
