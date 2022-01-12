#!/usr/bin/bash
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
indexAndDataType() # for calling -> indexAndDataType $tableName $columnName columnIndex columnDataType
{
    local columnIndexs
    local columnDataTypes
    if [[ $2 ]]
    then
        columnIndexs=$( awk -F: '{for ( i=1 ; i<NF; i++) print $i; exit }' $1 |awk -F" " '{for ( i=0 ; i<NF; i++) if( $i == "'$2'" ) print NR-1  }')
        columnDataTypes=$( awk -F: '{for ( i=1 ; i<NF; i++) print $i; exit }' $1 |awk -F" " '{for ( i=0 ; i<NF; i++) if( $i == "'$2'" ) print $2  }')
    fi
    # will split first line in file to ("id int " ,"name string", ) then will pip to get the index of the "id" and the second call to get the data type  
    eval $3="'$columnIndexs'"
    eval $4="'$columnDataTypes'"
}
isPrimary() #calling-> isPrimary $tableName $columnName
{   
    if [[ $2 ]]
    then
        indexAndDataType $1 $2 pkcheckIndex pkcheckDataType
        pk=$(head -1 $1| awk -F: '{for(i=1;i<=NF;i++) if(i==NF) print $NF }'| cut -d= -f2|cut -d")" -f1)
        if [[ $pk -eq $pkcheckIndex ]]
        then 
            echo  1
        else
            echo 0
        fi
    else
        echo 0
    fi
}
checkRpeatedValuePK() # for calling--> checkRpeatedValuePK $tablePath $updateColumn $updateValue 
{
    pk=$(head -1 $1| awk -F: '{for(i=1;i<=NF;i++) if(i==NF) print $NF }'| cut -d= -f2|cut -d")" -f1)
    indexAndDataType $1 $2 checkPKIndex checkPKDataType
    if [[ ($pk != -1) && ($checkPKIndex == $pk) ]]
    then
        size=`wc -l $1 | awk '{ print $1 }'`
        if [[ $(tail -$(( $size-1 )) $1|cut -d: -f $(($pk +1))| grep -nw $3 | cut -d: -f1 ) ]]
        then
            echo 0
        else
            echo 1
        fi
    else
        echo 1
    fi   
}
read_updateColumn()
{
    while true
    do 
        read -p "enter the column name for update: " fun_updateColumn 
        if [[ $fun_updateColumn ]]
        then
            indexAndDataType $1 $fun_updateColumn fun_updateColumnIndex fun_updateColumnDataType
        else
            echo -e "${RED}<<this is required value can't be null >>${NC}"
            continue
        fi

        if [[ $fun_updateColumnIndex ]]
        then
            break 
        else
            echo -e "${RED}<<this column not found >>${NC}"
            continue
        fi
    done
    eval $2="'$fun_updateColumn'"
    eval $3="'$fun_updateColumnDataType'"
}
read_updateValue()  #calling -> $tableName arg_updateValue $arg_updateColumnDataType $arg_updateColumn
{
    while true
    do
        read -p "enter the $updateColumn_arg new value : " fun_updateValue     
        if [[ $fun_updateValue ]]
        then
            if [[ $3 == "int" ]]
            then
                fun $fun_updateValue
                if [[ $? -gt 1 ]]
                then
                    echo -e "${RED}<<this value must be integer >>${NC}"
                    continue
                fi
                if [[ $(checkRpeatedValuePK $1 $4 $fun_updateValue) -eq 0 ]]
                then
                    echo -e "${RED}<< primary key must be uniqe value >>${NC}"
                    continue
                else
                    break
                fi
            else
                break
            fi
        else
            if [[ $3 == "string" ]]
            then
                break
            else
                echo -e "${RED}<<this is required value can't be null >>${NC}"
                continue
            fi
        fi
    done
    eval $2="'$fun_updateValue'"
}
read_conditionColumn()
{
    while true
    do
        read -p "enter the column name of condition: " fun_conditionColumn     
        if [[ $fun_conditionColumn ]]
        then
            indexAndDataType $1 $fun_conditionColumn conditionColumnIndex conditionColumnDataType
            if [[ $conditionColumnIndex ]]
            then
                read -p "enter value of condition: " fun_conditionValue    
                break 
            else
                echo -e "${RED}<<this column not found >>${NC}"
                continue
            fi
        else
            if [[ $(isPrimary $1 $fun_conditionColumn) -eq 1 ]]
            then
                echo -e "${RED}<<this column is primary key can't update all in same value >>${NC}" 
                continue
            else
                break
            fi
        fi
    done  
    eval $3="'$fun_conditionColumn'"
    eval $4="'$fun_conditionValue'"
}
updateValues_fun() #calling-> updateValues_fun $tableName $arg_updateColumn $arg_updateValue $arg_conditionColumn $arg_conditionValue
{   

    conditionValue=$5
    if [[ $2 ]]
    then
        indexAndDataType $1 $2 updateIndex updateDataType
    fi
    if [[ $4 ]]
    then
        indexAndDataType $1 $4 conditionIndex conditionDataType
    fi
    # cut the condition then get the number of lines then append it
    pk=$(head -1 $1| awk -F: '{for(i=1;i<=NF;i++) if(i==NF) print $NF }'| cut -d= -f2|cut -d")" -f1)
    size=`wc -l $1 | awk '{ print $1 }'`
    if [[ -z $conditionIndex ]]
    then
        existans=0
    elif [[ $conditionIndex && -z $5 ]]
    then
        existans=1
    else
        existans=2
    fi
    if [[ $pk == $updateIndex  ]]
    then
        if [[ $existans -ne 0 ]] 
        then
            if [[ $existans -eq 1 ]]
            then
                conditionValue="\'\'"
                changesNumber=$(tail -$(( $size-1 )) $1 |cut -d: -f$(($conditionIndex+1))| grep -nw $conditionValue|cut -d: -f1| wc -l |cut -d" " -f1)
                if [[ $changesNumber -gt 1 ]]
                then
                    echo -e "${RED}<<this columns is primary key can't have same value multi times>>${NC}"
                    exit
                else
                    editIT=1
                fi
            else
                editIT=1
            fi
        else
            echo -e "${RED}<<this columns is primary key can't have same value multi times>>${NC}"
            exit
        fi
    else
        if [[ -z $5 ]]
        then
            conditionValue="\'\'"
        fi
        editIT=1
    fi

    if [[ $editIT == 1 ]]
    then
        if [[ $conditionIndex ]]
        then
            # echo "if"
            for lineNum in `tail -$(( $size-1 )) $1 |cut -d: -f$(($conditionIndex+1))| grep -nw $conditionValue|cut -d: -f1`
            do 
                targetLine=$(head -$(($lineNum+1)) $1|tail -1) 
                fieldsNum=$(head -1 $1 |awk -F: '{print NF-1}')
                i=1
                while [ $i -le $fieldsNum ]
                do
                    if [[ $i -ne 1 ]]
                    then
                        if [[ $i -eq $(($updateIndex+1)) ]]
                        then
                            s=$s":"$3
                        else
                        s=$s":"$(echo $targetLine | cut -d: -f$i)
                        fi
                    else
                        if [[ $i -eq $(($updateIndex+1)) ]]
                        then
                            s=$3
                        else
                        s=$(echo $targetLine | cut -d: -f$i)
                        fi
                    fi
                    i=$(($i+1))
                done
                sed -i "$(($lineNum+1)) a $s" $1
                sed -i "$(($lineNum+1)) d" $1
                editloop=1
            done 
        else
            # echo "else"
            lineNum=1
            while  [[ $lineNum -le $size ]]
            do 
                targetLine=$(head -$(($lineNum+1)) $1|tail -1) 
                fieldsNum=$(head -1 $1 |awk -F: '{print NF-1}')
                i=1
                while [ $i -le $fieldsNum ]
                do
                    if [[ $i -ne 1 ]]
                    then
                        if [[ $i -eq $(($updateIndex+1)) ]]
                        then
                            s=$s":"$3
                        else
                        s=$s":"$(echo $targetLine | cut -d: -f$i)
                        fi
                    else
                        if [[ $i -eq $(($updateIndex+1)) ]]
                        then
                            s=$3
                        else
                        s=$(echo $targetLine | cut -d: -f$i)
                        fi
                    fi
                    i=$(($i+1))
                done
                sed -i "$(($lineNum+1)) a $s" $1
                sed -i "$(($lineNum+1)) d" $1
                editloop=1
                echo "$conditionIndex"
                lineNum=$(($lineNum+1))
            done 
        fi
        if [[ $editloop == 1 ]]
        then
            echo -e "${Green}<<updated successfully>>${NC}"
        fi
    fi
}
update_main()
{
    database=$2
    if [[ $database ]]
    then
        read -p "enter table name :" tableName
        tableName="$1/databases/$database/$tableName"
        if [[ -f $tableName ]]
        then
            read_updateColumn $tableName arg_updateColumn arg_updateColumnDataType
            read_updateValue  $tableName arg_updateValue $arg_updateColumnDataType $arg_updateColumn 
            read_conditionColumn $tableName $arg_updateColumn arg_conditionColumn arg_conditionValue
            if [[ $arg_updateValue ]]
            then
                updateValues_fun $tableName $arg_updateColumn $arg_updateValue $arg_conditionColumn $arg_conditionValue
            else
                arg_updateValue="''"
                updateValues_fun $tableName $arg_updateColumn $arg_updateValue $arg_conditionColumn $arg_conditionValue
            fi

        else
            echo -e "${RED}<<table not found>>${NC}"
        fi
    else
        echo -e "${RED}<<no database connection>>${NC}"
    fi
}
update_main $projectPath $(./connectdb.sh 1)