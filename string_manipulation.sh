#!/bin/bash

# Initialize variables
modify_file="yes"
count=1

# Start loop for file modifications
while [ "$modify_file" == "yes" ]; do

    # Prompt user for file name
    read -p "Which file would you like to perform actions on? " varfile

    # Prompt user for action type
    read -p "Enter the number for the type of action you would like to take:
    1 - delete all lines where the given string occurs.
    2 - delete all occurrences of a string from the file where the string entered matches exactly to the string in the file.
    3 - delete all numbers from a file.
    4 - find the number of times a given string occurs.
    5 - find the line numbers where a given string occurs 
    
    " varoption

    # Create a backup of the file if action type is 1, 2, or 3
    if [[ "$varoption" == "1" || "$varoption" == "2" || "$varoption" == "3" ]]; then
        backup_file="$varfile.bak.for_iteration_$count"
        cp "$varfile" "$backup_file"
    fi  

    # Perform actions based on selected option
    if [[ "$varoption" == "1" || "$varoption" == "2" ]]; then
        # Prompt user for the string to be manipulated
        read -p "Enter the string: " varword

        if [[ "$varoption" == "1" ]]; then
            # Delete all lines containing the specified string
            sed -i "" -e "/$varword/d" "$varfile"
            echo "The option selected is 1: All lines containing the string $varword have been deleted"
        elif [[ "$varoption" == "2" ]]; then
            # Delete all occurrences of the specified string
            sed -i "" -e "s/$varword//g" "$varfile"
            echo "The option selected is 2: All occurrences of the string $varword have been deleted"
        fi  
    elif [[ "$varoption" == "3" ]]; then
        # Delete all numbers from the file
        sed -i '' -E 's/[0-9]*//g' "$varfile"
        echo "The option selected is 3: All numbers have been deleted"
    elif [[ "$varoption" == "4" ]]; then
        # Find the number of occurrences of a specified string
        read -p "Enter the string to find its occurrences: " varword
        occurrences=$(grep -o -i -w "$varword" "$varfile" | wc -l)
        echo -e "The number of occurrences of the word in the file are $occurrences\n"   
    elif [[ "$varoption" == "5" ]]; then
        # Find the line numbers where a specified string occurs
        read -p "Enter the string to find its line numbers: " varword
        echo -e "The line numbers corresponding to the above lines are as follows..."
        awk -v varword="$varword" '$0 ~ varword { print NR; }' "$varfile"
    else
        echo "Invalid option selected."
    fi  

    # Ask user if they want to perform more actions on the file
    read -p "Would you like to take any other actions on the file? yes/no: " modify_file
    
    # Increment iteration count
    ((count++))
done
