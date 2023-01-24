#!/usr/bin/bash
#Packages
export LC_COLLATE=C
shopt -s extglob
#File Include
source "colors.sh"
source "globalVariables.sh"
source "customMethod.sh"
#source "masterSchemas.sh"
#source "databaseMethod.sh"

function main() {
    # Check for Existing meta files
    #----------------Connect To Schema-----------------------
    case `find . -maxdepth 1 -name "*.meta" | cut -d"." -f3` in 
    "masterschemas")
        mastername=`pwd | grep -o "[^/]*$"`;
        printf  "${On_Black}${BWhite} You Are in Master Schemas name ${mastername} $Color_Off\n";
        masterSchemasMain name
        printf  "${On_Yellow}${BBlack} You Are now connected to ${name} Schemas $Color_Off\n";
    ;;
    "schema")
        name=`pwd | grep -o "[^/]*$"`;
        printf  "${On_Yellow}${BBlack} You Are now connected to ${name} Schemas $Color_Off\n";
    ;;
    "db")
        dbflage=1 # To Conncet to database in Database Section
    ;;
    *)
        printf  "${On_Black}${BWhite} You Are in Empty Folder No(Schema,Db) $Color_Off\n";
        masterSchemasMain name
        printf  "${On_Yellow}${BBlack} You Are now connected to ${name} Schemas $Color_Off\n";
    ;;
        esac

    #----------------Connect To DataBase-----------------------
    :'
    if  [[ $dbflage -eq 1 ]]
    then
        dbname=`pwd | grep -o "[^/]*$"`;
        printf  "${On_Purple}${BWhite} You Are now connected to (${dbname}) Database  $Color_Off\n";
    else
        schemaName=`pwd | grep -o "[^/]*$"`;
        databaseMain name schemaName
        printf  "${On_Purple}${BWhite} You Are now connected to Schema->${schemaName} Database->(${name}) $Color_Off\n";
    fi
    #----------------Db Operations-----------------------
    '

}


#Start
main
