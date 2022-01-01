# !usr/bin/bash

projectPath=~/bash
database=$(./connectdb.sh 1)

echo -e '\nenter the table name'
read table


if [[ $database ]]
then
    if [ -f $projectPath/databases/$database/$table ]
    then 
        while [ true ]
        do
            read -p 'are you sure? [y/n] : ' answer

            if [ $answer = "y" ]
            then
                rm $projectPath/databases/$database/$table
                echo "table $table is deleted"
                break
            elif [ $answer = "n" ]
            then
                break
            else
                echo -e '\ninvalid choice, try again'
                continue
            fi
        done
    else
        echo "table $table is not found"
    fi
else
    echo -e '\nyou did not connect to a database'
fi
