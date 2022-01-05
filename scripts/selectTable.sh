# !/usr/bin/bash
projectPath=~/bash

database=ahmed


read_col()
{
    read -p "enter table name:" tableName
    if [[ -f $1/$tableName ]]
    then
        tName=$1/$tableName
        size=`wc -l $tName | awk '{ print $1 }'`
        read -p "enter the id condition or n(select all) " column 
    else
        echo "Table not found"
    fi
    eval $2="'$tName'"
    eval $3="'$size'"
    eval $4="'$column'"
    #eval $4="'$ch'"
}

selectAll()
{
    if [[ -z $3 ]]
    then 
        echo "you have to enter a choice"
        exit;
    else
        if [[ $3 = 'n' ]]
        then
            sed -e 's/:/ /g' $1 | sed -n "2,$2p"
            #-e "s/:/ /"
        else
            value=`grep -rw "$3" $1`
            if [[ -z $value ]]
            then
                echo "not an available id number"
            else
                echo $value | sed 's/:/ /g'
                #sed -e "s/:/ /g p" $value
            fi
        fi
    fi
}


if [[ $database ]]
then
    read_col "$projectPath/databases/$database" tname size column
    selectAll $tname $size $column
else
    echo "Database not found"
fi