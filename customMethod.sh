#read Integer
source "globalVariables.sh"
function readInt() {
    while [ true ]; do
        read number
        if [[ ${number} =~ $NUMBERREGEXP ]]
        then
            (($1=$number));
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
#get Directories schemaNames=`ls -d ./*/`
function getDirectories(){
    schemaNames=`ls -d ./*/ | cut -d'/' -f2`

}