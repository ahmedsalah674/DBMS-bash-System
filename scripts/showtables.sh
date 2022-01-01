# !usr/bin/bash
projectPath=~/bash

echo -e '\nplease enter database name'
#read sho_database
database=$(./connectdb.sh 1)

if [ -d $projectPath/databases/$database ]
then
    ls $projectPath/databases/$database > tables.txt

    # file is not empty
    if [ -s tables.txt ]
    then
        echo -e '\n' 
        cat tables.txt
        rm tables.txt
    else
        echo 'database is empty'
    fi
else
    echo "database $database is not found"
fi