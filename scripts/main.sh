# !usr/bin/bash

PS3="DBMS->";
projectPath=~/bash

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


while [ true ]
do
	select choice in "create database" "disply databases" "connect to database" "drop database" "exit"
	do
	case $choice in 
	"create database")
		if [ -f createdb.sh ]
		then
			./createdb.sh
			break
		else
			echo "<< you deleted some important files download project again >>"
		fi
		;;
	"disply databases")
		if [ -f displydb.sh ]
		then
			./displydb.sh
			break
		else
			echo "<< you deleted some important files download project again >>"
		fi
		;;
	"connect to database")
		if [ -f connectdb.sh ]
		then
			./connectdb.sh
			break
		else
			echo "<< you deleted some important files download project again >>"
		fi
			;;
	"drop database")
		if [ -f dropdb.sh ]
		then
			./dropdb.sh
			break
		else
			echo "<< you deleted some important files download project again >>"
		fi
		;;
	"exit")
		echo "Exiting ..."
		exit ;;
	*)
		echo "Wrong Entery"
		;;
	esac
	done
done
