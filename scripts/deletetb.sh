# !/usr/bin/bash
projectPath=~/bash

#database=$2
database=ahmed

if [[ $database ]]
then
    read -p "enter table name:" tableName
    if [[ -f $projectPath/databases/$database/$tableName ]]
    then
    tName=$projectPath/databases/$database/$tableName
        read -p "do you want to add a condition? [y/n]:" ch
        if [[ $ch = 'y' ]]
        then 
            read -p "enter the id you want to delete: " ID
            #IFS=$'\n' read -d : -r -a lines <<< $projectPath/databases/$database/$tableName
            size=`wc -l $tName | awk '{ print $1 }'`
            #IFS=$' ' read -r -a lines <<< $size
            #echo $size
            #echo `tail -$(( $size-1 ))`
            i=0
            for number in `tail -$(( $size-1 )) $tName|cut -d: -f 2 | grep -nw $ID  | cut -d: -f 1` #| grep -nw ahmed | cut -d: -f 1`
            do
                echo "(($i))"
                echo the id = $(($number-$i+1))
                sed -i "$(($number-$i+1)) d" $tName
                i=$(($i+1))
            done

            #echo "${lines[1]}"
            # while()
            # do 

            # done
        elif [[ $ch = 'n' ]]
        then
            echo "No"
        else
            echo "wrong entery"
        fi
    else
        echo "Table not found"
    fi
else
    echo "Database not found"
fi
# delete_main()
# {
#     database=$2
#     if [[ $database ]]
#     then
#         read -p "enter table name :" tableName
#         if [[ -f $1/databases/$database/$tableName ]]
#         then
#             structureAndnumber "$1/databases/$database/$tableName"  columnsNumber
#             insertValues "$1/databases/$database/$tableName" $columnsNumber
#         else
#             echo $1/databases/$database/$tableName    
#             echo "<<table not found>>"
#         fi
#     else
#         echo "<<no database connection>>"
#     fi
# }