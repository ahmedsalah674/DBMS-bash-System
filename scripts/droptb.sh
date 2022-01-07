# !usr/bin/bash

export RED='\033[0;31m'
export Green='\033[0;32m'
export BLUE='\033[0;34m' #\033[1;35m
export PUR='\033[1;35m' #\033[1;35m
export NC='\033[0m'

projectPath=~/bash
database=$(./connectdb.sh 1)

echo -e "${BLUE}enter the table name: $NC"
read table


if [[ $database ]]
then
    if [ -f $projectPath/databases/$database/$table ]
    then 
        while [ true ]
        do
            read -p "`echo -e $RED`are you sure? [Y/N-y/n] : `echo -e $NC`" answer

            if [ $answer = "y" | $answer = "Y" ]
            then
                rm $projectPath/databases/$database/$table
                echo "$Green<<table $table is deleted>>$NC"
                break
            elif [[ $answer = "n" | $answer = "N" ]]
            then
                break
            else
                echo -e "$RED<<invalid choice, try again>>$NC"
                continue
            fi
        done
    else
        echo -e "${RED}<<table $table is not found>>$NC"
    fi
else
    echo -e "${RED}<<you did not connect to a database>>${NC}"
fi
