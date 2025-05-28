#!/bin/bash

LOG_FILE="/var/log/user_script.log"

log() {
    echo "$(date) : $1" | tee -a "$LOG_FILE"
}

echo "🗂️ Backup Script - Starting..."

# Prompt for source directory
read -rp "Enter the full path of the directory to back up: " SRC_DIR
if [ ! -d "$SRC_DIR" ]; then
    log "❌ Source directory does not exist: $SRC_DIR"
    exit 1
fi

# Generate archive name with timestamp
ARCHIVE_NAME="backup_$(basename "$SRC_DIR")_$(date +%Y%m%d_%H%M%S).tar.gz"

# Create archive
tar -czf "$ARCHIVE_NAME" -C "$(dirname "$SRC_DIR")" "$(basename "$SRC_DIR")"
log "✅ Created archive: $ARCHIVE_NAME"

# Prompt for backup destination
read -rp "Enter the full path to store the backup: " DEST_DIR
if [ ! -d "$DEST_DIR" ]; then
    log "⚠️ Destination directory does not exist. Creating it: $DEST_DIR"
    mkdir -p "$DEST_DIR"
fi

# Move archive
mv "$ARCHIVE_NAME" "$DEST_DIR/"
log "📦 Moved archive to $DEST_DIR"

echo "✅ Backup completed successfully. File stored at: $DEST_DIR/$ARCHIVE_NAME"

