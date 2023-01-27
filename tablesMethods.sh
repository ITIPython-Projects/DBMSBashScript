#!/usr/bin/bash
source "colors.sh"
source "globalVariables.sh"
source "customMethod.sh"
#------------- Create Table ----------------
function createTable(){
    printf " Plz Enter the Number of Tables::"
    #Custom ReadInt
    readInt tablenumber
    for (( i=1; i<=$tablenumber; i++ )); do
        printf " Plz Enter the table$i Name:"
        #Custom NameCheck (Name is Valid and  Note Exist)
        ValidName tablename
        #Enter Number of Columns
        printf " Plz Enter the Number of Columns:: "
        readInt colnumber
        createdColumnsName=""
        columnDatatype=""
        columnConstraint=""
        for (( j=1; j<=$colnumber; j++ )); do
            printf " Plz Enter the Columns$j Name:"
            #Custom NameCheck (Name is Valid and  Note Exist)
            columnValidName name $createdColumnsName;
            createdColumnsName="$createdColumnsName:$name";
            select opt in "Press 1 for integer" "Press 2 for String" 
            do
                case $REPLY in 
                1)
                    columnDatatype="$columnDatatype:integer";
                ;;
                2)
                    columnDatatype="$columnDatatype:string";
                ;;
                *)
                    echo "PLZ Select 1 or 2 "
                ;;
                esac
                break
            done
            select opt in "Press 1 for primaryKey" " Press 2 for Not" 
            do
                case $REPLY in 
                1)
                    columnConstraint="$columnConstraint:1";
                ;;
                2)
                    columnConstraint="$columnConstraint:0";
                ;;
                *)
                    echo "PLZ Select 1 or 2 "
                ;;
                esac
                break
            done
            printf  "   ${name} Column Created ${Green} Successfully ${Color_Off}\n"
        done
        #Remove First ":" from String
        createdColumnsName=${createdColumnsName#?}
        columnDatatype=${columnDatatype#?}
        columnConstraint=${columnConstraint#?}
        #Creat MetaFile for the table
        metaName=".meta$tablename"
        touch ./$metaName
        echo $createdColumnsName > ./$metaName
        echo $columnDatatype >> ./$metaName
        echo $columnConstraint >> ./$metaName
        #Creat File
        touch ./$tablename
        printf  "${tablename} Table Created ${Green} Successfully ${Color_Off}\n"
    done
}


function tablesMain(){
    while [ true ]
    do
        printf " Press 1 To create Table\n Press 3 to Drop Table\n Press 3 to Make Query\n"
        read -p "$>" choice
        case $choice in 
        "1")
            createTable
        ;;
        "2")
            dropTable
        ;;
        "3")
            queryNavigator
        ;;
        *)
            printf "${Red}Plz Select 1, 2, 3${Color_Off}"
        ;;
        esac
    done
}
tablesMain