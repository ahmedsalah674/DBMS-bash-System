# !/usr/bin/bash
projectPath=~/bash
export RED='\033[0;41m' #'\033[0;31m'
export Green='\033[1;42m'
export NC='\033[0m' # No Color
export BLUE='\033[0;34m'
export PUR='\033[1;35m'
fun()
{
    expr $1 + 1 2> /dev/null >> /dev/null
}
structureAndnumber()
{
    local parameter2=$2
    numberOFcolumns=$(head -n 1 $1| awk -F: '{print NF}'  )
    structure=$(head -1 $1);IFS=":";
    export columnNamesData
    read -ra columnNamesData <<< "$structure"
    eval $parameter2="'$numberOFcolumns'"
    
}
pkExistence()#for check if the counter of coulmns be after the primary key or not  
{
    if [[ $1 -gt $2 ]]
    then
        echo 1
    elif [[ $1 -eq $2 && $3 ]]
    then    
        echo 1
    else
        echo 0
    fi
}
getValues()
{   
    # set -x
    pkIndex=$(echo ${columnNamesData[-1]} | rev | cut -d'=' -f 1 | rev | cut -d')' -f 1) #export array have coulmns and data type "id int"
    for coulmn in ${columnNamesData[@]}
    do
        IFS=" "
        read -ra speratedStructure <<< "$coulmn"
        local i=0
        for word in ${speratedStructure[@]}
        do
            if ! [[ $word =~ (['(']) ]]
            then
                if [[ $i = 0 || $(expr $i % 2 ) != 0 ]]
                then
                    while true
                    do    
                        read -p "`echo -e ${BLUE}`enter value of '$word': `echo -e ${NC}`" value 
                        if [[ ${speratedStructure[$(($i+1))]} = "int" ]]
                        then
                            fun $value
                            if [[ $? -ne 2 ]]
                            then
                                if [[ $(pkExistence $(($pkIndex *2 )) $i $value) = 1 ]] #chek if pk is set with value or not 
                                then
                                    if [[ $values ]]
                                    then
                                        if [[ -z $value ]]
                                        then
                                            value="\'\'"
                                        fi
                                        values=$values":"$value
                                    else
                                        if [[ -z $value ]]
                                            then
                                                value="\'\'"
                                            fi
                                        values=$value
                                    fi
                                else
                                    echo -e "${RED}<<'${columnNamesData[$i]}' is primary key must have value>>${NC}"  
                                    continue
                                fi
                                i=$(($i+2))
                                break
                            else
                                echo -e "${RED}<<wrong value '$word' is integer value>>${NC}"
                            fi
                        else
                            if [[ -z $value ]]
                                then
                                    value="''"
                                fi
                            values=$values":"$value
                            i=$(($i+2))
                            break
                        fi
                    done
                else
                    i=1
                fi
            fi
        done
    done  
    eval $3="'$values'"
    eval $4="'$pkIndex'" 
}
checkRpeatedValuePK()
{
   #filePath columnsNumber vaulesStructured $pk   ${columnNamesData[@]}
    # $1         $2              $3         $4          export arr
    size=`wc -l $1 | awk '{ print $1 }'`
    PKvalue=`echo $3 | cut -d: -f $(($4 +1 )) `
    if [[ $(tail -$(( $size-1 )) $1|cut -d: -f $(($4 +1))| grep -nw $PKvalue | cut -d: -f1 ) ]]
    then
        echo -e "${RED}<<primary key must be uniqe value>>${NC}"
    else
        echo $3 >> $1
        echo -e "${Green}<<insert successfully>>${NC}"
    fi
    
}
insert_main()
{
    database=$2
    if [[ $database ]]
    then
        read -p "`echo -e $BLUE`enter table name : `echo -e $NC`" tableName
        if [[ -f $1/databases/$database/$tableName ]]
        then
            structureAndnumber "$1/databases/$database/$tableName"  columnsNumber # will use ${columnNamesData[@]} for structure of table
            getValues "$1/databases/$database/$tableName" $columnsNumber valuesStructured Pk
            if [[ $PK -ne -1 ]]
            then
                checkRpeatedValuePK "$1/databases/$database/$tableName" $columnsNumber $valuesStructured $Pk
            fi
        else
            echo $1/databases/$database/$tableName    
            echo -e "${RED}<<table not found>>${NC}"
        fi
    else
        echo -e "${RED}<<no database connection>>${NC}"
    fi
}

insert_main $projectPath $(./connectdb.sh 1)
