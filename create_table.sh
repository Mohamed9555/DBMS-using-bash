#/bin/bash

num_of_fields=2
output_file="test.txt"


types=("int" "string")
read -p "Enter primary key name: " primary_name
# echo $primary_name 
primary_type=
PS3="Enter primary key type: "
select type in "${types[@]}"
do
    case "$type" in
        "int")
            primary_type="int"
            echo "type = $primary_type"
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

columns_types="$primary_type:"
columns_names="$primary_name:"
for n in {1..2} 
do
    read -p "Enter column type: " column_type
    columns_types+="$column_type":
    read -p "Enter column name: " column_name
    columns_names+="$column_name":
done

echo "$columns_names"
echo "$columns_types"