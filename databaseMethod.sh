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
        printf  "${On_IGreen}${BIBlack}Connecting To Schema Chose From List..... $Color_Off\n"
        #get Valid Database Name
        getDatabaseName selectedName
        cd ./$selectedName
        eval $1="'$selectedName'"
    else
        printf "${BRed}No DataBase Created Yet${Color_Off} "
        eval $1=0
    fi
}
#------------- Initial Methods ----------------
#Get Schema Name From User ::Return Schema To Conncet
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
        printf " Press 1 To create dataBase\n Press 2 to Connect to DataBase\n"
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
        *)
            printf "${Red}Plz Select 1, 2, or 3${Color_Off}"
        ;;
        esac
        cd "${startPWD}"
        printf "$Color_Off"
        eval $schemaName="'$1'"
        printf  "\n${On_Black}${BWhite} You Are in $schemaName Schemas ${Color_Off}\n";
        
        
    done
    printf "$Color_Off"
}