#read Integer
source "globalVariables.sh"
function readInt() {
    while [ true ]; do
        read intnumber
        if [[ ${intnumber} =~ $NUMBERREGEXP ]]
        then
            (($1=$intnumber));
            break 
        else
            printf "${Red}Plz Enter Number: ${Color_Off}"
        fi
    done
}
#Valid Name Based on Regexp and Not Exist
function ValidName() {
    while [ true ]; do
        read  name
        if [[ ${name} =~ $NAMEREGEXP ]]
        then
            if [ `find -name "${name}"` ]
            then
                 printf "${Red} This Name Aready Exist Plz Enter another:${Color_Off} "
            else
                eval $1="'$name'"
                break
            fi 
        else
            printf "${Red} Plz Enter String start with${Green} (_) or Char ${Red} wihout any spicial characters ${Color_Off}"
        fi
    done
}
#column ValidName Name Based on Regexp and Not Created Before based on Createdarray
function columnValidName() {
    IFS=':' read -ra arrNames <<< "$2";  
    flag=1
    while [ true ]; do
        flag=1
        read  name
        if [[ ${name} =~ $NAMEREGEXP ]]
        then
            for k in "${arrNames[@]}";
            do
                if [ "$name" = "$k" ]
                then
                    printf "${Red} This Name Aready Exist Plz Enter another:${Color_Off} "
                    flag=0
                fi 
            done
            if [ $flag -eq 1 ]
            then
                eval $1="'$name'"
                break
            fi
            #eval $__resultvar="'$name'"
        else
            printf "${Red} Plz Enter String start with${Green} (_) or Char ${Red} wihout any spicial characters ${Color_Off}"
        fi
    done

}
#get Directories schemaNames=`ls -d ./*/`
function getDirectories(){
    schemaNames=`ls -d ./*/ | cut -d'/' -f2`
}
#Is A number
function isNumber() {
    if  [[ $1 =~ $NUMBERREGEXP ]]
    then
        (($2=0));
    fi
}