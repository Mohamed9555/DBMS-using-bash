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

show_table_info() {
    tables=($(ls -F | grep -v "_metadata.txt" | sed 's/\.txt$//')) # sub .txt at the end of the line with nothing 
    if [ ${#tables[@]} -eq 0 ]; then
        echo "No tables were found."
        exit 1
    fi

    table_data=
    table_meta=
    PS3="Choose table: "
    select table in "${tables[@]}"; do
        if [ -n "$table" ]; then
            table_data="$table".txt
            table_meta="$table"_metadata.txt
            break
        else
            echo "Invalid option"
        fi
    done


    meta_type=$(sed -n '1p' "$table_meta")
    meta_name=$(sed -n '2p' "$table_meta")

    IFS=':' read -a columns_types <<< "$meta_type"
    IFS=':' read -a columns_names <<< "$meta_name"

    echo "Table Columns:"

    for ((i = 0; i < ${#columns_names[@]}; i++)); do
        col="${columns_names[i]}"
        type="${columns_types[i]}"
        echo -e "\t $col ($type)"
    done


    # Print header with column names
    header=""
    for ((i = 0; i < ${#columns_names[@]}; i++)); do
        col="${columns_names[i]}"
        if [ "$i" -eq 0 ]; then
            header="$col"
        else
            header+=":$col"
        fi
    done
    export table_data header columns_names columns_types
}








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