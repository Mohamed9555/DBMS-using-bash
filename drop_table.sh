#!/bin/bash
source ../../functions.sh
tables=($(ls -F | grep -v "_metadata.txt" | sed 's/\.txt$//')) # sub .txt at the end of the line with nothing 


if [ ${#tables[@]} -eq 0 ]
then
    echo "No tables found."
else
    select table in "${tables[@]%/}" 
    do
        if [ -n "$table" ] 
        then
            echo "You want to delete table: $table" 
            read -p "Are you sure? (y/n): " CONFIRM
            if [ "$CONFIRM" = "y" ]
            then
                rm "$table".txt "$table"_metadata.txt 
                echo "$table table deleted" 
                break
            else
                break
            fi
        else
            echo "Invalid option"
        fi
    done
fi



