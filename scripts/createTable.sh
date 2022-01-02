# !/usr/bin/bash
projectPath=~/bash
fun()
{
    expr $1 + 1 2> /dev/null >> /dev/null
}
read_data()
{
    local  TABLEVAR=$1
    local  COLUMNSVAR=$2
    read -p "enter table name: " TABLE_NAME
    if [ -f  $3/$TABLE_NAME ]
    then
        echo "<<table already exited>>"
        exit 2
    else
        while [ true ]
        do
            read -p "enter how many columns: " COLUMN_NUM
            fun $COLUMN_NUM
            if [[ $? = 0 ]]
            then
                break
            else
                echo "<<number of coulmns must be number>>"
            fi
        done
    fi
    eval $TABLEVAR="'$TABLE_NAME'"
    eval $COLUMNSVAR="'$COLUMN_NUM'"
    
}
read_coulmns_names()
{
    export COLUMNS_NAMES_var=$2
    local  PK_VAR=$3
    i=0
    while [ $i -lt $1 ]
    do
        read -p "enter column name:" COLUMNS_NAMES[$i]
        if ! [ $PK ]
        then
            while true
            do
                read -p "are you want it primary key? [y/n]: " answer
                if [[ $answer = 'y' ]]
                then
                    PK=$i
                    break
                elif [ $answer = 'n' ]
                then
                    break            
                fi
            done
        fi
        i=$(expr $i + 1)
    done
    eval $COLUMNS_NAMES_var="'${COLUMNS_NAMES[@]}'"
    eval $PK_VAR="'$PK'"   
}
create_table_file()
{
    i=0
    touch  $1
    for name in ${COLUMNS_NAMES[*]}
    do 
        if [ $i = 0 ]
        then
        structure=$name  
        else
            structure=$structure":"$name
        fi
        i=$(( $i + 1 ))
    done
    echo $structure > $1

}
main()
{
    database=$1
    if [[ $database ]]
    then
        if [ -d $2/databases/$database  ]
        then
            read_data tableName columnNumber "$2/databases/$database"
            typeset columnNames[$columnNumber]
            read_coulmns_names $columnNumber columnNames pk
            create_table_file "$2/databases/$database/$tableName" $columnNames
            # echo "you want to create table ( $tableName ) with ( $columnNumber ) and names ( ${columnNames[*]} ) and primary key in ( $pk ) "
        elif ! [ -d $2 ]  
        then
            echo "project must be in $2"
        else
            echo "$database not found"
        fi
    else
        echo "no database connection "
    fi
}

main $(./connectdb.sh 1) $projectPath


# function myfunc()
# {
#     local  __resultvar=$1
#     local  myresult='some value'
    
#     eval $__resultvar="'$myresult'"
# }
# myfunc result
# echo $result