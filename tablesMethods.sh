#!/usr/bin/bash
source "queryMethods.sh"
#------------- Create Table ----------------
function createTable(){
    printf " Plz Enter the Number of Tables::"
    #Custom ReadInt
    readInt tablenumber
    for (( i=1; i<=$tablenumber; i++ )); do
        printf " Plz Enter the table$i Name:"
        #Custom NameCheck (Name is Valid and  Note Exist)
        ValidName tablename
        #Lower Case Name
        tablename=`echo $tablename | tr "[:upper:]" "[:lower:]"`
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
            #LowerCase Column Name
            name=`echo $name | tr "[:upper:]" "[:lower:]"`
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
            select opt in "Press 1 for primaryKey" "Press 2 for Not" 
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
function listTables(){
    files=`ls -p | grep -v / | wc -l`
    if  [[ $files -gt 0 ]]
    then
        echo "All Tables: " `ls -p | grep -v / `
    else
        printf "${BRed}No Tables Created Yet${Color_Off}\n "
    fi
}
function dropTable(){
    files=`ls -p | grep -v / | wc -l`
    if  [[ $files -gt 0 ]]
    then
        printf  "${On_IGreen}${BIBlack}Chose From List..... $Color_Off\n"
        echo "All Tables: " `ls -p | grep -v / `
        read selectedName
        rm  ./$selectedName
        printf  " Deleted ${Green}success${Color_Off}\n"
    else
        printf "${BRed}No Tables Created Yet${Color_Off}\n "
    fi
}
#------------- Query Navigator Table ----------------
function queryNavigator(){
    printf " Type Exit to Extit\n"
    while [ true ]
    do
        #Get Query
        query="empty"
        printf " Query>>:: ${BCyan}"
        read query
        printf $Color_Off
        #Lower Case Query
        querylower=`echo $query | tr "[:upper:]" "[:lower:]"`
        #check Query Type    
        case `echo $querylower | cut -d" " -f1` in 
        "select")
            selectQuery $querylower
        ;;
        "insert")
            insertQuery $querylower
        ;;
        "delete")
            delectQuery $querylower
        ;;
        "update")
            updateQuery $querylower
        ;;
        "exit")
            break;
        ;;
        *)
            printf "${Red}Syntax Erorr near to `echo $query | cut -d" " -f1`${Color_Off}\n"
        ;;
            esac
    done
}

function tablesMain(){
    while [ true ]
    do
        printf " Press 1 To create Table\n Press 2 to List Tables\n Press 3 to Drop Table\n Press 4 to Make Query\n"
        read -p "$>" choice
        case $choice in 
        "1")
            createTable
        ;;
        "2")
            listTables
        ;;
        "3")
            dropTable
        ;;
        "4")
            queryNavigator
        ;;
        *)
            printf "${Red}Plz Select 1, 2, 3${Color_Off}\n"
        ;;
        esac
    done
}