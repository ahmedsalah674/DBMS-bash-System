# !usr/bin/bash
projectPath=~/bash

export RED='\033[0;41m'
export Green='\033[0;32m'
export BLUE='\033[0;34m' #\033[1;35m
export NC='\033[0m'
export PUR='\033[1;35m' #\033[1;35m
while true
do
	read -p "`echo -e ${BLUE}`<<please enter database name: `echo -e ${NC}`" sql
	if [[ $sql ]]
	then
		database=$sql
		break
	else
		echo -e "${RED}<<This is required >>${NC}\n"
		continue
	fi
done

if [ -d  $projectPath/databases ]
then	
	if ! [ -d  $projectPath/databases/$database ]
	then	
		mkdir $projectPath/databases/$database
		echo -e "\n${Green}<<Database Created successfully>>${NC}\n"
		exit
	else
		echo -e "\n${RED}<<database is already exists>>${NC}\n"
	fi
fi
