#!bin/bash

tables=($(ls -F | grep -v /)) # not ending with /


if [ ${#tables[@]} != 0 ]
then
    echo "Available tables: ${tables[@]} "  
    read -p "Would you like to show certian table Y/N: " show
    if [ $show = "y" ] || [ $show = "Y" ]
    then
    PS3="Choose table: "
        select table in "${tables[@]}" 
        do
            if [ -n "$table" ] # check the number 
            then
                cat $table
                # echo $PWD
                break
            else
                echo "Invalid option"
            fi
        done
    fi
else
    echo "No tables found"
fi
