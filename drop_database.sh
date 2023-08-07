#!/bin/bash
original_ps3="$PS3"
source ../check_name.sh
source ../functions.sh
dirs=($(ls -F | grep /))

select database in "${dirs[@]%/}" 
do
    if [ -n "$database" ] 
    then
        check_password "$database"
        echo "You want to delete database: $database" 
        read -p "Are you sure? (y/n): " CONFIRM
        if [ "$CONFIRM" = "y" ]
        then
            rm -rf $database # force delete write protected files without confirm 
            echo "$database database deleted"
            break
        else
            break
        fi
    else
        echo "Invalid option"
    fi
done

PS3=$original_ps3
