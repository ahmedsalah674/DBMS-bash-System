# !/usr/bin/bash
projectPath=~/bash
# echo "enter database name"
# read database
create_connection()
{
    database=$1
    if [ -d $2/databases/$database  ]
    then
        if [ -f $2/confg/connection ]
        then
            for connectDatabase in `cat $2/confg/connection  `
            do 
                if [ $connectDatabase = $database ]
                then
                    echo "<<database is already connected>>"
                    exit    
                fi
            done
            echo $database > $2/confg/connection
            echo "<<connected sccussfully>>"
        else
            touch $2/confg/connection
            echo $database >> $2/confg/connection
            echo "<<connected sccussfully>>"
        fi
    else
        echo -e "\n<<$database not found>>\n"
    fi
}
connected_database()
{
    if [[ -f $1/confg/connection ]]
    then
        echo `head -1 $1/confg/connection`
    else
        touch $1/confg/connection
        echo `head -1 $1/confg/connection`
    fi
}
if [[ $1 = 1 ]]
then
    connected_database  $projectPath
elif [[ $1 ]]
then
    create_connection $1 $projectPath
else
    echo "<<Wrong call>>"
fi
