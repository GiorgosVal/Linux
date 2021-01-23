#!/bin/bash

# This script creates a new user on the local system.

# Declare some global variables
EXIT_REASON="\nEXIT REASON:"
GENERIC_EXIT_MESSAGE="\nExiting script\n"
USAGE_FILE="usage.txt"
# Assign the user id to a variable
USER_ID=${UID}
USER_NAME=""
COMMENT=""
# Test that the user id is equal to 0 (root)
if [[ "${USER_ID}" -ne 0 ]]
then
	echo -e "${EXIT_REASON} Not root user or sudo privileges.\n" >&2
	cat ${USAGE_FILE} >&2
	echo -e "${GENERIC_EXIT_MESSAGE}" >&2
	exit 1
fi

# Check that at least 2 arguments are present
if [[ "${#}" -lt 2 ]]
then
	echo -e "${EXIT_REASON} Not enough arguments.\n" >&2
	cat ${USAGE_FILE} >&2
	echo -e "${GENERIC_EXIT_MESSAGE}" >&2
	exit 1
fi

# Read arguments
USER_NAME="${1}"
shift
COMMENT="${*}"

# Test that the given username is valid
if [[ "${#USER_NAME}" -lt 4 ]] || [[ "${#USER_NAME}" -gt 8 ]]
then
	echo -e "${EXIT_REASON} USER_NAME has not proper length (${#USER_NAME}).\n" >&2
	cat ${USAGE_FILE} >&2
	echo -e "${GENERIC_EXIT_MESSAGE}" >&2
	exit 1
elif ! [[ "${USER_NAME}" =~ [[:alnum:]] ]]
then
	echo -e "${EXIT_REASON} USER_NAME is not alphanumeric (${USER_NAME}).\n" >&2
	cat ${USAGE_FILE} >&2
	echo -e "${GENERIC_EXIT_MESSAGE}" >&2
	exit 1
elif [[ "${USER_NAME}" =~ [[:punct:]] ]]
then
	echo -e "${EXIT_REASON} USER_NAME contains puncuation or symbols.\n" >&2
	cat ${USAGE_FILE} >&2
	echo -e "${GENERIC_EXIT_MESSAGE}" >&2
	exit 1
fi

# Test that the given COMMENT is valid
if [[ "${#COMMENT}" -lt 2 ]] || [[ "${#COMMENT}" -gt 256 ]]
then
	echo -e "${EXIT_REASON} COMMENT has not proper length (${#COMMENT}).\n" >&2
	cat ${USAGE_FILE} >&2
	echo -e "${GENERIC_EXIT_MESSAGE}" >&2
	exit 1
fi

# Generate password
PASSWORD_SUFF=$(date +%s%N${RANDOM}${RANDOM} | sha256sum | head -c48)
SPECIAL_CHARACTER=$(echo '!@#$%^&*()_-+=' | fold -w1 | shuf | head -c1)
PASSWORD=${PASSWORD_SUFF}${SPECIAL_CHARACTER}

# Create the new user, with the given user/comment
useradd -c "${COMMENT}" -m ${USER_NAME} &> /dev/null
EXIT_STATUS=${?}
# Test that the command was executed successfully
if [[ "${EXIT_STATUS}" -ne 0 ]]
then
	echo -e "${EXIT_REASON} User creation failed." >&2
	echo "useradd command exited with status ${EXIT_STATUS}." >&2
	echo -e "${GENERIC_EXIT_MESSAGE}" >&2
	exit 1
fi

# Change the user's password
echo ${PASSWORD} | passwd --stdin ${USER_NAME} &> /dev/null
# Test that the command was executed successfully
EXIT_STATUS=${?}
if [[ "${EXIT_STATUS}" -ne 0 ]]
then
	echo -e "${EXIT_REASON} Changing the password of user '${USER_NAME}' failed." >&2
	echo "passwd command exited with status ${EXIT_STATUS}." >&2
	echo -e "${GENERIC_EXIT_MESSAGE}" >&2
	exit 1
fi

# Force password update on the first user login
passwd -e ${USER_NAME} &> /dev/null
# Test that the command was executed successfully
EXIT_STATUS=${?}
if [[ "${EXIT_STATUS}" -ne 0 ]]
then
	echo "${EXIT_REASON} Enabling force password update on the first login of user '${USER_NAME}' failed." >&2
	echo "passwd command exited with status ${EXIT_STATUS}." >&2
	echo -e "${GENERIC_EXIT_MESSAGE}" >&2
	exit 1
fi


# If all good display new user information
echo "User creation success."
echo 'username:'
echo ${USER_NAME}
echo 'password:'
echo ${PASSWORD}
echo 'host:'
echo ${HOSTNAME}
exit 0
