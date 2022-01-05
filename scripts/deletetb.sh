# !/usr/bin/bash
projectPath=~/bash

#database=$2
database=ahmed

read_col()
{
    read -p "enter table name:" tableName
    if [[ -f $1/$tableName ]]
    then
        tName=$1/$tableName
        read -p "do you want to add a condition? [y/n]:" ch
        if [[ $ch = 'y' ]]
        then 
            read -p "enter the id you want to delete: " ID
            
        elif [[ $ch = 'n' ]]
        then
            echo "No"
        else
            echo "wrong entery"
        fi
        size=`wc -l $tName | awk '{ print $1 }'`
    else
        echo "Table not found"
    fi
    eval $2="'$tName'"
    eval $3="'$size'"
    eval $5="'$ID'"
    eval $4="'$ch'"
}

delete_col()
{
    if [[ $3 = 'y' ]]
    then
        #base 
        i=0
        for number in `tail -$(( $2-1 )) $1|cut -d: -f 1 | grep -nw $4  | cut -d: -f 1` #| grep -nw ahmed | cut -d: -f 1`
        do
            #echo the id = $(($number-$i+1))
            sed -i "$(($number-$i+1)) d" $1
            i=$(($i+1))
        done  
    elif [[ $3 = 'n' ]]
    then
        echo "No"
        sed -i "2,$2 d" $1
    fi
}

if [[ $database ]]
then
    read_col "$projectPath/databases/$database" tname size choice ID
    delete_col $tname $size $choice $ID
else
    echo "Database not found"
fi