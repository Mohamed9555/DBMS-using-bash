#!/bin/bash

dirs=($(ls -F | grep /))


if [ ${#dirs[@]} != 0 ]
then
    echo "Available Databases: ${dirs[@]%/} " # % removes / from the end of the array elements 
    read -p "Would you like to connect any database Y/N: " connection
    if [ $connection = "y" ] || [ $connection = "Y" ]
    then
    PS3="Choose Database: "
        select database in "${dirs[@]%/}" 
        do
            if [ -n "$database" ] # check the number 
            then
                cd $database
                # echo $PWD
                break
            else
                echo "Invalid option"
            fi
        done
    fi
else
    echo "No databases found"
fi



