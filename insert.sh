#!bin/bash
source ../../functions.sh

tables=($(ls -F | grep -v "_metadata.txt" | sed 's/\.txt$//')) # sub .txt at the end of the line with nothing 

if [ ${#tables[@]} -eq 0 ]; then
    echo "No tables were found."
    sleep 2
    exit 1
fi

table_data=
table_meta=
PS3="Choose table: "
select table in "${tables[@]}" 
do  
    if [ -n "$table" ] # check the number
    then
        table_data="$table".txt
        table_meta="$table"_metadata.txt
        # echo $PWD
        break
    else
        echo "Invalid option"
    fi
done

echo "Table Columns:"

meta_type=$(sed -n '1p' "$table_meta") # first line has the type 
meta_name=$(sed -n '2p' "$table_meta") # second line has the name 

IFS=':' read -ra columns_types <<< "$meta_type"
IFS=':' read -ra columns_names <<< "$meta_name"


# Display columns with names and types
for ((i = 0; i < ${#columns_names[@]}; i++)); do
    col="${columns_names[i]}"
    type="${columns_types[i]}"
    echo "       $col ($type)"
done

sleep 2

# Display existing data
echo -e "\nExisting data in the table:"

# Print header with column names
header=""
for ((i = 0; i < ${#columns_names[@]}; i++)); do
    col="${columns_names[i]}"
    if [ "$i" -eq 0 ]; then
        header+="$col"
    else
        header+=":$col"
    fi
done

if [ -s $table_data ]
then
    echo "$header"
    cat $table_data
else
    echo "$header"
    echo "No data yet"
fi
# Prompt for data input for each column
data=""
for ((i = 0; i < ${#columns_names[@]}; i++)); do
    col="${columns_names[i]}"
    type="${columns_types[i]}"
    while true; do
        read -p "Enter value for $col ($type): " value
        # Perform type checking
         if [ -z "$value" ] && [ $i -eq 0 ]   # <<<<<<<< look here for null input for primary key
        then
            echo "Invalid input, primary key can't have null"
        elif [ -z "$value" ] 
        then
            value="NULL"
            break
        elif [ "$type" == "int" ] && ! [[ "$value" =~ ^[0-9]+$ ]]; then
            echo "Invalid input. Please enter an integer."
        else [ "$type" == "string" ]
            # No need for type checking, strings are accepted
            break
        fi
    done
    # cheking primary key already exists?
    if [ "$i" == "0" ]; then
        while grep -q "^$value:" "$table_data"; do
            read -p "Value for $col already exists. Do you want to overwrite? (y/n): " overwrite
            if [ "$overwrite" == "y" ] || [ "$overwrite" == "Y" ]; then
                # Remove the existing line with the same value
                sed -i "/^$value:/d" "$table_data"
                break
            else
                read -p "Enter a new value for $col: " value
            fi
        done
    fi
    # elif [ "$i" == "0" ] && [ -z "$value" ] 
    # then
    #     echo "here"
    # fi
data+=":$value"
done
# Remove the leading colon from the data
data="${data#:}"

# Append the data to the file
echo "$data" >> "$table_data"
echo "Data inserted successfully."
