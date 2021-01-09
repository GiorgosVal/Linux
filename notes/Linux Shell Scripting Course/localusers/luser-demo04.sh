#!/bin/bash

read -p 'Enter the username to create: ' USER_NAME
read -p 'Enter the name of the person who this account is for: ' COMMENT
read -s -p 'Enter the password to use for the account: ' PASSWORD
useradd -c "${COMMENT}" -m ${USER_NAME}
echo "${PASSWORD}" | passwd --stdin ${USER_NAME}
passwd -e ${USER_NAME}
