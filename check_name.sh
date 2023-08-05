#!bin/bash/


check_database_name() {
    local db_name="$1"
    local flag=1
    local max_length=30


    if [[ $db_name =~ [^a-zA-Z0-9_]*$ ]];
    then
        echo "Invalid Naming, Database name can't contain special characters, Please try again "
        return 0
    fi

    if [[ "$db_name" =~ ^[^a-zA-Z].* ]];
    then
        echo "Invalid Naming, Database name should Start with a character, Please try again "
        return 0
    fi

    if [[ -z "$db_name" ]];
    then
        echo "Input can't be empty, Please try again"
        return 0
    fi

    if [[ ${db_name} -gt $max_length ]];
    then
        echo "Invalid Naming, Database name exceeded the maximum length limit of $max_length characters. Try again "
        return 0
    fi

    return 1
}


