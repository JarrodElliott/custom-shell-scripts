#!/bin/bash
# createuser.sh
#**************************************************************************
# Script to add new user to this system
# Created by Jarrod Elliott https://github.com/JarrodElliott
#**************************************************************************


# Check if user is root (only allow root to create a new user)
if [ $(id -u) -eq 0 ]; then
        read -p "Enter username: " username
        egrep "^$username" /etc/passwd >/dev/null

        if [ $? -eq 0 ]; then #Username already used?
                echo "$username is already in use!"
                exit 1
        else
                pass_match=0
                while [ $pass_match -eq 0 ]; do
                        read -s -p "Enter randomly created default password (Be sure to write this down and give this to the the new user. It will be required to be changed upon the user's first login): " password
                        echo #newline
                        read -s -p "Confirm the password: " pass_confirm
                        if [ "${password}" = ${pass_confirm} ]; then
                                pass_match=1
                        else
                                echo #newline
                                echo "Passwords did not match. Try again."
                        fi
                done

                echo #newline
                pass=$(perl -e 'print crypt($ARGV[0], "password")' $password)
                useradd -m -d /home/$username -k /etc/skel -p $pass  $username

                # Created successfully?
                egrep "^$username" /etc/passwd > /dev/null
                if [ $? -eq 0 ]; then
                        echo "New user $username has been created successfully"
                else
                        echo "New user creation failed!"
                        exit 3
                fi

                chage -d 0 $username
        fi
        else
                echo "Only root may add a user to the system!"
                exit 2
        fi
