#!/bin/bash

# Path to the reference directory
mnt_directory="/mnt/img_mount"

# Directories to check
check_directories=("/bin" "/data" "/docker" "/etc" "/lib" "/lib32" "/lib64" "/libx32" "/media")
#   - Default system directories often found in a typical Linux installation:
#     - /bin
#     - /boot
#     - /dev
#     - /etc
#     - /home
#     - /lib
#     - /lib32
#     - /lib64
#     - /libx32
#     - /media
#     - /mnt - I wouldn't recommend that
#     - /opt
#     - /proc
#     - /root
#     - /run
#     - /sbin
#     - /srv
#     - /sys
#     - /tmp
#     - /usr
#     - /var

# Function for comparing and synchronizing permissions
compare_and_sync_permissions() {
    src_file="$1"
    dst_file="$2"

    src_perms=$(stat -c "%a" "$src_file")
    dst_perms=$(stat -c "%a" "$dst_file")

    if [ "$src_perms" != "$dst_perms" ]; then
        # Automatically apply permissions without asking the user.
        chmod "$src_perms" "$dst_file"
        echo "Applied permissions for $dst_file."
    fi
}

# Checking and synchronizing permissions
for dir in "${check_directories[@]}"; do
    if [ -d "$mnt_directory$dir" ]; then
        find "$mnt_directory$dir" -type d -o -type f | while read -r file; do
            relative_path="${file#$mnt_directory}"
            dst_file="/$system_directory${relative_path#/}"

            if [ -e "$dst_file" ]; then
                compare_and_sync_permissions "$file" "$dst_file"
            else
                echo "File/directory $dst_file does not exist in the system."
            fi
        done
    else
        echo "Directory $mnt_directory$dir does not exist."
    fi
done

echo "Permissions synchronization completed."
