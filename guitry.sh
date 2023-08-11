#!/bin/bash

# Create database directory if not exist 
if [ ! -d "databases" ]; then
    mkdir databases
fi
# change to the databases directory
cd databases


zenity --info --text="Welcome to My Database Management Script (DBMS)!\n$ You can choose from the following options:" --title="DBMS" --width=300 --height=150

options=("Create Database" "Drop Database" "List Databases" "Connect to Database" "Quit")

option=$(zenity --list --column="Options" "${options[@]}" --title="Choose an option")

case "$option" in
    "Create Database")
        zenity --info --text="Create Database selected" --title="Create Database" --width=200 --height=100
        bash ../create_database.sh
        ;;
    "Drop Database")
        db_name=$(zenity --entry --title="Drop Database" --text="Enter the name of the database to drop:" --entry-text "")
        zenity --info --text="Dropping database '$db_name'" --title="Database Dropped" --width=250 --height=100
        ;;
    "List Databases")
        zenity --info --text="List Databases selected" --title="List Databases" --width=200 --height=100
        ;;
    "Connect to Database")
        zenity --info --text="Connect to Database selected" --title="Connect to Database" --width=250 --height=100
        ;;
    "Quit")
        zenity --info --text="Goodbye!" --title="Quit" --width=150 --height=100
        ;;
    *)
        zenity --info --text="Invalid option, please try again" --title="Error" --width=250 --height=100
        ;;
esac
