# !/usr/bin/bash
export RED='\033[0;41m' #'\033[0;31m'
export Green='\033[1;42m' 
export BLUE='\033[1;34m'
export NC='\033[0m' # No Color

projectPath=~/bash

fun()
{
    expr $1 + 1 2> /dev/null >> /dev/null
}

read_col()
{
    read -p "enter table name:" tableName
    if [[ -f $1/$tableName ]]
    then
        tName=$1/$tableName
        size=`wc -l $tName | awk '{ print $1 }'`

        read -p "enter the column name or *(select all): " column # enter column to select from or n -> select *
        read -p "enter the column name of condition: " columncond # enter column to check condition ex id=4
        if [[ $columncond ]]
        then
            read -p "enter the condition " cond    
        fi
    else
        echo -e "${RED}<<Table not found>>${NC}"
        exit;
    fi

    eval $2="'$tName'"
    eval $3="'$size'"
    eval $4="'$column'"
    eval $5="'$columncond'"
    eval $6="'$cond'"
}

selectAll()
{
    indexAndDataType $1 $3 selectorIndex selectorDataType
    if [[ $3 = '*' ]]
    then
        if [[ -z $4 ]]                  
        then
            echo
            sed -e 's/:/ /g' $1 | sed -n "2,$2p"
            #-e "s/:/ /"
            echo
        else
            indexAndDataType $1 $4 colIndex columnDataType
            if [[ $colIndex ]]
            then
                # numbers of lines that have the value in the column that selected   1 2 3 
                for lineNum in `cut -d: -f$(($colIndex+1)) $1| grep -nw $5|cut -d: -f1`
                do 
                    awk '{if( NR == "'$lineNum'" ) print $0}' $1
                done
            else
                echo -e "${RED}<<\nthere is no column $4 in the table to compare\n>>${NC}"
            fi
        fi
    else
        if [[ -z $selectorIndex ]]
        then
            echo -e "${RED}<< \nthere is no column $3 in the table to select \n>>${NC}"
        else # there is a value to select 
            if [[ -z $4 ]]
            then
                s=$(wc -l $1 | cut -d" " -f1)
                echo
                echo -e "${BLUE}$3${NC}"
                tail -$(($s-1)) $1 |cut -d: -f$(($selectorIndex+1))
                echo
            else
                indexAndDataType $1 $4 colIndex columnDataType
                if [[ $colIndex ]]
                then
                    # if [[ columnDataType == 'int' ]]
                    # then    
                    #     fun $5
                    #     if [[ $? -lt 2 ]]
                    #     then
                            #numbers of lines that have the value in the column that selected   1 2 3 
                            for lineNum in `cut -d: -f$(($colIndex+1)) $1| grep -nw $5|cut -d: -f1`
                            do 
                                awk -F: '{if( NR == "'$lineNum'" ) print $"'$(($selectorIndex+1))'"}' $1
                            done
                    #     else
                    #         echo "condition value is not integer"
                    #     fi
                    # fi
                else
                    echo -e "\nthere is no column $4 in the table to compare\n"
                fi
            fi
        fi
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
    read_col "$projectPath/databases/$database" tname size column columncond cond 
    selectAll $tname $size $column $columncond $cond
                #s      4     name     id       2
else
    echo -e "${RED}<<No Database connection>>${NC}"
fi