#!/bin/bash

# Create database directory if not exist 
if [ ! -d "databases" ]
then
    mkdir databases 
fi
# change to the databases directory
cd databases 
# echo $PWD

YELLOW='\033[1;33m'
RESET='\033[0m'

echo -e "${YELLOW}Welcome to My Database Management Script (DBMS)!"
echo -e "${RESET}You can choose from the following options:"


options=("Create Database" "Drop Database" "List Databases" "Connect to Database" "Quit")
PS3="Enter the number of option: "

select option in "${options[@]}" 
do
    case "$option" in
        "Create Database")
            # create_database.sh
            source ../create_database.sh
            ;;
        "Drop Database")
            echo "Hello"
            # drop_database.sh
            ;;
        "List Databases")
            # list_databases.sh
            ;;
        "Connect to Database") 
            # connect_database.sh
            ;;
        "Quit")
            echo "Goodbye!" 
            exit 0
            ;;
        *)
            echo "Invalid option, please try again"
            ;;
    esac
done 
