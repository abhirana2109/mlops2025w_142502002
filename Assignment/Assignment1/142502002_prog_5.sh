#!/bin/bash

<<question5
    Write a shell script to reverse a string.
question5

clear

read -p "Enter a string to reverse: " input_string

# Get the length of the string
len=${#input_string}
reversed_string=""

# Loop backwards from the last character to the first
for (( i=$len-1; i>=0; i-- ))
do
    # Extract one character at the current index 'i'
    char=${input_string:$i:1}
    
    # Append the character to our new reversed string
    reversed_string="$reversed_string$char"
done

# Display the result
echo "Original string:  $input_string"
echo "Reversed string:  $reversed_string"