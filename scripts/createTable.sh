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
    # export TYPES_VAR=$3
    local PK_VAR=${*: -1}
    i=0
    while [ $i -lt $1 ]
    do
    # id (int) : name (string)
        read -p "enter column name:" COLUMNS_NAMES[$i]
        
        j=0
        for name in ${COLUMNS_NAMES[@]}
        do  
            if [[ $j -ne $i && ${COLUMNS_NAMES[$((i))]} = ${COLUMNS_NAMES[$((j))]} ]]
            then
                echo "<<there is coulmn with same name ( ${COLUMNS_NAMES[$((j))]} )" 
                continue 2
            
            else
                break
            fi
        done

        while true
        do
            read -p "enter data type of column: " types[$i]
            if [[ ${types[$((i))]} = "int" || ${types[$((i))]} = "string" ]]
            then
                break
            else 
                echo "<< wrong data type >>"
            fi
        done
        

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
    if ! [ $PK ]
    then
        PK=-1
    fi    
    eval $COLUMNS_NAMES_var="'${COLUMNS_NAMES[@]}'" 
    # eval $TYPES_var="'${types[@]}'" 
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
            structure=$name' '${types[$((i))]} 
        else
            structure=$structure":"$name' '${types[$((i))]} 
        fi
        i=$(( $i + 1 ))
    done
    fun ${*: -1}
    if [[ ( $? = 0 || $? = 1 )  && $i -gt 0 ]]
    then
        structure=$structure":(pk="${*: -1}")"
    fi
    echo $structure > $1
}
main()
{
    database=$2
    if [[ $database ]]
    then
        if [ -d $1/databases/$database  ]
        then
            read_data tableName columnNumber "$1/databases/$database"
            # typeset columnNames[$columnNumber] 
            # typeset types[$columnNumber] 
            read_coulmns_names $columnNumber columnNames pk
            create_table_file "$1/databases/$database/$tableName" $columnNames $pk
            # echo "you want to create table ( $tableName ) with ( $columnNumber ) and names ( ${columnNames[*]} ) and primary key in ( $pk ) "
        elif ! [ -d $1 ]  
        then
            echo "project must be in $1"
        else
            echo "<<$database not found>>"
        fi
    else
        echo "no database connection "
    fi
}

main $projectPath $(./connectdb.sh 1)

# function myfunc()
# {
#     local  __resultvar=$1
#     local  myresult='some value'
    
#     eval $__resultvar="'$myresult'"
# }
# myfunc result
# echo $result