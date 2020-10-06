#!/bin/bash
create_database() {

    echo -n "Enter the name database you want created : "
    read database_name
    echo
    mkdir $database_name
    cd ${database_name}
    zenity --notification --text="Created database success" 
    echo "------------------------------------------"
    echo
}

create_table() {

    echo  "1. Create table "
    echo  "2. Exit "

    echo  -n "The option : "
    read option 
    echo

    if [ $option == "1" ]; then
        tab_name=0
        while true;
        do
            echo -n "Enter the name table you want to create :  "
            read tab_name 
            mang=$(dir)
            echo "$mang" >> temp
            s=$(grep -w "$tab_name" temp)
            if [ "$s" = "" ];then
                rm temp
                break
            else 
                zenity --error --text="the name table is dulicated"         
            fi
        done
        
        while true;  
        do
            echo -n "Enter the format (field_name data_type (primary or none) : "
            read field
            echo

            q=$(echo ${field} | cut -d" " -f1)
            if [ "${q}" == "2" ];then
                break
            else 
                echo "${field}" >> $tab_name
            fi
        done
        zenity --notification --text="Create table success" 
        echo "------------------------------------------"
        echo
    elif [ $option == "2" ]; then
        zenity --notification --text="Exit" 
        echo "------------------------------------------"
        echo
    fi

}

