dirs=($(ls -F | grep /))
select database in "${dirs[@]%/}" 
do
    if [ -n "$database" ] 
    then
        cd $database
        echo $PWD
        break
    else
        echo "Invalid option"
    fi
done