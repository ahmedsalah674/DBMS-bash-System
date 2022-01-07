# !usr/bin/bash
projectPath=~/bash

export RED='\033[0;31m'
export Green='\033[0;32m'
export BLUE='\033[0;34m' #\033[1;35m
export PUR='\033[1;35m' #\033[1;35m
export NC='\033[0m'

database=$(./connectdb.sh 1)

if [ -d $projectPath/databases/$database ]
then
    ls $projectPath/databases/$database > tables.txt

    # file is not empty
    if [ -s tables.txt ]
    then
        echo -e $PUR 
        cat tables.txt
        rm tables.txt
        echo -e $NC
    else
        echo -e "${PUR}<<database is empty>>$NC"
    fi
else
    echo -e "${RED}<<database $database is not found$NC"
fi