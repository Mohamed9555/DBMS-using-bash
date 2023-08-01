#!/bin/bash

dirs=($(ls -F | grep /))
if [ ! -n "$1" ]
then
    echo "Available Databases: ${dirs[@]%/} "
    read -p "Would you like to connect any database Y/N: " connection
    if [ $connection = "y" ] || [ $connection = "Y" ]
    then
    PS3="Enter the number of the database you want to select: "
        select database in "${dirs[@]%/}" 
        do
            if [ -n "$database" ] 
            then
                cd $database
                # echo $PWD
                break
            else
                echo "Invalid option"
            fi
        done
    fi
fi


# this might be used in the connect_to_database script
if [ -n "$1" ]
then
    PS3="Enter the number of the database you want to select: "
    select database in "${dirs[@]%/}" 
    do
        if [ -n "$database" ] 
        then
            echo "hello"
            break
        else
            echo "Invalid option"
        fi
    done
fi