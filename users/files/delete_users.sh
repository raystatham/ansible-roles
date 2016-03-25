#!/bin/bash

# Create array of disovered users
getArrayDU() {
    discovered_users=() # Create array
    while IFS= read -r line # Read a line
    do
        discovered_users+=("$line") # Append line to the array
    done < "$1"
}

# Create array of Permitted users
getArrayPU() {
    permitted_users=() # Create array
    while IFS= read -r line # Read a line
    do
        permitted_users+=("$line") # Append line to the array
    done < "$1"
}

getArrayDU "/root/discovered_users.txt"
getArrayPU "/root/permitted_users.txt"

# Create a diff of the two arrays: delete_users = discovered_users - permitted_users
delete_users=()
for i in "${discovered_users[@]}"; do
     skip=
     for j in "${permitted_users[@]}"; do
         [[ $i == $j ]] && { skip=1; break; }
     done
     [[ -n $skip ]] || delete_users+=("$i")
done

# Delete the remaining user accounts
for i in "${delete_users[@]}"
do
    echo "Killing all processes for user $i"
    pkill -u $i
    echo "Deleting account for user $i"
    userdel -fr $i
done
