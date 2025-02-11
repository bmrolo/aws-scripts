#!/bin/bash

# Default values
REPO_URL="https://github.com/bmrolo/aws-scripts.git"
SCRIPT_NAME="install.sh"
INSTALL_NAME="${SCRIPT_NAME%.*}"  # Remove .sh extension for install name
INSTALL_PATH="/usr/local/bin/$INSTALL_NAME"

# Parse command line arguments
while getopts "f:" opt; do
    case $opt in
        f)
            SCRIPT_NAME="$OPTARG"
            INSTALL_NAME="${SCRIPT_NAME%.*}"  # Remove .sh extension for install name
            INSTALL_PATH="/usr/local/bin/$INSTALL_NAME"
            ;;
    esac
done

# Clone the repository silently
if ! git clone "$REPO_URL" > /dev/null 2>&1; then
    echo "Failed to clone repository."
    exit 1
fi

cd quickSSH || { echo "Failed to enter directory."; exit 1; }

# Check if the specified file exists
if [ ! -f "$SCRIPT_NAME" ]; then
    echo "Error: File '$SCRIPT_NAME' not found in repository."
    cd ..
    rm -rf quickSSH
    exit 1
fi

# Make the script executable
chmod +x "$SCRIPT_NAME"

# Move the script to /usr/local/bin
if ! sudo cp "$SCRIPT_NAME" "$INSTALL_PATH"; then
    echo "Failed to copy script to $INSTALL_PATH."
    cd ..
    rm -rf quickSSH
    exit 1
fi

# Clean up
cd ..
rm -rf quickSSH

echo "Installation complete. You can now use the '$INSTALL_NAME' command."
