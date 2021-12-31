# !usr/bin/bash
projectPath=~/bash
check_firstWord()
{
    if [[ $1 = "CREATE" ]] 
    then 
    BEIGN="0"
    elif [[ $1 = "SELECT" ]]
    then
        BEIGN="1"
    elif [[ $1 = "DROP" ]]
    then 
        BEIGN="2"
    elif [[ $1 = "USE" ]]
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
    else 
        BEIGN="-1"
    fi
}

echo 'enter sql stetment'
read sql
for word in ${sql[@]}
do
    check_firstWord ${word^^}
    if ! [[ $BEIGN = "-1" ]]
    then
        RESULT=$RESULT$BEIGN
    else
        echo "syntacx error"
    fi
done

echo $RESULT