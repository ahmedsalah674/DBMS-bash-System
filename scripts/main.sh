# !usr/bin/bash

PS3="DBMS->";
projectPath=~/bash
export RED='\033[0;41m' #'\033[0;31m'
export Green='\033[1;42m'
export NC='\033[0m' # No Color
export orange='\033[0;33m'
export PUR='\033[1;35m'

if ! [ -d  $projectPath/databases ]
then
	if [ -d $projectPath ]
	then
		mkdir $projectPath/databases
	else	
		echo "project must be in $projectPath"
		exit
	fi
fi

if ! [ -d  $projectPath/confg ]
then
	if [ -d $projectPath ]
	then
		mkdir $projectPath/confg
	else	
		echo "project must be in $projectPath"
		exit
	fi
else
	if [ -f $projectPath/confg/connection ]
	then
		rm $projectPath/confg/connection 
	fi
fi
hisCuruntlocation=$(pwd)
cd $projectPath/scripts
while [ true ]
do
	echo -e $orange
	select choice in "Create Database" "List Databases"  "Connect To Databases" "Drop Database" "Exit"  
	do
		echo -e $NC
		case $choice in 
		"Create Database")
			if [ -f createdb.sh ]
			then
				./createdb.sh
				break
			else
				echo "${RED}<<you deleted some important files download project again>>$NC"
			fi
			;;
		"List Databases")
			if [ -f displydb.sh ]
			then
				./displydb.sh
				break
			else
				echo "${RED}<<you deleted some important files download project again>>$NC"
			fi
			;;
		"Connect To Databases")
			if [ -f connectdb.sh ]
			then
				./connectdb.sh 0
				break
			else
				echo "${RED}<<you deleted some important files download project again>>$NC"
			fi
				;;
		"Drop Database")
			if [ -f dropdb.sh ]
			then
				./dropdb.sh
				break
			else
				echo "${RED}<<you deleted some important files download project again>>$NC"
			fi
			;;
		"Exit")
			echo -e "${PUR}Exiting ...$NC"
			cd $hisCuruntlocation
			exit ;;
		*)
			echo -e "${RED}<<Wrong Entery>>$NC"
			;;
		esac
	done
done
