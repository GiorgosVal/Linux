#!/bin/bash
# This script is a simple approach on generating random passwords automatically
# for a list of user names passed as arguments.
# Needs external script to generate password

EXTERNAL_SCRIPT="./password-generator.sh"

# If no arguments passed, exit
if [[ "${#}" -eq 0 ]]
then
	echo "Usage: ${0} USER_NAME [USER_NAME]..."
	exit 1
fi

# Call external script to generate a password
# Display the password for each parameter
for USER_NAME in "${@}"
do
	PASSWORD="$(sh ${EXTERNAL_SCRIPT})"
	if [[ "${?}" -eq 0 ]]
	then
		echo "${USER_NAME}: ${PASSWORD}"
	else
		echo "${EXTERNAL_SCRIPT} failed to execute successfully."
		exit 1
	fi
done
exit 0
