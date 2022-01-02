# !usr/bin/bash
projectPath=~/bash

check_Word()
{
    pat='([0-9a-zA-Z])'
    if [[ ${*^^} =~ "CREATE DATABASE "(([0-9a-zA-Z])) ]]   #create database ahmed
    then 
        ./createdb.sh $3
    elif [[ ${*^^} =~ "CREATE TABLE "(([0-9a-zA-Z])) ]]
    then
        echo 'here bro'
    elif [[ ${*^^} =~ "DROP DATABASE "(([0-9a-zA-Z])) ]] #drop database ahmed
    then 
        ./dropdb.sh $3
    elif [[ ${*^^} =~ "USE "(([0-9a-zA-Z])) ]]    #use iti
    then
        ./conccectdb.sh $2
    elif [[ $1 = "ALTER" ]] 
    then
        BEIGN="4"
    elif [[ ${*^^} =~ "DELETE FROM "(([0-9a-zA-Z])) ]]     
    then
        BEIGN="5"
    elif [[ $1 = "SHOW TABLES" ]]    
    then 
        ./listTables.sh
    elif [[ $1 = "DATABASE" ]]
    then
        BEIGN="7"
    elif [[ $* = "" ]]
    then
        BEIGN="8"
#     elif [[ ${*^^} =~(INSERT INTO ) ([0-9a-zA-Z]) (where) ]]; 
        elif [[ ${*^^} =~ (INSERT INTO )(([0-9a-zA-Z]+))( WHERE)(([0-9a-zA-Z]+)) ]]; 
    then
        BEIGN="9"
    else 
        BEIGN="-1"
    fi
}

 
# str="first url1, second url2, third url3"

# if [[ $str =~ (second )([^,]*) ]]; then
#   echo "match: '${BASH_REMATCH[2]}'"
# else
#   echo "no match found"
# fi


echo 'enter sql stetment'
read sql
# # for word in ${sql[@]}
# # do
    check_Word $sql
    RESULT=$RESULT' '$BEIGN
# done

echo $RESULT