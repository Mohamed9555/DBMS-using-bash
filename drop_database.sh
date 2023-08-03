#!/bin/bash
original_ps3="$PS3"
source ../check_name.sh
dirs=($(ls -F | grep /))

select database in "${dirs[@]%/}" 
do
    if [ -n "$database" ] 
    then
        rmdir $database
        echo "$database database deleted"
        break
    else
        echo "Invalid option"
    fi
done

PS3=$original_ps3
