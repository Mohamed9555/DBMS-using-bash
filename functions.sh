#!bin/bash


check_name() {
    local db_name="$1"
    local flag=1
    local max_length=64


    if [[ $db_name =~ [^a-zA-Z0-9_] ]];
    then
        echo "Invalid Naming, Database name can't contain special characters, Please try again "
        return 0
    fi

    if [[ "$db_name" =~ ^[^a-zA-Z_].* ]];
    then
        echo "Invalid Naming, Database name should Start with a character, Please try again "
        return 0
    fi

    if [[ -z "$db_name" ]];
    then
        echo "Input can't be empty, Please try again"
        return 0
    fi

    if [[ ${db_name} -gt $max_length ]];
    then
        echo "Invalid Naming, Database name exceeded the maximum length limit of $max_length characters. Try again "
        return 0
    fi

    return 1
}






function connect_options(){
    options=("Create Table" "Drop Table" "List Tables" "Update Table" "Select from Table" "Delete From Table" "Quit")
        select option in "${options[@]}" 
        do
            case "$option" in
                "Create Table")
                    bash ../../create_table.sh
                    break
                    ;;
                "Drop Table")
                    export PS3="Choose Table: "
                    bash ../../drop_table.sh
                    PS3=$original_ps3
                    break
                    ;;
                "List Tables")
                    export PS3="Choose Table: "
                    bash ../../list_tables.sh
                    PS3=$original_ps3
                    break
                    ;;
                "Update Table") 
                    export PS3="Choose Table: "
                    bash ../../connect_to_table.sh
                    PS3=$original_ps3
                    break
                    ;;
                "Select From Table") 
                    export PS3="Choose Table: "
                    # select from table script
                    PS3=$original_ps3
                    break
                    ;;
                "Delete From Table") 
                    export PS3="Choose Table: "
                    # Delete from table script
                    PS3=$original_ps3
                    break
                    ;;
                "Quit")
                    echo "Goodbye!" 
                    exit 0
                    ;;
                *)
                    echo "Invalid option, please try again"
                    ;;
            esac
        done
}


# function select_database(){

# }



# function select_table(){


# }




function remove_table() {
    tables=($(ls -F | grep -v "_metadata.txt" | sed 's/\.txt$//')) # sub .txt at the end of the line with nothing 
    select table in "${tables[@]%/}" 
    do
        if [ -n "$table" ] 
        then
            rm "$table".txt "$table"_metadata.txt 
            echo "$table table deleted"
            ls 
            break
        else
            echo "Invalid option"
        fi
    done
}


function to_lower() { # system is incasesensitive 
    echo "${1,,}" 
}


function check_password() {
    if [ -f "$database"/."$database"_password.txt ]
        then
            max_tries=3
            remaining_tries=$max_tries
            stored_password=$(cat "$database"/."$database"_password.txt)
            while true
            do
                if [ $remaining_tries -eq 0 ]
                then
                    echo "Exiting .."
                    exit 1
                fi
                read -s -p "Enter password: " entered_password
                echo # line break
                # echo $entered_password $stored_password
                if [ "$entered_password" == "$stored_password" ] 
                then
                    break    
                else 
                    remaining_tries=$((remaining_tries-1))
                    echo $remaining_tries
                    echo "incorrect password, you have $remaining_tries remaining tries" 
                fi
            done
        fi
}

hash_password() {
    local password="$1"
    # generate random number (salt) with 16 bytes
    local salt=$(openssl rand -hex 16) # Generate a random salt
    local hashed_password=$(echo -n "$password$salt" | sha512sum | awk '{print $1}') #from sha512sum <hash_value>  <file_path>
    echo "$salt:$hashed_password"
}


function read_table() {
    echo "Avaialabe Tables:"
    for ((i = 0; i < ${#tables[@]}; i++)); do
        echo "  $((i + 1)). ${tables[i]%/}"
    done
    table=
    read -p "Enter table choice: " choice

    if [[ "$choice" -ge 1 && "$choice" -le ${#tables[@]} ]]; then
        index=$((choice - 1))
        table="${tables[index]%/}"    
    fi
    table_data="$table.txt"
    table_meta="$table"_metadata.txt


    meta_type=$(sed -n '1p' "$table_meta")
    meta_name=$(sed -n '2p' "$table_meta")

    IFS=':' read -ra columns_types <<< "$meta_type"
    IFS=':' read -ra columns_names <<< "$meta_name"

    # Display available columns for the user to choose
    echo "Available columns: ${columns_names[*]}"

    # Prompt for column and value for the condition
    PS3="Select a condition column: "
    condition_column=
    select column in "${columns_names[@]}"
    do
        if [ -n "$column" ]
        then
            condition_column=$column
            echo "$condition_column"
            break
        else
            echo "Invalid column"
    fi
    done
    # read -p "Enter column name for condition: " condition_column
    read -p "Enter value for condition: " condition_value

    # Find the index of the condition column in the array
    condition_column_index=-1
    for i in "${!columns_names[@]}"; do
        if [ "${columns_names[i]}" == "$condition_column" ]; then
            condition_column_index="$i"
            break
        fi
    done
    if [ "$condition_column_index" == -1 ]; then
        echo "Invalid column name"
    fi
    local return_values=("$condition_column_index" "$condition_value" "$table_data")
    echo "${return_values[@]}"
}