# !usr/bin/bash

projectPath=~/bash
read_DatabaseName()
{   
    while true
    do
	read -p "`echo -e ${BLUE}`<<please enter database name: `echo -e ${NC}`" sql
	# read sql;
	if [[ $sql ]]
	then
		database=$sql
		break
	else
		echo -e "${RED}<<This is requierd >>${NC}\n"
		continue
	fi
    done
    eval $2="'$sql'"
}

read_DatabaseName $projectPath dorpDBName

if [ -d $projectPath/databases/$dorpDBName  ]
then	
	while [ true ]
	do 
		read -p "`echo -e ${BLUE}`are you sure? Enter [Y/N-y/n]: `echo -e ${NC}`" answer
		#read -r answer 
		if [[ $answer == "y" || $answer == "Y" ]]
		then
		    rm -rf $projectPath/databases/$dorpDBName
			echo -e "\n${Green}<<Database Deleted Successfully>>${NC}\n"
		    break
		elif [[ $answer == "n" || $answer == "N" ]]
		then
		    break
		else 
		    continue
		fi
	done
else
	echo -e "${RED}<<database not found>>${NC}"
fi
