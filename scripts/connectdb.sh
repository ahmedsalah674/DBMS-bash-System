# !/usr/bin/bash
projectPath=~/bash

echo "enter database name"

read database

if [ -d $projectPath/databases/$database  ]
then
    if [ -f $projectPath/confg/connection ]
    then
        for connectDatabase in `cat $projectPath/confg/connection  `
        do 
            if [ $connectDatabase = $database ]
            then
                echo "<<database is already connected>>"
                exit    
            fi
        done
        echo $database > $projectPath/confg/connection
        echo "<<connected sccussfully>>"
    else
        touch connection
        echo $database >> $projectPath/confg/connection
        echo "<<connected sccussfully>>"
    fi
else
    echo -e "\n<<$database not found>>\n"
fi
