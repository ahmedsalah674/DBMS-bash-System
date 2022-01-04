# !/usr/bin/bash
projectPath=~/bash
fun()
{
    expr $1 + 1 2> /dev/null >> /dev/null
}
structureAndnumber()
{
    local parameter2=$2
    numberOFcolumns=$(head -n 1 $1| awk -F: '{print NF}'  )
    echo  "n->>$numberOFcolumns" #-----------------------------------------------------------> echo testing
    # lastFild=`head -1 $1 | cut -d: -f $numberOFcolumns`
    # if [ $lastFild == "(PK=-1)" ]
    # then
    #     PK=-1
    # else
    #     PK=$(echo $lastFild | cut -d= -f 2|cut -d")" -f 1)
    #     echo "pk->>$PK"
    # fi
    structure=$(head -1 $1);IFS=":";
    export columnNamesData
    read -ra columnNamesData <<< "$structure"
    eval $parameter2="'$numberOFcolumns'"
    
}
chekPK()
{
    echo "esdadas"
}
insertValues()
{
    pkIndex=$(echo ${columnNamesData[-1]} | rev | cut -d'=' -f 1 | rev | cut -d')' -f 1)
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
                        read -p "enter value of '$word':" value
                        chekPK $value #-----------------> 
                        if [[ ${speratedStructure[$(($i+1))]} = "int" ]]
                        then
                            fun $value
                            if [[ $? -ne 2 ]]
                            then
                                if [[ $values ]]
                                then
                                    values=$values":"$value
                                else
                                    values=$value
                                fi
                                i=$(($i+2))
                                break
                            else
                                echo "<<wrong value '$word' is integer value>>"
                            fi
                        else
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
    echo $values
}
insert_main()
{
    database=$2
    if [[ $database ]]
    then
        read -p "enter table name :" tableName
        if [[ -f $1/databases/$database/$tableName ]]
        then
            structureAndnumber "$1/databases/$database/$tableName"  columnsNumber
            insertValues "$1/databases/$database/$tableName" $columnsNumber
        else
            echo $1/databases/$database/$tableName    
            echo "<<table not found>>"
        fi
    else
        echo "<<no database connection>>"
    fi
}

insert_main $projectPath $(./connectdb.sh 1)