#!/bin/bash
source ../check_name.sh
source ../functions.sh

while true
do
    flag=1
    read -p "Enter database name: " db_name
    db_name=$(to_lower "$db_name")
    check_database_name "$db_name"
    if [ $? -eq 1 ]
    then
        if [ $flag -eq 1 ]
        then
        # check if db exists 
            if [ ! -d $db_name ] 
            then 
                echo "Creating database ..."
                mkdir $db_name
                read -p "Would you like to add a password? (Y/N)" CONFIRM
                CONFIRM=$(to_lower "$CONFIRM")
                if [ "$CONFIRM" = "y"  ]
                then
                    read -s -p "Enter database password: " db_password
                    echo # just a line break
                    echo $db_password > "$db_name"/."$db_name"_password.txt
                fi
                break
            else
                echo "Database already exists"
                PS3="choose one of the following: "
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
                            echo "GoodBye!"
                            exit 0
                        ;;
                        *)
                        echo "Invalid option. Please try again."
                        ;;
                    esac
                done            
            fi
        fi
    fi
done

PS3=$original_ps3