insert_record() {

   
    while true;
    do
        echo -n "Enter the name table you want to insert record : "
        read tab_name
        mang=$(dir)
        echo "$mang" >> temp
        s=$(grep -w "$tab_name" temp)
        if [ "$s" = "" ];then
            zenity --error --text="the name table has not created" 
            echo $mang
        else 
            rm temp
            break
        fi
    done

    tab_name_data=${tab_name}_data

    touch $tab_name_data

    count_field=$(cat ${tab_name} | wc -l)

    find_field_primary=$(cat ${tab_name} | cut -d" " -f3)
    primary_key=0
    for char in $find_field_primary
    do
        if [ $char == "primary" ]; then
            break;
        fi
        primary_key=$(($primary_key+1))
    done

    check_primary=$(cat ${tab_name_data} | cut -d" " -f1)

    echo "Enter record by format : (field1 field2 ...)"
    echo -n "Enter data : "
    read -a database
    if [ ${#database[@]} -gt $count_field ]
    then 
        zenity --error --text="Too much arguments" 
        echo "------------------------------------------"
        echo
        return
    elif [ ${#database[@]} -lt $count_field ]
    then
        zenity --error --text="Few arguments" 
        echo "------------------------------------------"
        echo
        return
    else
        for i in ${check_primary}
        do  
            if [ $i == ${database[$primary_key]} ];then
                zenity --error --text="The primary key is duplicated" 
                echo "------------------------------------------"
                echo
                return
            fi
        done
    fi
    echo ${database[*]} >> ${tab_name_data}
    zenity --notification --text="Insert success" 
    echo "------------------------------------------"
    echo
}

update_record() {
    
    while true;
    do
        echo -n "Enter the name table you want to update record : "
        read tab_name
        mang=$(dir)
        echo "$mang" >> temp
        s=$(grep -w "$tab_name" temp)
        if [ "$s" = "" ];then
            zenity --error --text="the name table has not created" 
            echo -n "the table is existed : " 
            echo $mang
        else 
            rm temp
            break
        fi
    done

    tab_name_data=${tab_name}_data
    echo "$tab_name_data"
    
    
    while true;
    do
        echo -n "Enter the the value have priamry key : "
        read primary_key
        mang=$(cat ${tab_name_data})
        echo "$mang" >> temp
        s=$(grep -w "$primary_key" temp)
        if [ "$s" = "" ];then
            zenity --error --text="the primary key is not existed" 
        else 
            rm temp
            break
        fi
    done


    record_data=$(grep  "$primary_key" ${tab_name_data})
    if [ -z "record_data" ];
    then
        echo "Error: does not exist record"
    else    
        # echo ${record_data}

        count_field=$(cat ${tab_name} | cut -d" " -f1|wc -l)
        echo -n "Found the record : $record_data"
        echo
        echo -n "Change your data for record : "
        read -a database
        echo

        if [ ${#database[@]} -gt $count_field ]
        then
            zenity --error --text="Too much arguments" 
            break
        fi
        if [ ${#database[@]} -lt $count_field ]
        then
            zenity --error --text="Few arguments" 
            break
        fi  
        cat ${tab_name_data} > temp        
        sed s/"${record_data}"/"${database[*]}"/ < temp > ${tab_name_data}
        rm temp
    fi
    zenity --notification --text="Update table success" 
    echo "------------------------------------------"
    echo
}

delete_record() {
    while true;
    do
        echo -n "Enter the name table : "
        read tab_name
        mang=$(dir)
        echo "$mang" >> temp
        s=$(grep -w "$tab_name" temp)
        if [ "$s" = "" ];then
            zenity --error --text="the name table has not created" 
            echo -n "the table is existed : " 
            echo $mang
        else 
            rm temp
            break
        fi
    done

    tab_name_data=${tab_name}_data

    while true;
    do
        echo -n "Enter the the value have priamry key : "
        read primary_key
        mang=$(cat ${tab_name_data})
        echo "$mang" >> temp
        s=$(grep -w "$primary_key" temp)
        if [ "$s" = "" ];then
            zenity --error --text="the primary key is not existed" 
        else 
            rm temp
            break
        fi
    done


    zenity --question --text "Are you sure you want to delete ?" 
    if [[ $? = 0 ]];
    then   
        record_data=$(grep "$primary_key" ${tab_name_data})
        cat ${tab_name_data} > temp
        sed /"${record_data}"/d < temp > $tab_name_data
        zenity --notification --text="Delete record success" 
    else
        zenity --notification --text="The record have not been deleted" 
    fi
    echo "------------------------------------------"
    echo

}

delete_table() {
    while true;
    do
        echo -n "Enter the name table : "
        read tab_name
        mang=$(dir)
        echo "$mang" >> temp
        s=$(grep -w "$tab_name" temp)
        if [ "$s" = "" ];then
            zenity --error --text="the name table has not created" 
            echo -n "the table is existed : " 
            echo $mang
        else 
            rm temp
            break
        fi
    done

    zenity --question --text "Are you sure you want to delete ?" 
    if [[ $? = 0 ]];
    then
        tab_name_data=${tab_name}_data
        rm $tab_name
        rm $tab_name_data    
        zenity --notification --text="Delete table success" 
    else
        zenity --notification --text="Table have not been deleted" 
    fi
    echo "------------------------------------------"
    echo
}

delete_database() {
    # echo -n "Enter the name database : "
    # read database
    # echo
    cd ..
    while true;
    do
        echo -n "Enter the name database : "
        read database
        mang=$(dir)
        echo "$mang" >> temp
        s=$(grep -w "$database" temp)
        if [ "$s" = "" ];then
            zenity --error --text="the database has not created" 
            echo -n "the table is existed : " 
            echo $mang
        else 
            rm temp
            break
        fi
    done

    zenity --question --text "Are you sure you want to delete ?" 
    if [[ $? = 0 ]];
    then
        rm -r $database   
        zenity --notification --text="Delete database success" 
        echo "--------------------------------------"
        echo $(dir)
    else
        zenity --notification --text="Database have not been deleted" 
    fi
    echo "------------------------------------------"
    echo
    
}

search_record() {
    
    while true;
    do
        echo -n "Enter the name table you want to search record : "
        read tab_name
        mang=$(dir)
        echo "$mang" >> temp
        s=$(grep -w "$tab_name" temp)
        if [ "$s" = "" ];then
            zenity --error --text="the name table has not created" 
            echo -n "the table is existed : " 
            echo $mang
        else 
            rm temp
            break
        fi
    done
    

    tab_name_data=${tab_name}_data

    echo -n "Enter the value of field you need to search : "
    read value
    echo

    record_data=$(grep "$value" ${tab_name_data})
    # echo $record_data

    echo -e "\n"
    echo -e "==================table data========================"
    header=$(cut -d" " -f1 ${tab_name})
    for i in $header
    do
        # echo -n "  $i         "
        printf "%-25s"  $i
    done
    echo
    echo -e "----------------------------------------------------"

    count_field=$(cat ${tab_name} | wc -l)
    i=-1
    for k in $record_data
    do
        if [ $i -lt $((count_field-1)) ]; then
            # echo -n "$k           "
            printf "%-25s"  $k
            i=$((i+1))
        else 
            echo
            # echo -n "$k            "
            printf "%-25s"  $k
            i=0
        fi
    done
    echo
    echo -e "====================================================="
    echo
   
}

display_data() {
    while true;
    do
        echo -n "Enter the name table : "
        read tab_name
        mang=$(dir)
        echo "$mang" >> temp
        s=$(grep -w "$tab_name" temp)
        if [ "$s" = "" ];then
            zenity --error --text="the name table has not created" 
            echo -n "the table is existed : " 
            echo $mang
        else 
            rm temp
            break
        fi
    done

    tab_name_data=${tab_name}_data
    echo -e "\n"
    echo -e "==================table data========================"
    header=$(cut -d" " -f1 ${tab_name})
    for i in $header
    do
        # echo -n "  $i         "
        printf "%-25s"  $i  
    done
    echo
    echo -e "----------------------------------------------------"
    
    a=$(cat ${tab_name_data})
    count_field=$(cat ${tab_name} | wc -l)
    i=-1
    for k in $a
    do
        if [ $i -lt $((count_field-1)) ]; then
            # echo -n "$k           "
            printf "%-25s"  $k 
            i=$((i+1))
        else 
            echo
            # echo -n "$k            "
            printf "%-25s"  $k 
            i=0
        fi
    done
    echo
    echo -e "====================================================="
    echo
}


menu() {
    echo "=========Database manage ==========="
    echo "||       1. Create Database       ||"
    echo "||       2. Create Table          ||"
    echo "||       3. Insert Record         ||"
    echo "||       4. Update Record         ||"
    echo "||       5. Search Record         ||"
    echo "||       6. Display Data          ||"
    echo "||       7. Delete Record         ||"
    echo "||       8. Delete Table          ||"
    echo "||       9. Delete Database       ||"
    echo "||       10.Exit                  ||"
    echo "===================================="
    echo
    
}
main() {
    while true;
    do 
        menu;
        echo -n "Choose your option : "
        read option
        case "$option" in
            "1") create_database;;
            "2") create_table;;
            "3") insert_record;;
            "4") update_record;;
            "5") search_record;;
            "6") display_data;;
            "7") delete_record;;
            "8") delete_table;;
            "9") delete_database;;
            "10") break;;
        esac
    done
    zenity --notification --text="Exit programming" 
    

}

main