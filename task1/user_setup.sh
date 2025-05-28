#!/bin/bash

LOG_FILE="/var/log/user_script.log"

# Function to log messages with timestamps
log() {
    echo "$(date) : $1" | tee -a "$LOG_FILE"
}

# Check if CSV is passed as argument
if [ $# -eq 0 ]; then
    echo "Usage: $0 <csv_file_path_or_url>"
    exit 1
fi

CSV_FILE="$1"

# Check if it's a remote file
if [[ "$CSV_FILE" =~ ^https?:// ]]; then
    TEMP_FILE="/tmp/users.csv"
    curl -s "$CSV_FILE" -o "$TEMP_FILE"
    CSV_FILE="$TEMP_FILE"
    log "Downloaded CSV from remote URL"
fi

# Read the CSV line by line (skip header)
tail -n +2 "$CSV_FILE" | while IFS=, read -r email birthdate groups shared_folder; do
    # Cleanup potential \r characters (from Windows CSV)
    birthdate=$(echo "$birthdate" | tr -d '\r')
    groups=$(echo "$groups" | tr -d '"\r')
    shared_folder=$(echo "$shared_folder" | tr -d '\r')

    username=$(echo "$email" | cut -d'@' -f1)
    password=$(date -d "$birthdate" +%m%Y)

    # Create user if not exists
    if id "$username" &>/dev/null; then
        log "User $username already exists"
    else
        useradd -m -s /bin/bash "$username"
        echo "$username:$password" | chpasswd
        log "Created user $username"
    fi

    # Add to groups
    IFS=',' read -ra group_array <<< "$groups"
    for grp in "${group_array[@]}"; do
        if ! getent group "$grp" >/dev/null; then
            groupadd "$grp"
            log "Created group $grp"
        fi
        usermod -aG "$grp" "$username"
        log "Added $username to group $grp"
    done

    # Create shared folder
    if [ ! -d "$shared_folder" ]; then
        mkdir -p "$shared_folder"
        chown root:"${group_array[0]}" "$shared_folder"
        chmod 770 "$shared_folder"
        log "Created shared folder $shared_folder"
    fi

    # Create symlink in user's home
    link_path="/home/$username/$(basename "$shared_folder")"
    if [ ! -L "$link_path" ]; then
        ln -s "$shared_folder" "$link_path"
        log "Linked $shared_folder to $link_path"
    else
        log "Symlink already exists for $username"
    fi

done
