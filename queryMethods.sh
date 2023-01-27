function selectQuery(){
    echo "select"
}
function insertQuery(){
    #splite Query
    IFS=' ' read -ra queryArr <<< "$@";
    #Columns Before Into
    #check INTO KeyWord
    if ! [ "${queryArr[1]}" = "into" ]
    then
        printf "${Red}Syntax Erorr near to ${queryArr[1]}${Color_Off}\n";
        return 0;
    fi
    #Check if table exist 
    if ! [ `find -name "${queryArr[2]}"` ]
    then
        printf "${Red} No table Name ${queryArr[2]}:${Color_Off}\n";
        return 0;
    fi
    #Check VALUE KeyWord 
    if ! [ "${queryArr[3]}" = "values" ]
    then
        printf "${Red}Syntax Erorr near to ${queryArr[3]}${Color_Off}\n";
        return 0;
    fi
    #Read File and MeataFile 
     #Check If Empty Values 
    if [ "${queryArr[4]}" = '' ]
    then
        printf "${Red}Syntax Erorr, VALUES NOT FOUND${Color_Off}\n";
        return 0;
    fi
    IFS=',' read -ra valuesArr <<< "${queryArr[4]}";
    tableName="./${queryArr[2]}";
    metaName="./.meta${queryArr[2]}"; 
    #Read meta File
    metaFileDataType=`sed -n '2p' $metaName`
    metaFileDataConstraint=`sed -n '3p' $metaName`
    IFS=':' read -ra metaDataTpeArr <<< "$metaFileDataType";
    IFS=':' read -ra metaConstraintArr <<< "$metaFileDataConstraint";
    rowValues=""
    local i=0;
    for coltype in "${metaDataTpeArr[@]}";
    do   
        #check Value Type 
        if [ "${valuesArr[$i]}" = '' ]
        then
            valuesArr[$i]="NULL"
        fi
        erorr=0
        dataTypeChecker $coltype ${valuesArr[$i]} erorr
        if [ $erorr -eq 1 ]
        then
            printf "${Red}Unexpected DataType Expected ${coltype} for '${valuesArr[$i]}' Value${Color_Off}\n";
            return 0;
        fi
        #check Constraint
        erorr=0
        case ${metaConstraintArr[i]} in 
        "1")
            #Praymary Key
             #Check Null
            if [ "$erorr" = "NULL" ]
            then
                printf "${Red}Praymary Key Cant Be NULL${Color_Off}\n";
                return 0;
            fi
            colNum=1
            colNum=$(($colNum + $i))
            constraintChecker $colNum $tableName ${valuesArr[$i]} erorr 
            if [ $erorr -eq 1 ]
            then
                printf "${Red}Praymary Key Must Be Unique${Color_Off}\n";
                return 0;
            fi
        ;;
        "0")
            #NotPraymary
        ;;
        esac
        #Append To Row Value
        rowValues="$rowValues:${valuesArr[$i]}";
        i=($i+1)
    done
    rowValues=${rowValues#?}
    echo $rowValues >> $tableName
    printf  " Insertaion ${Green}success${Color_Off}\n"
}
function delectQuery(){
    echo "delete"
}
function updateQuery(){
    echo "update"
}
#------------- Initial Methods ----------------
function dataTypeChecker(){
    case $1 in 
    "integer")
        if ! [[ $2 =~ $NUMBERREGEXP ]]
        then
            (($3=1));
        fi
    ;;
    "string")
        #String will Accept All
    ;;
    esac
}
function constraintChecker(){
    found=`cut -d":" -f$1 $2 | grep -w "$3" | wc -l`
    if [ $found -eq 1 ]
    then
        (($4=1));
    fi
}
