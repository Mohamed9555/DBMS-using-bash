#!/bin/bash

#create file
metadata_file="metadata.txt" #chaeck the txt path

#take the metadata name & type from the user
read -p "Enter the column name: " metadata_name #column_name
read -p "Enter the column data type: " metadata_type #column_data_type


#store & view meatadata file content
echo "$metadata_name:$metadata_type" >> "metadata.file"

echo "The stored data is: "
echo "Column_name $metadata_name : Column_type $metadata_type" 