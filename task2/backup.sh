#!/bin/bash

read -p "Enter the directory you want to back up: " DIR
if [ ! -d "$DIR" ]; then
    echo "Directory does not exist!"
    exit 1
fi

ARCHIVE_NAME="$(basename $DIR)_$(date +%Y%m%d%H%M%S).tar.gz"
tar -czf "/tmp/$ARCHIVE_NAME" "$DIR"

read -p "Enter target directory for backup: " TARGET_DIR
mkdir -p "$TARGET_DIR"
mv "/tmp/$ARCHIVE_NAME" "$TARGET_DIR"

echo "Backup of $DIR stored as $ARCHIVE_NAME in $TARGET_DIR"
