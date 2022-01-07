# !/usr/bin/bash
projectPath=~/bash
export RED='\033[0;311m'
export Green='\033[0;32m'
export BLUE='\033[0;34m' #\033[1;35m
export PUR='\033[1;35m' #\033[1;35m
export NC='\033[0m'
export Yellow='\033[0;33m'  
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
create_connection()
{
    database=$2
    if [ -d $1/databases/$database  ]
    then
        if [ -f $1/confg/connection ]
        then
            for connectDatabase in `cat $1/confg/connection  `
            do 
                if [ $connectDatabase = $database ]
                then
                    echo "<<database is already connected>>"
                    exit    
                fi
            done
            echo $database > $1/confg/connection
            echo -e "${Green}<<connected sccussfully>>$NC"
        else
            touch $1/confg/connection
            echo $database >> $1/confg/connection
            echo -e "${Green}<<connected sccussfully>>$NC"
        fi
    else
        echo -e "${RED}<<$database not found>>$NC"
        exit
    fi
}
connected_database()
{
    if [[ -f $1/confg/connection ]]
    then
        echo `head -1 $1/confg/connection`
    else
        touch $1/confg/connection
        echo `head -1 $1/confg/connection`
    fi
}

selectOptions()
{
    PS3=$(echo -e "$Yellow$(connected_database  $1)->$NC")
    while [ true ]
do
	echo -e $BLUE
	select choice in "Create Table" "List Tables" "Drop Table" "Insert into Table" "Select From Table" "Delete From Table" "Update Table" "Back`echo -e $NC`"  
	do
	case $choice in 
	"Create Table")
		if [ -f createTable.sh ]
		then
			./createTable.sh
			break
		else
			echo "${RED}<<you deleted some important files download project again>>$NC"
		fi
		;;
	"List Tables")
		if [ -f showtables.sh ]
		then
			./showtables.sh
			break
		else
			echo "${RED}<<you deleted some important files download project again>>$NC"
		fi
		;;
	"Drop Table")
		if [ -f droptb.sh ]
		then
			./droptb.sh
			break
		else
			echo "${RED}<<you deleted some important files download project again>>$NC"
		fi
			;;
	"Insert into Table")
		if [ -f insert.sh ]
		then
			./insert.sh
			break
		else
			echo "${RED}<<you deleted some important files download project again>>$NC"
		fi
		;;
    "Select From Table")
        if [ -f selectTable.sh ]
            then
                ./selectTable.sh
                break
            else
                echo "${RED}<<you deleted some important files download project again>>$NC"
            fi
            ;;
    "Delete From Table")
    if [ -f deletetb.sh ]
            then
                ./deletetb.sh
                break
            else
                echo "${RED}<<you deleted some important files download project again>>$NC"
            fi
            ;;
    "Update Table")
        if [ -f update.sh ]
                then
                    ./update.sh
                    break
                else
                    echo "${RED}<<you deleted some important files download project again>>$NC"
                fi
                ;;
	"Back`echo -e $NC`")
    if [[ -f $1/confg/connection ]]
    then
        rm $1/confg/connection
    fi
		exit ;;
	*)
		echo -e "${RED}<<Wrong Entery>>$NC"
		;;
	esac
	done
done

}
if [[ $1 = 1 ]]
then
    connected_database  $projectPath
elif [[ $1 = 0 ]]
then
    read_DatabaseName $projectPath databaseName
    create_connection $projectPath $databaseName
    selectOptions $projectPath
    
else
    echo -e "${RED}<<Wrong call>>$NC"
fi
