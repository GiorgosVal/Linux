#!/bin/bash

# This script creates a new user on the local system.
# You will be prompt to enter the username (login), the person name and password.
# A basic validation is made against those inputs.
# If all goes well, the username, password and host for the account will be displayed.

# Declare some global variables
GENERIC_EXIT_MESSAGE='Exiting script'

# Assign the user id to a variable
USER_ID=${UID}
# Test that the user id is equal to 0 (root)
if [[ "${USER_ID}" -ne 0 ]]
then
	echo "Superuser privileges needed to execute this script."
	echo "${GENERIC_EXIT_MESSAGE}"
	exit 1
fi

# Ask for the username
read -p "Enter the username of the user you want to add: " USER_NAME

# Test that the given username is valid
if [[ -z "${USER_NAME}"  ]]
then
	echo "Username cannot be empty."
	echo "${GENERIC_EXIT_MESSAGE}"
	exit 1
fi
if [[ "${#USER_NAME}" -lt 4 ]] || [[ "${#USER_NAME}" -gt 8 ]]
then
	echo "Usernames must be 4 to 8 characters long."
	echo "'${USER_NAME}' has ${#USER_NAME} characters."
	echo "${GENERIC_EXIT_MESSAGE}"
	exit 1
fi
if ! [[ "${USER_NAME}" =~ [[:alnum:]] ]]
then
	echo "Username is not alphanumeric."
	echo "${GENERIC_EXIT_MESSAGE}"
	exit 1
fi
if [[ "${USER_NAME}" =~ [[:space:]] ]] || [[ "${USER_NAME}" =~ [[:blank:]] ]]
then
	echo "Username cannot contain  space or tab character."
	echo "${GENERIC_EXIT_MESSAGE}"
	exit 1
fi
if [[ "${USER_NAME}" =~ [[:punct:]] ]]
then
	echo "Username cannot contain puncuation or symbols."
	echo "${GENERIC_EXIT_MESSAGE}"
	exit 1
fi
if ! [[ "${USER_NAME}" =~ [[:lower:]] ]]
then
	echo "Username must be only lowercase contain puncuation or symbols"
	echo "${GENERIC_EXIT_MESSAGE}"
	exit 1
fi

# Ask for the full name
read -p "Enter the full name of the user: " FULL_NAME
# Test that the given full name is valid
if [[ -z "${FULL_NAME}"  ]]
then
	echo "Full name cannot be empty."
	echo "${GENERIC_EXIT_MESSAGE}"
	exit 1
fi
if [[ "${#FULL_NAME}" -lt 2 ]] || [[ "${#FULL_NAME}" -gt 30 ]]
then
	echo "Full names must be 2 to 30 characters long."
	echo "'${FULL_NAME}' has ${#FULL_NAME} characters."
	echo "${GENERIC_EXIT_MESSAGE}"
	exit 1
fi
if [[ "${FULL_NAME}" =~ [[:digit:]] ]]
then
	echo "Full name cannot contain numbers."
	echo "${GENERIC_EXIT_MESSAGE}"
	exit 1
fi
if [[ "${FULL_NAME}" =~ [[:punct:]] ]]
then
	echo "Full name cannot contain puncuation or symbols."
	echo "${GENERIC_EXIT_MESSAGE}"
	exit 1
fi

# Ask for the initial password
read -p "Enter the password of the user: " PASSWORD

# Test that the given password is not empty
if [[ -z "${PASSWORD}" ]]
then
	echo "Password cannot be empty."
	echo "${GENERIC_EXIT_MESSAGE}"
	exit 1
fi

# Create the new user, with the given user/comment
useradd -c "${FULL_NAME}" -m ${USER_NAME}
EXIT_STATUS=${?}
# Test that the command was executed successfully
if [[ "${EXIT_STATUS}" -ne 0 ]]
then
	echo "User creation failed."
	echo "useradd command exited with status ${EXIT_STATUS}."
	echo "${GENERIC_EXIT_MESSAGE}"
	exit 1
fi

# Change the user's password (force expiry?)
echo ${PASSWORD} | passwd --stdin ${USER_NAME}
# Test that the command was executed successfully
EXIT_STATUS=${?}
if [[ "${EXIT_STATUS}" -ne 0 ]]
then
	echo "Changing the password of user '${USER_NAME}' failed."
	echo "passwd command exited with status ${EXIT_STATUS}."
	echo "${GENERIC_EXIT_MESSAGE}"
	exit 1
fi

# Force password update on the first user login
passwd -e ${USER_NAME}
# Test that the command was executed successfully
EXIT_STATUS=${?}
if [[ "${EXIT_STATUS}" -ne 0 ]]
then
	echo "Enabling force password update on the first login of user '${USER_NAME}' failed."
	echo "passwd command exited with status ${EXIT_STATUS}."
	echo "${GENERIC_EXIT_MESSAGE}"
	exit 1
fi


# If all good display new user information
echo ""
echo "User creation success."
echo 'username:'
echo ${USER_NAME}
echo 'password:'
echo ${PASSWORD}
echo 'host:'
echo ${HOSTNAME}
exit 0
