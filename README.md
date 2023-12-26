# System Permissions Restorer

This script is designed to address situations where system file permissions have been unintentionally modified, potentially causing issues with system stability and security. It is particularly useful when accidental commands like 'chmod -R 777 /*' have been executed, altering default system file permissions.

**Note:** This script assumes that the '/mnt/img_mount' directory represents a system partition from a backup where permissions can be read.

## Usage

1. **Prerequisites**: Ensure that you have root access or superuser privileges on your system.

2. **Configuration**:
    - Edit the `mnt_directory` variable in the script to specify the correct mount point for your system backup where permissions can be read.
    - Update the `check_directories` array to include additional system directories you want the script to check and synchronize.

3. **Execution**:
    - Download the script.

    - Navigate to the script directory.

    - Make the script executable (if it's not already):

      ```bash
      chmod +x restore_permissions.sh
      ```

    - Execute the script as root or with superuser privileges:

      ```bash
      sudo ./restore_permissions.sh
      ```

4. **Follow the on-screen prompts to apply permissions** as needed. The script will compare and synchronize permissions for the specified system directories.

## Customizing Behavior

If you want the script to prompt you for permission before applying permissions, you can customize the behavior by modifying the `compare_and_sync_permissions()` function in the script:

```bash
compare_and_sync_permissions() {
    src_file="$1"
    dst_file="$2"

    src_perms=$(stat -c "%a" "$src_file")
    dst_perms=$(stat -c "%a" "$dst_file")

    if [ "$src_perms" != "$dst_perms" ]; then
        echo "File/directory $src_file has different permissions than $dst_file. Apply permissions? [y/n/a]"
        read -r answer < /dev/tty  # Redirect input to the terminal.
        if [ "$answer" = "y" ]; then
            chmod "$src_perms" "$dst_file"
            echo "Applied permissions for $dst_file."
        elif [ "$answer" = "a" ]; then
            # Apply permissions to all files in the folder.
            folder="$(dirname "$dst_file")"
            find "$folder" -type f -exec chmod "$src_perms" {} \;
            echo "Applied permissions to all files in $folder."
        fi
    fi
}

## Important Notes

- This script is intended for advanced users who understand the implications of modifying system file permissions.

- It assumes that '/mnt/img_mount' represents a system partition from a backup where permissions can be read.

- Always backup your data and important files before making any changes to system permissions.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
