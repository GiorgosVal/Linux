#!/bin/bash

# Display the UID and username of the user executing this script.
#Display if the user is the root user on not.
USER_ID_1=$UID
USER_ID_2=${UID}
echo "Your UID is ${UID}"
echo "USER_ID_1 is ${USER_ID_1}"
echo "USER_ID_2 is ${USER_ID_2}"
USER_NAME_1=$(id -un)
USER_NAME_2=`id -un`
MESSAGE="Your user id is ${UID} and your username is `id -un`."
echo "User id is $(id -un)"
echo "USER_NAME_1 ${USER_NAME_1}"
echo "USER_NAME_2 ${USER_NAME_2}"
echo $MESSAGE

if [[ "${UID}" -eq 0 ]]
then
	echo 'You are root.'
else
	echo 'You are not root.'
fi
