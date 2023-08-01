#!/bin/bash

special_charcters_regex= # anychar that's not matching the following pattern 


while true
do
    flag=1
    read -p "Enter database name: " db_name
    # check if db_name have special characters, or starts with only characters or empty 
    if [[ $db_name =~ [^a-zA-Z0-9_-] ]]
    then
        echo "Invalid Naming, Database name can't contain special characters, Please try again "
        flag=0
    fi

    if [[ "$db_name" =~ ^[^a-zA-Z].* ]] 
    then
        echo "Invalid Naming, Database name should Start with a character, Please try again "
        flag=0
    fi

    if [[ -z "$db_name" ]]
    then
        echo "Input can't be empty, Please try again"
        flag=0
    fi

    if [ $flag -eq 1 ]
    then
    # check if db exists 
        if [ ! -d $db_name ] 
        then 
            echo "Creating database ..."
            mkdir $db_name
            break
        else
            echo "Database already exists"
            select option in "Connect" "Try another name" "Quit"
            do
                case "$option" in
                    "Connect")
                        # run connect.sh
                    ;;
                    "Try another name")
                        break
                    ;;
                    "Quit")
                        echo "GoodBye"
                        exit 0
                    ;;
                    *)
                    echo "Invalid option. Please try again."
                    ;;
                esac
            done            
        fi
    fi
done

