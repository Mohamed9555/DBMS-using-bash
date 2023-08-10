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
options=("all" "Where" "By Column")
select option in "${options[@]}"; do
    case "$option" in
        "all")
            awk -F: -v OFS="\t:" -v header="\n$header" 'BEGIN { print header; 
            print "------------------------------------------------------------------------------------------------------"
            } 
            { $1=$1; print }' "$table_data" # used to reformat the line 
            break
            ;;
        "Where")
            # Select column for condition
            PS3="Select column for condition: "
            select condition_column in "${columns_names[@]}"; do
                if [ -n "$condition_column" ]; then
                    condition_column_index=$REPLY # saves the input number 
                    read -p "Enter value for condition: " condition_value
                    # Read the data file and filter rows based on the condition
                    awk -v col_index="$condition_column_index" -v col_value="$condition_value" \
                        -v header="\n$header" -v OFS="\t:" -F: '
                            BEGIN { print header; 
                                    print "------------------------------------------------------------------------------------------------------"
                                    }
                            { $1=$1;
                            if ($(col_index) == col_value) print;
                            
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
                    column_index=$REPLY
                    # Print the selected column
                    cut -d':' -f "$((column_index))" "$table_data"
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
