#!/bin/bash
# Option variables
SERVER_FILE='/vagrant/servers'
VERBOSE='false'
DRY_RUN='false'
SUDO=''

# Other configuration variables
SSH_OPTIONS="-o ConnectTimeout=2"

usage() {
    echo "NAME: $(basename ${0})"
    echo
    echo "DESCRIPTION:"
    echo "    Execute a COMMAND  passed as argument on multiple servers."
    echo
    echo "USAGE:"
    echo "    $(basename ${0}) [-vsn] [-f FILE] COMMAND"
    echo
    echo "OPTIONS"
    echo "    -v"
    echo "        Enable verbose mode. Will display the name of the server"
    echo "        for which the command is being executed on."
    echo "    -s"
    echo "        Run the commands with sudo (superuser) privileges on the"
    echo "        remote servers."
    echo "    -n"
    echo "        Dry run. The commands will be displayed on the STDOUT"
    echo "        instead of executed, and will be preceded with DRY RUN:"
    echo "        prefix."
    echo "    -f FILE"
    echo "        Override the default /vagrant/servers file."
}

# If user is root exit
if [[ "${UID}" -eq 0 ]]
then
    echo "Run as not root user or without sudo." >&2
    usage >&2
    exit 1
fi

# If no arg is provided so manual
if [[ "${#}" -eq 0 ]]
then
    usage >&2
    exit 1
fi

# Parse arguments
while getopts f:nsv OPTION
do
    case ${OPTION} in
        v)
            VERBOSE='true'
#            echo "Verbose mode on."
            ;;
        s)
            SUDO=' sudo'
#            echo "Sudo on."
            ;;
        n)
            DRY_RUN='true'
#            echo "Dry run on."
            ;;
        f)
            if [[ -e "${OPTARG}" ]]
            then
                SERVER_FILE="${OPTARG}"
#                echo "Server file ${SERVER_FILE}"
            else
                echo "Server file ${OPTARG} not found." >&2
                exit 1
            fi
            ;;
        *)
            usage >&2
            exit 1
            ;;
    esac
done

# Remove all options while leaving the remaining arguments.
shift "$(( OPTIND -1 ))"

# If no command is given show usage and exit
if [[ "${#}" -lt 1 ]]
then
    usage >&2
    exit 1
fi
CMD="${@}"

# Loop through the servers and execute the command
EXIT_STATUS=0
for SERVER in $(cat "${SERVER_FILE}")
do  
    if [[ "${VERBOSE}" == 'true' ]]
    then
        echo "${SERVER}"
    fi

    SSH_COMMAND="ssh ${SSH_OPTIONS} ${SERVER} 'set -o pipefail; ${SUDO} ${CMD}'"
    if [[ "${DRY_RUN}" == 'true' ]]
    then
        echo "DRY_RUN: ssh ${SSH_OPTIONS} ${SERVER} \"set -o pipefail;${SUDO} ${CMD}\""
    else
        ssh ${SSH_OPTIONS} ${SERVER} "set -o pipefail;${SUDO} ${CMD}"
        STATUS="$?"
        if [[ "${STATUS}" -ne 0 ]]
        then
            echo "The command did not executed successfully on server ${SERVER}." >&2
            EXIT_STATUS=${STATUS}
        fi
    fi
done
exit ${EXIT_STATUS}
