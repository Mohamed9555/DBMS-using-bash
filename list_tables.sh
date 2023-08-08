#!bin/bash

tables=($(ls -F | grep -v "_metadata.txt" | sed 's/\.txt$//')) # sub .txt at the end of the line with nothing 


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
                cat "$table".txt
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
