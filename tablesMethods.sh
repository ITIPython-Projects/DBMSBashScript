#!/usr/bin/bash
#------------- Create Table ----------------
function createTable(){
    printf " Plz Enter the Number of Tables::"
    #Custom ReadInt
    readInt number
    for (( i=1; i<=$number; i++ )); do
        printf " Plz Enter the Database$i Name:"
        #Custom NameCheck (Name is Valid and  Note Exist)
        ValidName name
        #Creat File
        touch ./$name
        #Creat MetaFile
        printf  "${name} Table Created ${Green} Successfully ${Color_Off}\n"
        #Enter Number of Columns
        printf " Plz Enter the Number of Columns::"
        for (( i=1; i<=$number; i++ )); do
            printf " Plz Enter the Columns$i Name:"
            #Custom NameCheck (Name is Valid and  Note Exist)
            columnValidName name arrColumnsName[@];
            arrColumnsName[i-1]=name;
            printf  "   ${name} Column Created ${Green} Successfully ${Color_Off}\n"
            #Enter Number of Columns
        done

    done
}


function tablesMain(){
    while [ true ]
    do
        printf " Press 1 To create Table\n Press 2 to Make Query\n"
        read -p "$>" choice
        case $choice in 
        "1")
            createTable
        ;;
        "2")
            makeQuery
        ;;
        *)
            printf "${Red}Plz Select 1, 2${Color_Off}"
        ;;
        esac
    done
}