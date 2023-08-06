export PS3="choose one of the following: "
dirs=($(ls -F | grep /))
select database in "${dirs[@]%/}" 
do
    if [ -n "$database" ] 
    then
        cd $database
        # table menu 
        options=("Create Table" "Drop Table" "List Tables" "Insert into Table" "Update Table" "Select from Table" "Delete From Table" "Quit")
        select option in "${options[@]}" 
        do
            case "$option" in
                "Create Table")
                    bash ../../create_table.sh
                    break
                    ;;
                "Drop Table")
                    export PS3="Choose Table: "
                    bash ../../drop_table.sh
                    PS3=$original_ps3
                    break
                    ;;
                "List Tables")
                    export PS3="Choose Table: "
                    bash ../../list_tables.sh
                    PS3=$original_ps3
                    break
                    ;;
                "Insert into Table") 
                    export PS3="Choose Table: "
                    bash ../../insert.sh
                    PS3=$original_ps3
                    break
                    ;;    
                "Update Table") 
                    export PS3="Choose Table: "
                    bash ../../connect_to_table.sh
                    PS3=$original_ps3
                    break
                    ;;
                "Select From Table") 
                    export PS3="Choose Table: "
                    # select from table script
                    PS3=$original_ps3
                    break
                    ;;
                "Delete From Table") 
                    export PS3="Choose Table: "
                    # Delete from table script
                    PS3=$original_ps3
                    break
                    ;;
                "Quit")
                    echo "Goodbye!" 
                    exit 0
                    ;;
                *)
                    echo "Invalid option, please try again"
                    ;;
            esac
        done
        break
    else
        echo "Invalid option"
    fi
done


# might be used with functions script
# export PS3="choose one of the following: "
# dirs=($(ls -F | grep /))
# source ../functions.sh
# select database in "${dirs[@]%/}" 
# do
#     if [ -n "$database" ] 
#     then
#         cd $database
#         connect_options
#         # table menu         
#         break
#     else
#         echo "Invalid option"
#     fi
# done