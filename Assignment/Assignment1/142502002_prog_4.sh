#!/bin/bash

<<question4
    Create an address book program. It should use functions to perform the required tasks. 
    It should be menu-based, allowing you the options of: 
    a. Search address book: When the user searches for "Smith", the script should 
    identify and display all "Smith" records.  
    b. Add entries: Input the data (Name, Surname, Email, Phone, etc). Save the record 
    into the data file when the user confirms. 
    c. Remove entries: Enter search criteria, narrow it down to one, confirm, and then 
    remove that record. 
    d. Display function to display a record or records when selected. 
question4

clear

ADDRESS_BOOK_FILE="address_book.csv"

# Function to add a new entry to the address book
add_entry() {
    clear
    echo "----- Add New Entry -----"
    
    # Ask user for details
    read -p "Enter Name: " name
    read -p "Enter Surname: " surname
    read -p "Enter Email: " email
    read -p "Enter Phone Number: " phone
    
    # Append the new record as a CSV line to the file
    echo "$name, $surname, $email, $phone" >> "$ADDRESS_BOOK_FILE"
    echo "Entry added successfully!"

    read -p "Press Enter to return to the menu....."
}

# Function to search for entries
search_entry() {
    clear
    echo "----- Search Address Book -----"
    read -p "Enter search term (example: a name or email): " search_term
    
    echo "Searching for '$search_term'....."
    
    echo "Name,Surname,Email,Phone"
    echo "--------------------------"
    grep -i "$search_term" "$ADDRESS_BOOK_FILE"
    
    if [ $? -ne 0 ]; then
        echo "No records found."
    fi
    
    read -p "Press Enter to return to the menu....."
}

# Function to display all entries
display_all() {
    clear
    echo "----- All Address Book Entries -----"
    
    # Check if the address book file exists and is not empty
    if [ -s "$ADDRESS_BOOK_FILE" ]; then
        # Display a header and then the content of the file
        echo "Name, Surname, Email, Phone"
        echo "--------------------------"
        cat "$ADDRESS_BOOK_FILE"
    else
        echo "The address book is empty."
    fi
    
    read -p "Press Enter to return to the menu....."
}

# Function to remove an entry
remove_entry() {
    clear
    echo "----- Remove an Entry -----"
    read -p "Enter search term to find the entry to remove: " search_term

    # Check if the entry exists
    if ! grep -i -q "$search_term" "$ADDRESS_BOOK_FILE"; then
        echo "No records found matching '$search_term'."
        read -p "Press Enter to return to the menu....."
        return
    fi
    
    echo "Matching entries:"
    # Show the matching lines with line numbers for the user to choose
    grep -i -n "$search_term" "$ADDRESS_BOOK_FILE"
    
    read -p "Enter the EXACT full line you want to remove: " line_to_remove

    # Check if the provided line is actually in the file
    if grep -qF "$line_to_remove" "$ADDRESS_BOOK_FILE"; then
        read -p "Are you sure you want to remove this entry? (y/n): " confirm
        if [[ "$confirm" == "y" || "$confirm" == "Y" ]]; then
            # Create a temporary file containing all lines EXCEPT the one to be removed
            grep -vF "$line_to_remove" "$ADDRESS_BOOK_FILE" > temp.csv
            # Replace the original file with the temporary one
            mv temp.csv "$ADDRESS_BOOK_FILE"
            echo "Entry removed successfully."
        else
            echo "Removal cancelled."
        fi
    else
        echo "The line you entered does not match any entry. No changes made."
    fi
    
    read -p "Press Enter to return to the menu....."
}


# --- MAIN MENU and SCRIPT LOGIC ---

# Infinite loop to keep showing the menu
while true; do
    clear # Clear the screen for a clean menu
    echo "========================="
    echo "   ADDRESS BOOK MENU     "
    echo "========================="
    echo "1. Search for an entry"
    echo "2. Add a new entry"
    echo "3. Remove an entry"
    echo "4. Display all entries"
    echo "5. Exit"
    echo "-------------------------"
    read -p "Please select an option [1-5]: " choice

    # Case statement to act on the user's choice
    case $choice in
        1)
            search_entry
            ;;
        2)
            add_entry
            ;;
        3)
            remove_entry
            ;;
        4)
            display_all
            ;;
        5)
            echo "Bye"
            exit 0
            ;;
        *)
            # Default case if the input is not 1-5
            echo "Invalid option. Please try again."
            read -p "Press Enter to continue....."
            ;;
    esac
done