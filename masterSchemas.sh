#!/usr/bin/bash
#------------- Create Schema ----------------

function createSchema(){
    #Master schema Inialization
    schemaIniat
    printf " Plz Enter the Number of Schema::"
    #Custom ReadInt
    readInt number
    for (( i=1; i<=$number; i++ )); do
        printf " Plz Enter the Schema$i Name:"
        #Custom NameCheck (Name is Valid and  Note Exist)
        ValidName name
        mkdir ./$name
        #Creat schema Meta File
        touch ./$name/.schema.meta
        printf  "${name} Schema Created ${Green} Successfully ${Color_Off}\n"
    done
}
#------------- Connect To Schema ---------------

function connectToSchema(){
    listDir=`ls -l | awk '/^d/{print $9}' | wc -l`
    if  [[ $listDir -gt 0 ]]
    then
        printf  "${On_IGreen}${BIBlack}Connecting To Schema Chose From List..... $Color_Off\n"
        schemaNames=`ls -d ./*/ | cut -d'/' -f2` 
        i=0
        getSchemaName selectedName
        cd ./$selectedName
        eval $1="'$selectedName'"
    else
        printf "${BRed}No Schema Created Yet${Color_Off} "
        eval $1=0
    fi
}
#------------- Initial Methods ----------------

#Creat  masterschemas .meta
function schemaIniat() {
    touch ./.masterschemas.meta > /dev/null
}
#Get Schema Name From User ::Return Schema To Conncet
function getSchemaName() {
    schemaNames=`ls -d ./*/ | cut -d'/' -f2` 
    i=0
    for schema in $schemaNames; do
        printf " $schema"
        schemaarr[$i]=$schema
        ((i++));
    done
    while [ true ]
    do
        printf "\nType Schema Name To Connect ${errorMassage}: "
        read  name;
        if  printf '%s\0' "${schemaarr[@]}" | grep -Fxqz -- "${name}"; then
            eval $1="'$name'"
            break
        fi
        errorMassage="${BRed}Enter Right Name Plz${Color_Off} ";
    done
}
#______________________ Main Methods ______________________

function masterSchemasMain(){
    printf "$Purple"
    startPWD=`pwd`
    #select num in "Press 1 To create Schema" "Press 2 to Connect to Schema" "Press 3 to Exit"
    while [ true ]
    do
        printf " Press 1 To create Schema\n Press 2 to Connect to Schema\n"
        read -p "$>" choice
        case $choice in 
        "1")
            createSchema
        ;;
        "2")
            connectToSchema name
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
        printf  "\n${On_Black}${BWhite} You Are in Master Schemas ${Color_Off}\n";
        
        
    done
    printf "$Color_Off"
} 