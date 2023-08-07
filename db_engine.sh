#!/bin/bash

# Create database directory if not exist 
if [ ! -d "databases" ]; then
    mkdir databases 
fi
# change to the databases directory
cd databases 

echo  "Welcome to My Database Management Script (DBMS)!"

options=("Create Database" "Drop Database" "List Databases" "Connect to Database" "Quit")
option_number=1

while true; do
    echo "Main Menu:"
    for option in "${options[@]}"; do
        echo "     $option_number. $option"
        ((option_number++))
    done
    option_number=1

    echo ""
    read -p "Enter the number of database operation: " choice

    case "$choice" in
        1)
            export PS3="Choose one of the following: "
            bash ../create_database.sh
            ;;
        2)
            export PS3="Choose Database: "
            bash ../drop_database.sh
            ;;
        3)
            export PS3="Choose Database: "
            bash ../list_databases.sh
            ;;
        4)
            export PS3="Choose Database: "
            bash ../connect_to_database.sh
            ;;
        5)
            echo "Goodbye!" 
            exit 0
            ;;
        *)
            echo "Invalid option, please try again"
            ;;
    esac

    echo ""
done
