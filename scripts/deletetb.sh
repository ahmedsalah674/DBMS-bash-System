# !/usr/bin/bash
export RED='\033[0;41m' #'\033[0;31m'
export Green='\033[1;42m'
export NC='\033[0m' # No Color
export BLUE='\033[0;34m'

projectPath=~/bash

#database=$2
database=ahmed

read_col()
{
    read -p "`echo -e $BLUE`enter table name: `echo -e $NC`" tableName
    if [[ -f $1/$tableName ]]
    then
        tName=$1/$tableName 
        read -p "`echo -e $BLUE`enter the column name of condition: `echo -e $NC`" columncond
        if [[ $columncond ]]
        then
            read -p "`echo -e $BLUE`enter the value you want to delete based on $columncond: `echo -e $NC`" valuecond
        fi
        size=`wc -l $tName | awk '{ print $1 }'`
    else
        
        echo -e "${RED}<<Table not found>>${NC}"
    fi
    eval $2="'$tName'"
    eval $3="'$size'"
    eval $4="'$columncond'"
    eval $5="'$valuecond'"
}

delete_col()
{
    if [[ $3 ]]
    then
        indexAndDataType $1 $3 columnIndex columnDataType
        if [[ $columnIndex ]]
        then
            #base 
            i=0
            for number in `tail -$(( $2-1 )) $1|cut -d: -f $(($columnIndex+1)) | grep -nw $4  | cut -d: -f 1` #| grep -nw ahmed | cut -d: -f 1`
            do
                #echo the id = $(($number-$i+1))
                sed -i "$(($number-$i+1)) d" $1
                i=$(($i+1))
            done
            echo -e "${Green}<<you have deleted $4 successfuly>>${NC}"
        else
            echo -e "${RED}<<the column does not exist>>${NC}"
        fi 
    else
        sed -i "2,$2 d" $1
    fi
}

indexAndDataType() # for calling -> indexAndDataType $tableName $columnName columnIndex columnDataType
{
    columnIndexs=$( awk -F: '{for ( i=1 ; i<NF; i++) print $i; exit }' $1 |awk -F" " '{for ( i=0 ; i<NF; i++) if( $i == "'$2'" ) print NR-1  }')
    columnDataTypes=$( awk -F: '{for ( i=1 ; i<NF; i++) print $i; exit }' $1 |awk -F" " '{for ( i=0 ; i<NF; i++) if( $i == "'$2'" ) print $2  }')
    # will split first line in file to ("id int " ,"name string", ) then will pip to get the index of the "id" and the second call to get the data type 
    eval $3="'$columnIndexs'"
    eval $4="'$columnDataTypes'"
} 

database=$(./connectdb.sh 1)

if [[ $database ]]
then
    read_col "$projectPath/databases/$database" tname size columncond condvalue
    delete_col $tname $size $columncond $condvalue
else
    echo -e "${RED}<<Database not found>>${NC}"
fi