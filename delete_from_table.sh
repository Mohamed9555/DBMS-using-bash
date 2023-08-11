#!bin/bash 
source ../../functions.sh

show_table_info

if [ ! -s "$table_data" ]; then
    echo "$table table doesn't have data"
    sleep 2
    exit 1
fi

PS3="Select filtering option: "
options=("Where" "By Column")
select option in "${options[@]}"; do
    case "$option" in
        "Where")
            # Select column for condition
            PS3="Select column for condition: "
            select condition_column in "${columns_names[@]}"; do
                if [ -n "$condition_column" ]; then
                    condition_column_index=$REPLY # saves the input number 
                    echo ""
                    read -p "Enter value for condition: " condition_value
                    # Read the data file and filter rows based on the condition
                    temp_file=$(mktemp)
                    awk -v col_index="$condition_column_index" -v col_value="$condition_value" \
                    -F: '{ if ($col_index != col_value) print; }' "$table_data" > "$temp_file"
                    if [ ! -s "$temp_file" ]; then
                        echo "No records found matching the condition."
                    else
                        # Display the filtered output
                        echo -e "Updated records:\n"
                        cat "$temp_file"
                        sleep 2
                        mv "$temp_file" "$table_data"
                        echo -e "\nRows deleted successfully."
                    fi
                    break
                else
                    echo "Invalid column"
                fi
            done
            break
            ;;
        "By Column")
            PS3="Select column to delete: "
            select deleted_column in "${columns_names[@]}"; do
                if [ -n "$deleted_column" ]; then
                    temp_file=$(mktemp)
                    column_index=$REPLY
                    if [ $column_index -eq 1 ] 
                    then
                        echo "deleting primary key not permitted"
                        echo "exiting..."
                        sleep 2
                        break
                    fi
                    temp_file=$(mktemp)
                    awk -v col_index="$column_index" \
                        -F: -v OFS=":" '{ 
                                    $(col_index) = "NULL";
                                    print;
                             }' "$table_data" > "$temp_file"
                    mv "$temp_file" "$table_data"
                    break
                    # cut -d':' --complement -f "$((column_index))" "$table_data" > "$temp_file" # adding --complements makes it select all fields except column index
                    mv "$temp_file" "$table_data"
                    echo "Column $deleted_column has been deleted"
                    break
                else
                    echo "Invalid column"
                fi
            done
            break
            ;;
        *)
            echo "Invalid option"
            ;;
    esac
done
