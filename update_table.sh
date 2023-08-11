#!bin/bash 
source ../../functions.sh

tables=($(ls -F | grep -v "_metadata.txt" | sed 's/\.txt$//')) # sub .txt at the end of the line with nothing 

if [ ${#tables[@]} -eq 0 ]; then
    echo "No tables were found."
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

if [ ! -s "$table_data" ]
then
    echo "$table table doesn't have data"
    while true
    do
        read -p "would you like to insert data (y/n)? " CONFIRM
        CONFIRM=$(to_lower "$CONFIRM")
        if [ "$CONFIRM" = "y" ] 
        then
            bash ../../insert.sh ### <<<<< a 2li ha7sel b3d insert
            break
        elif [ "$CONFIRM" = "n" ]
        then
            break
        else 
            echo "Invalid input choose from: (y/n)"
        fi
    done
    exit 1
fi

meta_type=$(sed -n '1p' "$table_meta")
meta_name=$(sed -n '2p' "$table_meta")

IFS=':' read -a columns_types <<< "$meta_type" # <<<< IFS  
IFS=':' read -a columns_names <<< "$meta_name" # <<<< IFS 

echo "Table Columns:"

# Display columns with names and types
for ((i = 0; i < ${#columns_names[@]}; i++)); do
    col="${columns_names[i]}"
    type="${columns_types[i]}"
    echo -e "\t $col ($type)"
done

# Display existing data
echo -e "\nExisting data in the table:"

# Print header with column names
header=""   
for ((i = 0; i < ${#columns_names[@]}; i++)); do
    col="${columns_names[i]}"
    if [ "$i" -eq 0 ]; then
        header="$col" # try this later (c1  :   c2) #  (    :   c1  :   c2)
    else
        header+="\t:$col"
    fi
done


PS3="Select filtering option: "
# Select column for condition
PS3="Select column for condition: "
select condition_column in "${columns_names[@]}"; do
    if [ -n "$condition_column" ]; then
        condition_column_index=$REPLY # saves the input number 
        read -p "Enter value for condition: " condition_value
        # Read the data file and filter rows based on the condition
        PS3="Select column to update: "
        select target_column in "${columns_names[@]}"; do
        if [ -n "$target_column" ]; then 
            target_index=$REPLY
            while true;do
                type="${columns_types[$REPLY-1]}"
                read -p "Enter new value for $target_column ($type): " new_value
                if [ -z "$new_value" ] && [ $REPLY -eq 1 ]   # <<<<<<<< look here for null input for primary key
                then
                    echo "Invalid input, primary key can't have null"
                elif [ -z "$new_value" ] 
                then
                    new_value="NULL"
                    break
                elif [ "$type" == "int" ] && ! [[ "$new_value" =~ ^[0-9]+$ ]]; then
                    echo "Invalid input. Please enter an integer."
                else [ "$type" == "string" ]
                    # No need for type checking, strings are accepted
                    break
                fi
            done
            if [ $REPLY -eq 1 ]; then
                while grep -q "^$new_value:" "$table_data"; do
                    read -p "primary key already exist enter new value: " new
                    new_value=$new
                done
            fi
            temp_file=$(mktemp)
            awk -v col_index="$condition_column_index" -v col_value="$condition_value" \
                -v target_index="$target_index" -v new_value="$new_value" \
                -v OFS=":" -F: '
                    { 
                        if ($(col_index) == col_value) {
                            $(target_index) = new_value;
                        }print;
                    }' "$table_data" > "$temp_file"
            mv "$temp_file" "$table_data"
            break
        else
            echo "No valid input"
        fi
        done
        break
    else
        echo "Invalid column"
    fi
done
