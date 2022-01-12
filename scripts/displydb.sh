# !usr/bin/bash

projectPath=~/bash

#search_dir= ls $projectPath/databases
export RED='\033[0;41m'
export NC='\033[0m'
export PUR='\033[1;35m' #\033[1;35m

if [ -d $projectPath/databases ]
then
    echo
    for entry in `ls $projectPath/databases`; 
    do
        echo -e ${PUR}$entry${NC}
    done
else
    if [ -d $projectPath ]
    then
        mkdir $projectPath/databases
    else
        echo -e "${RED}<<project must be in $projectPath>>${NC}"
    fi
fi
