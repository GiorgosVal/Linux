#/bin/bash
NUMBER_OF_PARAMETERS="${#}"
echo "From the directory: $(dirname ${0})"
echo "You supplied ${NUMBER_OF_PARAMETERS} argument(s) on the command line."

if [[ "${NUMBER_OF_PARAMETERS}" -lt 1 ]]
then
	echo "Usage: ${0} USER_NAME [USER_NAME]..."
	exit 1
fi

# Looping through the arguments
for PARAM
do
	echo "You gave the parameter: ${PARAM}"
done
echo

# Looping through the arguments
for PARAM in "${@}"
do
	echo "You gave the parameter: ${PARAM}"
done
echo

# WRONG - NOT looping through the arguments
PARAMETERS="${@}"
echo "You executed the script: $(basename ${0})"
for PARAM in ${PARAMETERS}
do
	echo "You gave the parameter: ${PARAM}"
done
echo

# WRONG - NOT looping through the arguments
for PARAM in "${*}"
do
	echo "You gave the parameter: ${PARAM}"
done
echo
