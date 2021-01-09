#!/bin/bash

echo "Your UID is ${UID}"
UID_TO_TEST_FOR='1000'

if [[ "${UID}" -ne "${UID_TO_TEST_FOR}" ]]
then
	echo "Your UID does not match ${UID_TO_TEST_FOR}."
	exit 1
fi

# Display the username
## Store the username in a variable
USER_NAME=$(id -un)

## Test id the command succeeded
if [[ "${?}" -ne 0 ]]
then
	echo 'The id command did not execute successfully.'
	exit 1
fi
echo "Your username is ${USER_NAME}."

USER_NAME_TO_TEST_FOR='vagrant'
if [[ "${USER_NAME}" = "${USER_NAME_TO_TEST_FOR}" ]]
then
	echo "Your username matches ${USER_NAME_TO_TEST_FOR}."
fi

if [[ "${USER_NAME}" != "${USER_NAME_TO_TEST_FOR}" ]]
then
	echo "Your username does not matche ${USER_NAME_TO_TEST_FOR}."
	exit 1
fi

exit 0
