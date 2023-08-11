#!bin/bash
source ../../functions.sh

show_table_info

# Display existing data
echo -e "\nExisting data in the table:"

# Print header with column names
if [ -s $table_data ]
then
    echo -e "$header"
    cat $table_data
else
    echo -e "$header"
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
