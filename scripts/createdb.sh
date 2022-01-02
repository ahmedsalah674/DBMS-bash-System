# !usr/bin/bash
projectPath=~/bash

# -e -> to read \n as new line
echo -e ' \nplease enter database name'
read sql;
# database=$1
#create database ahmed
if [ -d  $projectPath/databases ]
then	
	if ! [ -d  $projectPath/databases/$database ]
	then	
		mkdir $projectPath/databases/$database
		echo "Database Created successfully"
		exit
	else
		echo "database is already exists"
	fi
fi
