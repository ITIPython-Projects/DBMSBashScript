#!/usr/bin/bash
#------------- Create Database ----------------
function createDatabase(){
    printf " Plz Enter the Number of Database::"
    #Custom ReadInt
    readInt number
    for (( i=1; i<=$number; i++ )); do
        printf " Plz Enter the Database$i Name:"
        #Custom NameCheck (Name is Valid and  Note Exist)
        ValidName name
        mkdir ./$name
        #Creat db Meta File
        touch ./$name/.db.meta
        printf  "${name} Database Created ${Green} Successfully ${Color_Off}\n"
    done
}
#------------- Connect To database ---------------

function connectToDatabase(){
    listDir=`ls -l | awk '/^d/{print $9}' | wc -l`
    if  [[ $listDir -gt 0 ]]
    then
        printf  "${On_IGreen}${BIBlack}Connecting To Database Chose From List..... $Color_Off\n"
        #get Valid Database Name
        getDatabaseName selectedName
        cd ./$selectedName
        eval $1="'$selectedName'"
    else
        printf "${BRed}No DataBase Created Yet${Color_Off} "
        eval $1=0
    fi
}
#------------- list Database ----------------
function listDatabase(){
    dir=`ls -d */ | wc -l`
    if  [[ $dir -gt 0 ]]
    then
        echo "All DataBase: " `ls -d */ `
    else
        printf "${BRed}No DataBase Created Yet${Color_Off}\n "
    fi
}
#------------- Delete Database ----------------
function deleteDatabase(){
    listDir=`ls -l | awk '/^d/{print $9}' | wc -l`
    if  [[ $listDir -gt 0 ]]
    then
        printf  "${On_IGreen}${BIBlack}Chose From List..... $Color_Off\n"
        #get Valid Database Name
        getDatabaseName selectedName
        rm -r ./$selectedName
        printf  " Deleted ${Green}success${Color_Off}\n"
    else
        printf "${BRed}No DataBase Created Yet${Color_Off} "
    fi
}
#------------- Initial Methods ----------------
#Get database Name From User ::Return database To Conncet
function getDatabaseName() {
    databaseNames=`ls -d ./*/ | cut -d'/' -f2` 
    i=0
    for db in $databaseNames; do
        printf " $db"
        dbarr[$i]=$db
        ((i++));
    done
    while [ true ]
    do
        printf "\nType db Name To Connect ${errorMassage}: "
        read  name;
        if  printf '%s\0' "${dbarr[@]}" | grep -Fxqz -- "${name}"; then
            eval $1="'$name'"
            break
        fi
        errorMassage="${BRed}Enter Right Name Plz${Color_Off} ";
    done
}
#______________________ Main Methods ______________________
function databaseMain(){
    printf "$Purple"
    startPWD=`pwd`
    while [ true ]
    do
        printf " Press 1 To create dataBase\n Press 2 to Connect to DataBase\n Press 3 to List Database\n Press 4 to Delete Database\n"
        read -p "$>" choice
        case $choice in 
        "1")
            createDatabase
        ;;
        "2")
            connectToDatabase name
            case $name in
            0)
            ;;
            *)
                eval $1="'$name'"
                break
            ;;
            esac
            # Continue From Here if u want To add a Back Button 
        ;;
        "3")
            listDatabase
        ;;
        "4")
            deleteDatabase
        ;;
        *)
            printf "${Red}Plz Select 1, 2, 3 ${Color_Off}"
        ;;
        esac
        cd "${startPWD}"
        eval $schemaName="'$1'"
        printf  "\n${On_Black}${BWhite} You Are in $schemaName Schemas ${Color_Off}\n";
        
        
    done
    printf "$Color_Off"
}