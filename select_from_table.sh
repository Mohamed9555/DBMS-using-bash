#!bin/bash 
source ../../functions.sh

show_table_info
if [ ! -s "$table_data" ]; then
    echo "$table table doesn't have data"
    sleep 2
    exit 1
fi


PS3="Select filtering option: "
options=("all" "Where" "By Column")
select option in "${options[@]}"; do
    case "$option" in
        "all")
            awk -F: -v OFS=":" -v header="\n$header" 'BEGIN { print header; 
            print "------------------------------------------------------------------------------------------------------"
            } 
            { $1=$1; print }' "$table_data" # used to reformat the line 
            sleep 2
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
                        -v header="\n$header" -F: '
                            BEGIN { print header; 
                                    print "------------------------------------------------------------------------------------------------------"
                                    }
                            { 
                            if ($(col_index) == col_value) print;
                            
                        }' "$table_data"
                    break
                else
                    echo "Invalid column"
                fi
            done
            sleep 2
            break
            ;;
        "By Column")
            PS3="Select column to display: "
            select display_column in "${columns_names[@]}"; do
                if [ -n "$display_column" ]; then
                    # Print only the selected column
                    column_index=$REPLY
                    # Print the selected column
                    echo -e "\n"
                    echo "$display_column"
                    echo "------------------------"
                    cut -d':' -f "$((column_index))" "$table_data"
                    break
                else
                    echo "Invalid column"
                fi
            done
            sleep 2
            break
            ;;
        *)
            echo "Invalid option"
            ;;
    esac
done
