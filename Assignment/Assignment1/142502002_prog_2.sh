#!/bin/bash

<<question2
    Write a shell script traverse through a filesystem tree. The script will start from the root 
    file system “/” and traverse each subdirectory and list the contents of the directories.
question2

clear

traverse() {
    local current_dir="$1"
    echo "----- Listing contents of: $current_dir -----"
    
    # List the contents of the current directory
    ls -A "$current_dir"

    # Newline for better formatting
    echo ""
    
    # Loop through each item in the current directory
    for item in "$current_dir/"*
    do
        if [ -d "$item" ]; then
            traverse "$item"
        fi
    done
}

traverse "/"
echo "Traversal complete."