#!/bin/bash

<<question3
    Use the commands pr, sort, and cut to read a text file in reverse order. For instance, let 
    the content of the file (file.txt) is 
    One 
    Two 
    Three 
    Then, your script should display the contents of file.txt in reverse order: 
    Three 
    Two 
    One
question3

clear

read -p "Please enter the file path: " filepath

if [ -f "$filepath" ]; then
    # If the file exists, process it.
    echo "---- File content in reverse order -----"

    # 1. pr -n -t "$filepath": Numbers each line of the file.
    # 2. sort -r: Sorts the numbered lines in reverse (descending) order.
    # 3. cut -f2-: Removes the line number (the first field), leaving only the original text.
    pr -n -t "$filepath" | sort -r | cut -f2-

    echo "-----------------------------------"
else
    # If the file does not exist or is not a regular file, print an error message.
    echo "Error: File not found at '$filepath'"
fi