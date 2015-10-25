#!/bin/bash
# deleteuser.sh

#******************************************************************************
# Script to delete an existing user from the system
#******************************************************************************

# Check is user is root (only allow root to delete user)
if [ $(id -u) -eq 0 ]; then

        read -p "Enter the username of the user you wish to delete: " username
        if [ "${username}" = 'root' ]; then
                echo "You cannot delete $username"
                exit 999
        fi

        # Check if user exists
        egrep "^$username" /etc/passwd > /dev/null

        # Check if argument
        if [ $? -eq 0 ]; then
                case $1 in
                        -f | --force )
                        read -p "Using -f will stop all processes owned by this user and permanently delete this user's home directory. Are you sure you want to delete $username? [y/N]: " response
                                if [[ $response =~ ^([Yy][eE][sS]|[yY])$ ]]; then
                                        pkill -u $username
                                        deluser --remove-home $username
                                        force_flag=1
                                else
                                        echo "Exiting... $username NOT removed."
                                        exit 4
                                fi
                                        ;;
                        * )             pkill -u $username
                                        deluser $username
                                        force_flag=0;
                                        ;;
                esac

        if [ $force_flag -eq 0 ]; then
                echo "$username has successfully been deleted. "$username"'s home directory must be deleted manually."
        else
                echo "$username has successfully been deleted. "$username"'s home directory has been removed forcefully. All processed have been killed and this user's files have been deleted."
        fi
        else
                echo "The user you are trying to delete does not exist!"
                exit 1
        fi


else
        echo "Only root may delete a user from the system!"
        exit 2
fi
