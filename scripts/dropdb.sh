# !usr/bin/bash

projectPath=~/bash
echo -e '\nplease enter database name'
read dorpDBName 
if [ -d $projectPath/databases/$dorpDBName  ]
then	
	while [ true ]
	do 
		read -p 'are you sure? Enter [y/n] : ' answer
		#read -r answer 
		if [ $answer = "y" ]
		then
		    rm -rf $projectPath/databases/$dorpDBName
		    break
		elif [ $answer = "n" ]
		then
		    break
		else 
		    continue
		fi
	done
else
	echo 'database not found'
fi
