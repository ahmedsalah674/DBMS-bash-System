# !usr/bin/bash
projectPath=~/bash
check_Word()
{
    if [[ $1 = "CREATE" ]]  #create table ahmed
                            #create database ahmed
    then 
        BEIGN="0"
    elif [[ $1 = "SELECT" ]]
    then
        BEIGN="1"
    elif [[ $1 = "DROP" ]] #drop database ahmed
                            #drop table ahmed
    then 
        BEIGN="2"
    elif [[ $1 = "USE" ]]    #use iti
    then
        BEIGN="3"
    elif [[ $1 = "ALTER" ]] 
    then
        BEIGN="4"
    elif [[ $1 = "DELETE" ]]    
    then
        BEIGN="5"
    elif [[ $1 = "TABLE" ]]    
    then 
        BEIGN="6"
    elif [[ $1 = "DATABASE" ]]
    then
        BEIGN="7"
    elif [[ $1 = "INSERT" ]]
    then
        BEIGN="8"
    elif [[ $1 = "INTO" ]]
    then
        BEIGN="9"
    else 
        BEIGN="-1"
    fi
}
echo 'enter sql stetment'
read sql
for word in ${sql[@]}
    check_Word ${word^^}
    RESULT=$RESULT$BEIGN
done
echo $RESULT