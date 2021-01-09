#!/bin/bash

VERBOSE=""

# This function sends a message to the syslog. It also sends it to the STDOUT if VERBOSE is true.
log() {
	local MESSAGE="${@}"
	if [[ "${VERBOSE}" = "true" ]]
	then
		echo "${MESSAGE}"
	fi
	
	TAG="$(basename ${0}) > ${FUNCNAME}"
	logger -t ${TAG} "${MESSAGE}"
}

backup_file() {
	local FILE="${1}"

	# Make sure the file exists
	if [[ -f "${FILE}" ]]
	then
		local BACKUP_FILE="/var/tmp/$(basename ${FILE}).$(date +%F-%N)"
		log "Backing up ${FILE} to ${BACKUP_FILE}."
		
		# Copy the file and preserve mode,ownership,timestamps
		# The exit status of the function will be the exit status of the cp command.
		cp -p ${FILE} ${BACKUP_FILE}
	else
		# The file does not exist, so return a non-zero exit status.
		return 1
	fi
}

case "${1}" in
	-v | --verbose)
		readonly VERBOSE="true"
		;;
	*)
		readonly VERBOSE="false"
		;;
esac



backup_file "/etc/passwd"
if [[ "${?}" -eq 0 ]]
then
	log 'File backup success.'
else
	log 'File backup failure.'
	exit 1
fi
exit 0
