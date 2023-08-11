#!/bin/bash

source ../functions.sh
export PS3="Choose one of the following: "
dirs=($(ls -F | grep /))

while true; do
    echo "Avaialabe databases:"
    for ((i = 0; i < ${#dirs[@]}; i++)); do
        echo "  $((i + 1)). ${dirs[i]%/}"
    done

    echo ""
    read -p "Enter the number of the database: " choice

    if [[ "$choice" -ge 1 && "$choice" -le ${#dirs[@]} ]]; then
        index=$((choice - 1))
        database="${dirs[index]%/}"
        check_password "$database"
        cd "$database"
        options=("Create Table" "Drop Table" "List Tables" "Insert into Table" "Update Table" "Select from Table" "Delete From Table" "Quit")
        while true; do
            echo "options for Database $database"
            for ((i = 0; i < ${#options[@]}; i++)); do
                echo "  $((i + 1)). ${options[i]}"
            done

            echo ""
            read -p "Enter the number of table operation: " table_choice

            if [[ "$table_choice" -ge 1 && "$table_choice" -le ${#options[@]} ]]; then
                table_index=$((table_choice - 1))

                case "${options[table_index]}" in
                    "Create Table")
                        bash ../../create_table.sh
                        ;;
                    "Drop Table")
                        export PS3="Choose Table: "
                        bash ../../drop_table.sh
                        PS3="Choose one of the following: "
                        ;;
                    "List Tables")
                        export PS3="Choose Table: "
                        bash ../../list_tables.sh
                        PS3="Choose one of the following: "
                        ;;
                    "Insert into Table")
                        export PS3="Choose Table: "
                        bash ../../insert.sh
                        PS3="Choose one of the following: "
                        ;;
                    "Update Table")
                        export PS3="Choose Table: "
                        bash ../../update_table.sh "$temp_file1" "$temp_file2"
                        PS3="Choose one of the following: "
                        ;;
                    "Select from Table")
                        export PS3="Choose Table: "
                        bash ../../select_from_table.sh
                        PS3="Choose one of the following: "
                        ;;
                    "Delete From Table")
                        export PS3="Choose Table: "
                        bash ../../delete_from_table.sh
                        PS3="Choose one of the following: "
                        ;;
                    "Quit")
                        echo "Goodbye!"
                        exit 0
                        ;;
                    *)
                        echo "Invalid option, please try again"
                        ;;
                esac
            else
                echo "Invalid table option, please try again"
            fi

            echo ""
        done

    else
        echo "Invalid database number, please try again"
    fi

    echo ""
done
