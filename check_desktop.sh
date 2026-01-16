#!/bin/bash

DESKTOP="$HOME/Desktop"

if [ ! -d "$DESKTOP" ]; then
	echo "INFO: Desktop directory does not exist"
	exit 0
fi

count=$(find "$DESKTOP" -maxdepth 1 -mindepth 1 -print | wc -l)
size=$(du -sh "$DESKTOP" | awk '{print $1}')

if [ "$count" -gt 30 ]; then
	echo "WARNING: Desktop clutter detected"
	exit 1
fi

echo "Desktop items count: $count"
echo "Desktop total size: $size"
