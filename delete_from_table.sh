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

IFS=':' read -a columns_types <<< "$meta_type" # <<<< IFS  why -r ?
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

# if [ -s $table_data ]
# then
#     echo "$header"
#     # cat $table_data
# else
#     echo "$header"
#     echo "No data yet"
# fi

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
                    read -p "Enter value for condition: " condition_value
                    # Read the data file and filter rows based on the condition
                    temp_file=$(mktemp)
                    awk -v col_index="$condition_column_index" -v col_value="$condition_value" \
                    -F: '{ if ($col_index != col_value) print; }' "$table_data" > "$temp_file"
                    if [ ! -s "$temp_file" ]; then
                        echo "No records found matching the condition."
                    else
                        # Display the filtered output
                        echo "Filtered records:"
                        cat "$temp_file"
                        mv "$temp_file" "$table_data"
                        echo "Rows deleted successfully."
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
                    cut -d':' --complement -f "$((column_index))" "$table_data" > "$temp_file" # adding --complements makes it select all fields except column index
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
