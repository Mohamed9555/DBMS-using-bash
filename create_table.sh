#/bin/bash
source ../../check_name.sh

meta_file=
data_file=

while true # check if exists and naming 
do
    read -p "Enter table name: " table
    meta_file=""$table"_metadata.txt"
    data_file="$table".txt
    if [ ! -f "$data_file" ] || [ ! -f "$meta_file" ] # check if exists
    then
        check_table_name "$table"
        if [ $? -eq 1 ]
        then 
            break
        fi
    else 
        echo "name already exists try another name!"
    fi
done

read -p "Enter number of fields: " no_of_fields


# echo $output_file
types=("int" "string")
PS3="Enter primary key type: "
primary_type=
select type in "${types[@]}"
do
    case "$type" in
        "int")
            primary_type="int"
            break
            ;;
        "string")
            primary_type="string"
            break
            ;;
        *)
            echo "Invalid datatype"
            ;;
    esac
done

while true
do
    read -p "Enter primary key name: " primary_name
    check_column_name "$primary_name"
    if [ $? -eq 1 ]
    then
        break
    fi
done
# check_column_name "$primary name"
# echo $primary_name
PS3="Enter column type: "
columns_types="$primary_type:"
columns_names="$primary_name:"
column_type=
for ((n = 2; n <= no_of_fields; n++))
do
    select type in "${types[@]}"
    do
        case "$type" in
            "int")
                column_type="int"
                break
                ;;
            "string")
                column_type="string"
                break
                ;;
            *)
                echo "Invalid datatype"
                ;;
        esac
    done
    columns_types+="$column_type":
    while true
    do
        read -p "Enter column name: " column_name
        check_column_name "$column_name"
        if [ $? -eq 1 ]
        then
            break
        fi
    done
    columns_names+="$column_name":
done
columns_names="${columns_names%:}"
columns_types="${columns_types%:}"

echo "$columns_types" >> $meta_file
echo "$columns_names" >> $meta_file
touch "$data_file"