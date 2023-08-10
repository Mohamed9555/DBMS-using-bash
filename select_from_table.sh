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
    read -p "would you like to insert data (y/n)? " CONFIRM
    CONFIRM=$(to_lower "$CONFIRM")
    if [ "$CONFIRM" = "y" ] 
    then
        bash ../../insert.sh
    fi
    exit 1
fi

meta_type=$(sed -n '1p' "$table_meta")
meta_name=$(sed -n '2p' "$table_meta")

IFS=':' read -ra columns_types <<< "$meta_type"
IFS=':' read -ra columns_names <<< "$meta_name"

echo "Table Columns: "

# Display columns with names and types
for ((i = 0; i < ${#columns_names[@]}; i++)); do
    col="${columns_names[i]}"
    type="${columns_types[i]}"
    echo "       $col ($type)"
done

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

PS3="Select filtering option: "
options=("all" "Where" "By Column")
select option in "${options[@]}"; do
    case "$option" in
        "all")
            header=""
            for ((i = 0; i < ${#columns_names[@]}; i++)); do
                col="${columns_names[i]}"
                if [ "$i" -eq 0 ]; then
                    header+="$col"
                else
                    header+=":$col"
                fi
            done
            echo -e "$header"
            cat $table_data
            break
            ;;
        "Where")
            # Select column for condition
            PS3="Select column for condition: "
            select condition_column in "${columns_names[@]}"; do
                if [ -n "$condition_column" ]; then
                    read -p "Enter value for condition: " condition_value
                    condition_column_index=-1
                    for i in "${!columns_names[@]}"; do
                        if [ "${columns_names[i]}" == "$condition_column" ]; then
                            condition_column_index="$i"
                            break
                        fi
                    done

                    if [ "$condition_column_index" == -1 ]; then
                        echo "Invalid column name"
                        exit 1
                    fi

                    # Read the data file and filter rows based on the condition
                    awk -v col_index="$condition_column_index" -v col_value="$condition_value" \
                        -F: '{
                            if ($(col_index + 1) == col_value) print;
                        }' "$table_data"
                    break
                else
                    echo "Invalid column"
                fi
            done
            break
            ;;
        "By Column")
            PS3="Select column to display: "
            select display_column in "${columns_names[@]}"; do
                if [ -n "$display_column" ]; then
                    # Print only the selected column
                    column_index=-1
                    for i in "${!columns_names[@]}"; do
                        if [ "${columns_names[i]}" == "$display_column" ]; then
                            column_index="$i"
                            break
                        fi
                    done
                    # Print the selected column
                    cut -d':' -f "$((column_index + 1))" "$table_data"
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