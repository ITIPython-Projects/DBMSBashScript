function selectQuery(){
    IFS=' ' read -ra queryArr <<< "$@";
    #Check From Key Word 
    if ! [ "${queryArr[2]}" = "from" ]
    then
        printf "${Red}Syntax Erorr near to ${queryArr[2]}${Color_Off}\n";
        return 0;
    fi
    #Check if table exist 
    if ! [ `find -name "${queryArr[3]}"` ]
    then
        printf "${Red} No table Name ${queryArr[3]}${Color_Off}\n";
        return 0;
    fi
    #Table Name
    tableName=${queryArr[3]}
    #Readed Variables
    metaFileColumnsName=`sed -n '1p' $metaName`
    metaFileDataType=`sed -n '2p' $metaName`
    metaFileDataConstraint=`sed -n '3p' $metaName`
    IFS=':' read -ra metaColumnsNameArr <<< "$metaFileColumnsName";
    IFS=':' read -ra metaDataTpeArr <<< "$metaFileDataType";
    IFS=':' read -ra metaConstraintArr <<< "$metaFileDataConstraint";
    #Check if table exist 
    case ${queryArr[1]} in 
    "")
        printf "${Red} No Selected Col${Color_Off}\n";
        return 0;
    ;;
    "@")
        local i=0
        for coltype in "${metaColumnsNameArr[@]}";do
            selectedCol[$i]=$i
            i=$(($i+1))
        done
    ;;
    *)
        IFS=',' read -ra selColArr <<< "${queryArr[1]}";
        local selectedCol=0
        local i=0
        for selCol in "${selColArr[@]}";do
             i=0
             NotfoundFlage=1
             for mainCol in "${metaColumnsNameArr[@]}";do
                if [ "$selCol" = "$mainCol" ];then
                    selectedCol[$i]=$i
                    NotfoundFlage=0
                fi
                i=$(($i+1))
             done
             if [ $NotfoundFlage -eq 1 ];then
                printf "${Red} No Column Name $selCol ${Color_Off}\n";
                return 0;
             fi
        done
    ;;
    esac
    #Condetion Statement
    if [ "${queryArr[4]}" = "" ];then
        #No Condition
        local indexnum=""
        for selCol in "${selectedCol[@]}";do
            local ind=1
            ind=$(($selCol + $ind))
            indexnum="$indexnum,$ind"
        done
        indexnum=${indexnum#?}
        echo `cut -d: -f"$indexnum" ./$tableName`
        #Display
        #echo `cut -d: -f"$indexnum" ./$tableName` > ".displayFile"
    else
        if ! [ "${queryArr[4]}" = "where" ];then
            printf "${Red} Expected WHERE KeyWord $selCol ${Color_Off}\n";
            return 0;
        fi
        #Check if Column exist 
        if ! [ `sed -n '1p' $metaName | grep -w "${queryArr[5]}"` ]
        then
            printf "${Red} No Column Name ${queryArr[5]}${Color_Off}\n";
            return 0;
        fi
        #Get condition Column
        local conditionCol=0
        for colName in "${metaColumnsNameArr[@]}";do
            if [ "${queryArr[5]}" = "$colName" ];then
                break;
            fi
            conditionCol=$(($conditionCol+1))
        done
        #Get New condition Value
        if [ "${queryArr[7]}" = '' ]
        then
            printf "${Red}Syntax Erorr, Condition VALUE NOT FOUND${Color_Off}\n";
            return 0;
        fi
        condetionValue=${queryArr[7]}
        local indexnum=""
        for selCol in "${selectedCol[@]}";do
            local ind=1
            ind=$(($selCol + $ind))
            indexnum="$indexnum,$ind"
        done
        indexnum=${indexnum#?}
        case ${queryArr[6]} in 
        "==")
            #echo `cut -d: -f"$indexnum" ./$tableName | awk -F: -v col=$conditionCol -v conval=$condetionValue '$$col == $conval {print $0}'`
            while read p; do
                IFS=':' read -ra rowArr <<< "$p";
                row=""
                if [[ "${rowArr[$conditionCol]}" == "$condetionValue" ]];then
                    for selCol in "${selectedCol[@]}";do
                        row="$row:${rowArr[$selCol]}"
                    done
                fi
                row=${row#?}
                if [[ "$row" != '' ]];then
                 echo $row
                fi
            done < "./$tableName" 
        ;;
        "!=")
            while read p; do
                IFS=':' read -ra rowArr <<< "$p";
                row=""
                if [[ "${rowArr[$conditionCol]}" != "$condetionValue" ]];then
                    for selCol in "${selectedCol[@]}";do
                        row="$row:${rowArr[$selCol]}"
                    done
                fi
                row=${row#?}
                if [[ "$row" != '' ]];then
                 echo $row
                fi
            done < "./$tableName" 
        ;;
        ">")
            #Check If condetionValue Is a number
            isNumber $condetionValue erorr
            if [ $erorr -eq 1 ]
            then
                printf "${Red}Expexted Number in Condition (<)${Color_Off}\n";
                return 0;
            fi
            while read p; do
                IFS=':' read -ra rowArr <<< "$p";
                row=""
                if [[ "${rowArr[$conditionCol]}" -gt "$condetionValue" ]];then
                    for selCol in "${selectedCol[@]}";do
                        row="$row:${rowArr[$selCol]}"
                    done
                fi
                row=${row#?}
                if [[ "$row" != '' ]];then
                 echo $row
                fi
            done < "./$tableName" 
        ;;
        "<")
            #Check If condetionValue Is a number
            isNumber $condetionValue erorr
            if [ $erorr -eq 1 ]
            then
                printf "${Red}Expexted Number in Condition (<)${Color_Off}\n";
                return 0;
            fi
            while read p; do
                IFS=':' read -ra rowArr <<< "$p";
                row=""
                if [[ "${rowArr[$conditionCol]}" -lt "$condetionValue" ]];then
                    for selCol in "${selectedCol[@]}";do
                        row="$row:${rowArr[$selCol]}"
                    done
                fi
                row=${row#?}
                if [[ "$row" != '' ]];then
                 echo $row
                fi
            done < "./$tableName" 
        ;;
        ">=")
            #Check If condetionValue Is a number
            isNumber $condetionValue erorr
            if [ $erorr -eq 1 ]
            then
                printf "${Red}Expexted Number in Condition (<)${Color_Off}\n";
                return 0;
            fi
            while read p; do
                IFS=':' read -ra rowArr <<< "$p";
                row=""
                if [[ "${rowArr[$conditionCol]}" -ge "$condetionValue" ]];then
                    for selCol in "${selectedCol[@]}";do
                        row="$row:${rowArr[$selCol]}"
                    done
                fi
                row=${row#?}
                if [[ "$row" != '' ]];then
                 echo $row
                fi
            done < "./$tableName" 
        ;;
        "<=")
            #Check If condetionValue Is a number
            isNumber $condetionValue erorr
            if [ $erorr -eq 1 ]
            then
                printf "${Red}Expexted Number in Condition (<)${Color_Off}\n";
                return 0;
            fi
            while read p; do
                IFS=':' read -ra rowArr <<< "$p";
                row=""
                if [[ "${rowArr[$conditionCol]}" -le "$condetionValue" ]];then
                    for selCol in "${selectedCol[@]}";do
                        row="$row:${rowArr[$selCol]}"
                    done
                fi
                row=${row#?}
                if [[ "$row" != '' ]];then
                 echo $row
                fi
            done < "./$tableName"
        ;;
        *)
            printf "${Red}Syntax Erorr, Condition Operator NOT Suppurted ${queryArr[6]}${Color_Off}\n";
            return 0;
        ;;
        esac

    fi
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
        printf "${Red} No table Name ${queryArr[2]}${Color_Off}\n";
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
                printf "${Red}Praymary Key Must Be Unique and not null${Color_Off}\n";
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
    #splite Query
    IFS=' ' read -ra queryArr <<< "$@";
    #Check if table exist 
    if ! [ `find -name "${queryArr[1]}"` ]
    then
        printf "${Red} No table Name ${queryArr[1]}${Color_Off}\n";
        return 0;
    fi
    tableName="./${queryArr[1]}";
    metaName="./.meta${queryArr[1]}"
    #Check SET KeyWord 
    if ! [ "${queryArr[2]}" = "set" ]
    then
        printf "${Red}Syntax Erorr near to ${queryArr[2]} Expected SET${Color_Off}\n";
        return 0;
    fi
    #Check if Column exist 
    if ! [ `sed -n '1p' $metaName | grep -w "${queryArr[3]}"` ]
    then
        printf "${Red} No Column Name ${queryArr[3]}${Color_Off}\n";
        return 0;
    fi
    #Check Operation '='
    if ! [ "${queryArr[4]}" = "=" ]
    then
        printf "${Red} Missing '=' Found ${queryArr[4]}${Color_Off}\n";
        return 0;
    fi
    #Check WHERE KeyWord 
    #Get New Value
    if [ "${queryArr[5]}" = '' ]
    then
        printf "${Red}Syntax Erorr, VALUES NOT FOUND${Color_Off}\n";
        return 0;
    fi
    newValue=${queryArr[5]}
    #Readed Variables
    metaFileColumnsName=`sed -n '1p' $metaName`
    metaFileDataType=`sed -n '2p' $metaName`
    metaFileDataConstraint=`sed -n '3p' $metaName`
    IFS=':' read -ra metaColumnsNameArr <<< "$metaFileColumnsName";
    IFS=':' read -ra metaDataTpeArr <<< "$metaFileDataType";
    IFS=':' read -ra metaConstraintArr <<< "$metaFileDataConstraint";
    #Get Position of Target Column
    local targetPosition=0
    for colName in "${metaColumnsNameArr[@]}";do
        if [ "${queryArr[3]}" = "$colName" ];then
            break;
        fi
        targetPosition=$(($targetPosition+1))
    done
    #Condetion Statement
    if [ "${queryArr[6]}" = "" ]
    then
        #No Condition
         # Check If Target Column is Praymary Key
        if [ "${metaConstraintArr[targetPosition]}" = '1' ]
        then
            printf "${Red}Praymary Key Must Be Unique${Color_Off}\n";
            return 0;
        fi
         # Check DataType
        local erorr=0
        dataTypeChecker ${metaDataTpeArr[targetPosition]} $newValue erorr
        if [ $erorr -eq 1 ]
        then
            printf "${Red}DataType Note Mached Expected ${metaDataTpeArr[targetPosition]}${Color_Off}\n";
            return 0;
        fi
        while read p; do
            IFS=':' read -ra rowArr <<< "$p";
            rowArr[$targetPosition]=$newValue
            IFS=':';row="${rowArr[*]// /|}";IFS=$' \t\n'
            echo "$row"
        done < "$tableName" > "$tableName.t"
        `mv $tableName{.t,}`
    else
        if ! [ "${queryArr[6]}" = "where" ]
        then
            printf "${Red}Expected WHERE KeyWord${Color_Off}\n";
            return 0; 
        fi
        #Check if Column exist 
        if ! [ `sed -n '1p' $metaName | grep -w "${queryArr[7]}"` ]
        then
            printf "${Red} No Column Name ${queryArr[7]}${Color_Off}\n";
            return 0;
        fi
        #Get condition Column
        local conditionCol=0
        for colName in "${metaColumnsNameArr[@]}";do
            if [ "${queryArr[7]}" = "$colName" ];then
                break;
            fi
            conditionCol=$(($conditionCol+1))
        done
        #Get New condition Value
        if [ "${queryArr[9]}" = '' ]
        then
            printf "${Red}Syntax Erorr, Condition VALUE NOT FOUND${Color_Off}\n";
            return 0;
        fi
        condetionValue=${queryArr[9]}
        #Get condition Oerand
        local erorr=0
        local numOFchanges=0
        case ${queryArr[8]} in 
        "==")
            # Check DataType
            local erorr=0
            dataTypeChecker ${metaDataTpeArr[targetPosition]} $newValue erorr
            if [ $erorr -eq 1 ]
            then
                printf "${Red}DataType Note Mached Expected ${metaDataTpeArr[targetPosition]}${Color_Off}\n";
                return 0;
            fi
            isprimary=${metaConstraintArr[targetPosition]}
            local erorr=0
            while read p; do
                IFS=':' read -ra rowArr <<< "$p";
                if [[ "${rowArr[$conditionCol]}" = "$condetionValue" ]];then
                    rowArr[$targetPosition]=$newValue
                    numOFchanges=$(($numOFchanges+1))
                fi
                if [ $isprimary -eq 1 ];then
                    local ind=1
                    ind=$(($targetPosition + $ind))
                    constraintChecker $ind ".${queryArr[1]}.tmp" ${rowArr[$targetPosition]} erorr 
                    if [ $erorr -eq 1 ]
                    then
                        break;
                    fi
                fi
                IFS=':';row="${rowArr[*]// /|}";IFS=$' \t\n'
                echo "$row"
            done < "$tableName" > ".${queryArr[1]}.tmp"
            if [ $erorr -eq 1 ]
            then
                    printf "${Red} ${queryArr[3]} is Primary Must be Unique and Not Null${Color_Off}\n";
                    return 0
            fi
            `mv .${queryArr[1]}.tmp $tableName`
        ;;
        "!=")
            # Check DataType
            local erorr=0
            dataTypeChecker ${metaDataTpeArr[targetPosition]} $newValue erorr
            if [ $erorr -eq 1 ]
            then
                printf "${Red}DataType Note Mached Expected ${metaDataTpeArr[targetPosition]}${Color_Off}\n";
                return 0;
            fi
            isprimary=${metaConstraintArr[targetPosition]}
            local erorr=0
            while read p; do
                IFS=':' read -ra rowArr <<< "$p";
                if [[ "${rowArr[$conditionCol]}" != "$condetionValue" ]];then
                    rowArr[$targetPosition]=$newValue
                    numOFchanges=$(($numOFchanges+1))
                fi
                if [ $isprimary -eq 1 ];then
                    local ind=1
                    ind=$(($targetPosition + $ind))
                    constraintChecker $ind ".${queryArr[1]}.tmp" ${rowArr[$targetPosition]} erorr 
                    if [ $erorr -eq 1 ]
                    then
                        break;
                    fi
                fi
                IFS=':';row="${rowArr[*]// /|}";IFS=$' \t\n'
                echo "$row"
            done < "$tableName" > ".${queryArr[1]}.tmp"
            if [ $erorr -eq 1 ]
            then
                    printf "${Red} ${queryArr[3]} is Primary Must be Unique and Not Null${Color_Off}\n";
                    return 0
            fi
            `mv .${queryArr[1]}.tmp $tableName`
        ;;
       ">")
            #Check If condetionValue Is a number
            isNumber $condetionValue erorr
            if [ $erorr -eq 1 ]
            then
                printf "${Red}Expexted Number in Condition (<)${Color_Off}\n";
                return 0;
            fi
            # Check DataType
            local erorr=0
            dataTypeChecker ${metaDataTpeArr[targetPosition]} $newValue erorr
            if [ $erorr -eq 1 ]
            then
                printf "${Red}DataType Note Mached Expected ${metaDataTpeArr[targetPosition]}${Color_Off}\n";
                return 0;
            fi
            isprimary=${metaConstraintArr[targetPosition]}
            local erorr=0
            while read p; do
                IFS=':' read -ra rowArr <<< "$p";
                if [[ "${rowArr[$conditionCol]}" -gt "$condetionValue" ]];then
                    rowArr[$targetPosition]=$newValue
                    numOFchanges=$(($numOFchanges+1))
                fi
                if [ $isprimary -eq 1 ];then
                    local ind=1
                    ind=$(($targetPosition + $ind))
                    constraintChecker $ind ".${queryArr[1]}.tmp" ${rowArr[$targetPosition]} erorr 
                    if [ $erorr -eq 1 ]
                    then
                        break;
                    fi
                fi
                IFS=':';row="${rowArr[*]// /|}";IFS=$' \t\n'
                echo "$row"
            done < "$tableName" > ".${queryArr[1]}.tmp"
            if [ $erorr -eq 1 ]
            then
                    printf "${Red} ${queryArr[3]} is Primary Must be Unique and Not Null${Color_Off}\n";
                    return 0
            fi
            `mv .${queryArr[1]}.tmp $tableName`
        ;;
        "<")
            #Check If condetionValue Is a number
            isNumber $condetionValue erorr
            if [ $erorr -eq 1 ]
            then
                printf "${Red}ُExpexted Number in Condition${Color_Off}\n";
                return 0;
            fi
            #Check If condetionValue Is a number
            isNumber $condetionValue erorr
            if [ $erorr -eq 1 ]
            then
                printf "${Red}Expexted Number in Condition (<)${Color_Off}\n";
                return 0;
            fi
            # Check DataType
            local erorr=0
            dataTypeChecker ${metaDataTpeArr[targetPosition]} $newValue erorr
            if [ $erorr -eq 1 ]
            then
                printf "${Red}DataType Note Mached Expected ${metaDataTpeArr[targetPosition]}${Color_Off}\n";
                return 0;
            fi
            isprimary=${metaConstraintArr[targetPosition]}
            local erorr=0
            while read p; do
                IFS=':' read -ra rowArr <<< "$p";
                if [[ "${rowArr[$conditionCol]}" -lt "$condetionValue" ]];then
                    rowArr[$targetPosition]=$newValue
                    numOFchanges=$(($numOFchanges+1))
                fi
                if [ $isprimary -eq 1 ];then
                    local ind=1
                    ind=$(($targetPosition + $ind))
                    constraintChecker $ind ".${queryArr[1]}.tmp" ${rowArr[$targetPosition]} erorr 
                    if [ $erorr -eq 1 ]
                    then
                        break;
                    fi
                fi
                IFS=':';row="${rowArr[*]// /|}";IFS=$' \t\n'
                echo "$row"
            done < "$tableName" > ".${queryArr[1]}.tmp"
            if [ $erorr -eq 1 ]
            then
                    printf "${Red} ${queryArr[3]} is Primary Must be Unique and Not Null${Color_Off}\n";
                    return 0
            fi
            `mv .${queryArr[1]}.tmp $tableName`

        ;;
        ">=")
            #Check If condetionValue Is a number
            isNumber $condetionValue erorr
            if [ $erorr -eq 1 ]
            then
                printf "${Red}ُExpexted Number in Condition${Color_Off}\n";
                return 0;
            fi
            #Check If condetionValue Is a number
            isNumber $condetionValue erorr
            if [ $erorr -eq 1 ]
            then
                printf "${Red}Expexted Number in Condition (<)${Color_Off}\n";
                return 0;
            fi
            # Check DataType
            local erorr=0
            dataTypeChecker ${metaDataTpeArr[targetPosition]} $newValue erorr
            if [ $erorr -eq 1 ]
            then
                printf "${Red}DataType Note Mached Expected ${metaDataTpeArr[targetPosition]}${Color_Off}\n";
                return 0;
            fi
            isprimary=${metaConstraintArr[targetPosition]}
            local erorr=0
            while read p; do
                IFS=':' read -ra rowArr <<< "$p";
                if [[ "${rowArr[$conditionCol]}" -ge "$condetionValue" ]];then
                    rowArr[$targetPosition]=$newValue
                    numOFchanges=$(($numOFchanges+1))
                fi
                if [ $isprimary -eq 1 ];then
                    local ind=1
                    ind=$(($targetPosition + $ind))
                    constraintChecker $ind ".${queryArr[1]}.tmp" ${rowArr[$targetPosition]} erorr 
                    if [ $erorr -eq 1 ]
                    then
                        break;
                    fi
                fi
                IFS=':';row="${rowArr[*]// /|}";IFS=$' \t\n'
                echo "$row"
            done < "$tableName" > ".${queryArr[1]}.tmp"
            if [ $erorr -eq 1 ]
            then
                    printf "${Red} ${queryArr[3]} is Primary Must be Unique and Not Null${Color_Off}\n";
                    return 0
            fi
            `mv .${queryArr[1]}.tmp $tableName`
        ;;
        "<=")
            #Check If condetionValue Is a number
            isNumber $condetionValue erorr
            if [ $erorr -eq 1 ]
            then
                printf "${Red}ُExpexted Number in Condition${Color_Off}\n";
                return 0;
            fi
            #Check If condetionValue Is a number
            isNumber $condetionValue erorr
            if [ $erorr -eq 1 ]
            then
                printf "${Red}ُExpexted Number in Condition${Color_Off}\n";
                return 0;
            fi
            #Check If condetionValue Is a number
            isNumber $condetionValue erorr
            if [ $erorr -eq 1 ]
            then
                printf "${Red}Expexted Number in Condition (<)${Color_Off}\n";
                return 0;
            fi
            # Check DataType
            local erorr=0
            dataTypeChecker ${metaDataTpeArr[targetPosition]} $newValue erorr
            if [ $erorr -eq 1 ]
            then
                printf "${Red}DataType Note Mached Expected ${metaDataTpeArr[targetPosition]}${Color_Off}\n";
                return 0;
            fi
            isprimary=${metaConstraintArr[targetPosition]}
            local erorr=0
            while read p; do
                IFS=':' read -ra rowArr <<< "$p";
                if [[ "${rowArr[$conditionCol]}" -le "$condetionValue" ]];then
                    rowArr[$targetPosition]=$newValue
                    numOFchanges=$(($numOFchanges+1))
                fi
                if [ $isprimary -eq 1 ];then
                    local ind=1
                    ind=$(($targetPosition + $ind))
                    constraintChecker $ind ".${queryArr[1]}.tmp" ${rowArr[$targetPosition]} erorr 
                    if [ $erorr -eq 1 ]
                    then
                        break;
                    fi
                fi
                IFS=':';row="${rowArr[*]// /|}";IFS=$' \t\n'
                echo "$row"
            done < "$tableName" > ".${queryArr[1]}.tmp"
            if [ $erorr -eq 1 ]
            then
                    printf "${Red} ${queryArr[3]} is Primary Must be Unique and Not Null${Color_Off}\n";
                    return 0
            fi
            `mv .${queryArr[1]}.tmp $tableName`
        ;;
        *)
            printf "${Red}Syntax Erorr, Condition Operator NOT Suppurted ${queryArr[8]}${Color_Off}\n";
            return 0;
        ;;
        esac
    fi
    printf  " Update ${Green}success${Color_Off}\n"
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
        return 0
    fi
    if [ "$3" = "" ]
    then
        (($4=1));
        return 0
    fi
}
