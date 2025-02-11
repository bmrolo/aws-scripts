#!/bin/bash

REPO_URL="https://github.com/bmrolo/aws-scripts.git"
INSTALL_PATH="/usr/local/bin"

# Clone the repository silently
if ! git clone "$REPO_URL" > /dev/null 2>&1; then
    echo "Failed to clone repository."
    exit 1
fi

cd your-repo || { echo "Failed to enter directory."; exit 1; }

# List all shell scripts in the directory
echo "Available scripts:"
scripts=($(ls *.sh))
for i in "${!scripts[@]}"; do
    echo "$((i+1)). ${scripts[$i]}"
done

# Prompt user to select a script
read -p "Enter the number of the script you want to install: " choice

# Validate the choice
if [[ $choice -lt 1 || $choice -gt ${#scripts[@]} ]]; then
    echo "Invalid choice. Exiting."
    exit 1
fi

selected_script="${scripts[$((choice-1))]}"
echo "You selected: $selected_script"

# Make the selected script executable
echo "Making $selected_script executable..."
chmod +x "$selected_script"

# Move the script to /usr/local/bin
script_install_path="$INSTALL_PATH/$(basename "$selected_script" .sh)"
if ! sudo cp "$selected_script" "$script_install_path"; then
    echo "Failed to copy script to $script_install_path."
    exit 1
fi

# Clean up
cd ..
rm -rf your-repo

echo "Installation complete. You can now use the '$(basename "$selected_script" .sh)' command."
