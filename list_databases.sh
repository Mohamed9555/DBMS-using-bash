#!/bin/bash

dirs=($(ls -F | grep /))


if [ ${#dirs[@]} != 0 ]
then
    echo "Available Databases: ${dirs[@]%/} " # % removes / from the end of the array elements 
    read -p "Would you like to connect any database Y/N: " connection
    if [ $connection = "y" ] || [ $connection = "Y" ]
    then
        bash ../connect_to_database.sh           
    else
        exit 0
    fi
else
    echo "No databases found"
fi


