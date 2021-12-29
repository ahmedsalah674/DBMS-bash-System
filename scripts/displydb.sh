# !usr/bin/bash

projectPath=~/bash

#search_dir= ls $projectPath/databases

if [ -d $projectPath/databases ]
then
    for entry in `ls $projectPath/databases`; 
    do
        echo $entry
    done
else
    if [ -d $projectPath ]
    then
        mkdir $projectPath/databases
    else
        echo "project must be in $projectPath"
    fi
fi
