#!bin/bash 
source ../../functions.sh

show_table_info
if [ ! -s "$table_data" ]; then
    echo "$table table doesn't have data"
    sleep 2
    exit 1
fi
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
