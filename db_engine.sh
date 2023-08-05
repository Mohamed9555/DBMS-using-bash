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
PS3="Enter the number of database operation: "
original_ps3=$PS3

select option in "${options[@]}" 
do
    case "$option" in
        "Create Database")
            export PS3="choose one of the following: "
            bash ../create_database.sh
            PS3=$original_ps3
            ;;
        "Drop Database")
            export PS3="Choose Database: "
            bash ../drop_database.sh
            PS3=$original_ps3
            ;;
        "List Databases")
            export PS3="Choose Database: "
            bash ../list_databases.sh
            PS3=$original_ps3
            ;;
        "Connect to Database") 
            export PS3="Choose Database: "
            bash ../connect_to_database.sh
            PS3=$original_ps3
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
