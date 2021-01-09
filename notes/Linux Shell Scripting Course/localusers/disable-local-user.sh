#!/bin/bash
# Version
VERSION='1.0'
VERSION_DATE='2021 January'
PROJECT_LINK='link expected'
CREATOR='Giorgos Valamatsas'
CREATOR_LINK='https://github.com/GiorgosVal'

# Global variables that can change through the arguments provided
MODE='disable'      # possible values: disable, delete
REMOVE_HOME=false   # possible values: true, false
ARCHIVE=false       # possible values: true, false
ARCHIVE_FORMAT='gz' # possible values: gz, tgz, bzip2, xz
ARCHIVE_DIR='/archives'
VERBOSE_LEVEL=2
USERNAMES=''

# Global variables that can change from the script
HOME_REMOVE_ALLOWED='false'
USER_TO_PROCCESS=''
USER_IS_ACTIVE='false'
USERS_HOME=''
USERS_HOME_EXISTS='false'
USER_PROCESSING_ALLOWED='false'
ARCHIVE_FILE_FULL_PATH=''
PROCESS_MODE='0'
PREF=''
# Global variables set only once
readonly TODAY=$(date +%s)
readonly LOG_PATH="./$(basename -s .sh ${0}).log"

# Runs before each user process.
resore_defaults(){
    PREF="${FUNCNAME} >:"
    log 1 "${FUNCNAME} start."
    HOME_REMOVE_ALLOWED='false'
    USER_TO_PROCCESS=''
    USER_IS_ACTIVE='false'
    USERS_HOME=''
    USERS_HOME_EXISTS='false'
    USER_PROCESSING_ALLOWED='false'
    ARCHIVE_FILE_FULL_PATH=''
    PROCESS_MODE='0'
    log 1 "${FUNCNAME} end."
}

usage() {
    echo
    echo "USAGE: sudo ${0} [-dra] [-f ARCHIVE_FORMAT] [-v VERBOSE_LEVEL] USERNAME.."
    echo
    echo "DESCRIPTION:"
    echo "    Disables (default functionality) or deletes the given account(s)"
    echo "    passed as space separated arguments."
    echo "    Optionaly, it removes and/or archives the home directory associated"
    echo "    with the account(s) to be deleted."
    echo
    echo "    NOTE: The script won't delete system's users (users that have a UID"
    echo "          less than or equal to the SYS_UID_MAX defined in the /etc/login.defs)."
    echo
    echo "OPTIONS:"
    echo "    -d (delete)"
    echo "         Deletes the account(s) instead of disabling them."
    echo
    echo "    -r (remove home)"
    echo "         Removes the home directory associated with the account(s)."
    echo "         If a home directory is shared with other user(s) that are not"
    echo "         going to be deleted/disabled, then the script won't delete"
    echo "         that directory and will display a warning message."
    echo
    echo "    -a (archive home)"
    echo "         Creates a compressed archive of the home directory associated"
    echo "         with the account(s) and stores it in the ARCHIVE_DIR."
    echo "         Implies the '-r' option."
    echo
    echo "         If the associated home directory is shared by other user(s) "
    echo "         that are not going to be deleted/disabled, the script won't delete"
    echo "         and won't archive that directory and will display a warning message."
    echo
    echo "         If the ARCHIVE_DIR does not exist, the script creates it."
    echo
    echo "    -f (file format)"
    echo "         Choose compression between gz (default), tgz, bzip2 and xz."
    echo
    echo "    -v (verbose)"
    echo "         Enables verbose mode for the VERBOSE_LEVEL chosen."
    echo
    echo "    -h (help)"
    echo "         Display help (this message)."
    echo
    echo "    -i (info)"
    echo "         Show the version of the script."
    echo
    echo "VARIABLES:"
    echo "    ARCHIVE_DIR: The path where the compressed archive created by the"
    echo "         -a option will be stored. Value is /archive."
    echo
    echo "    ARCHIVE_FORMAT: The compression format defined by the -f option."
    echo "         Possible values: gz (default), tgz, bzip2, xz."
    echo
    echo "    VERBOSE_LEVEL: The log level for the verbose mode."
    echo "         Possible values: 1 (DEBUG), 2 (INFO - default), 3 (WARN), 4 (ERROR)."
    echo "         e.g.: -v3 will only show WARN and ERROR logs in the STDOUT."
    echo
    echo "    USERNAME: The username(s) to delete or disable. Use space to separate"
    echo "         each username."
    echo
    echo "EXAMPLES:"
    echo "    sudo ${0} mario luigi"
    echo "        # Will disable the users mario and luigi"
    echo "    sudo ${0} -d mario luigi"
    echo "        # Will delete the users."
    echo "    sudo ${0} -dr mario luigi"
    echo "        # Will delete the users and their home directory."
    echo "    sudo ${0} -da mario luigi"
    echo "        # Will delete the users and their home directory, and also create"
    echo "        # /archives/mario.tar.gz and /archives/luigi.tar.gz files."
    echo
    echo "USE CASES:"
    echo "    For an ACTIVE user with an EXISTING home directory the script can:"
    echo "        - Disable or delete the user"
    echo "        - Delete or archive/delete his home directory"
    echo "    For an INACTIVE user with an EXISTING home directory the script can:"
    echo "        - Delete the user"
    echo "        - Delete or archive/delete his home directory"
    echo "    For an ACTIVE user with a NOT EXISTING home directory the script can:"
    echo "        - Disable or delete the user"
    echo "    For an INACTIVE user with a NONT EXISTING home directory the script can:"
    echo "        - Delete the user"
}

version()
{
    echo
    echo "Name: $(basename ${0})"
    echo "Version: ${VERSION}"
    echo "Date: ${VERSION_DATE}"
    echo "Project on GitHub: ${PROJECT_LINK}"
    echo
    echo "Creator: ${CREATOR}"
    echo "GitHub: ${CREATOR_LINK}"
    echo
}

show_config() {
    PREF="${FUNCNAME} >:"
    log 1 "Started the script with the following configuration:"
    log 1 "MODE: ${MODE}"
    log 1 "REMOVE_HOME: ${REMOVE_HOME}"
    log 1 "ARCHIVE: ${ARCHIVE}"
    log 1 "ARCHIVE_FORMAT : ${ARCHIVE_FORMAT}"
    log 1 "ARCHIVE_DIR : ${ARCHIVE_DIR}"
    log 1 "VERBOSE_LEVEL: ${VERBOSE_LEVEL}"
    log 1 "USERNAMES: ${USERNAMES}"
}

# Logger function which redirects the STDOUT and STDERR to a log file.
# The 1st argument is the log level (1 for DEBUG, 2 for INFO, 3 for WARNING, 4 for ERROR).
# All other arguments are the values to log.
# If verbose mode is enabled, it also prints the log level logs chosen.
log() {
    if [[ "${#}" -lt 2 ]]
    then
        echo "${FUNCNAME} >: ${FUNCNAME} function requires at least 2 arguments."
        return 1
    fi

    local LOG_LEVEL_NUM=${1}
    local LOG_LEVEL

    case ${LOG_LEVEL_NUM} in
        1)
            LOG_LEVEL='DEBUG'
            ;;
        2)
            LOG_LEVEL='INFO'
            ;;
        3)
            LOG_LEVEL='WARNING'
            ;;
        4)
            LOG_LEVEL='ERROR'
            ;;
        *)
            echo "${FUNCNAME} >: ${1} is not a valid log level. Must be 1-4."
            return 1
            ;;
    esac

    shift
    local MESSAGE=${@}
    local LOG="$(date '+%F %H:%M:%S.%N') [${LOG_LEVEL}] >: ${PREF} ${MESSAGE}"

    echo -e "${LOG}" 1>> ${LOG_PATH}
    # -le operator means that if the user has selected INFO verbose level (2)
    # and the log has INFO, WARN, ERROR log level, the user will see it.
    if [[ "${VERBOSE_LEVEL}" -le "${LOG_LEVEL_NUM}" ]]
    then
        echo -e "${LOG}"
    fi
}

# Checks if the user passed as argument is active by invoking the 'chage -l <username>' command.
# It assumes that the user exists.
# If the user is active returns 0
# If the user is not active returns 1
# If other error occurs returns 2
check_if_user_is_active(){
    PREF="${FUNCNAME} >:"
    log 1 "${FUNCNAME} start."
    if [[ "${#}" -ne 1 ]] || [[ -z "${1}" ]]
    then
        log 4 "${FUNCNAME} function must be called with 1 argument."
        return 2
    fi
    local POSSIBLE_USER="${1}"
    log 1 "Checking if the ${POSSIBLE_USER} is active."
    # Find when the user account expires
    # Possible values: never, or a date like Jan 07, 2024
    local EXPIRES=$(chage -l ${POSSIBLE_USER} | grep "Account expires" | cut -d: -f2 | sed 's/^[[:blank:]]*//')
    local EXPIRY_DAY=$(date +%s --date "${EXPIRES}" 2> /dev/null )
    log 1 "The user ${POSSIBLE_USER} expires '${EXPIRES}', which is '${EXPIRY_DAY}' days since Jan 01, 1970."

    # If the OTHER_USER is active set HOME_REMOVE_ALLOWED=false
    if [[ "${EXPIRES}" = 'never' ]] || [[ "${EXPIRY_DAY}" -ge "${TODAY}" ]]
    then
        log 1 "${FUNCNAME} end with status 0."
        return 0
    else
        log 1 "${FUNCNAME} end with status 1."
        return 1
    fi
}

# This function checks if the user's USER_TO_PROCCESS home directory is shared with other active users.
# If the home is shared, it sets the HOME_REMOVE_ALLOWED to false, else true.
# 
check_if_users_home_removal_is_allowed() {
    PREF="${FUNCNAME} >:"
    local STATUS
    local OTHER_USER
    log 1 "${FUNCNAME} start."

    if [[ -z "${USER_TO_PROCCESS}" ]]
    then
        log 4 "USER_TO_PROCCESS must not be empty."
        return 1
    fi

    log 2 "Checking if the '${USER_TO_PROCCESS}' user has an existing home directory."
    USERS_HOME=$(getent passwd ${USER_TO_PROCCESS} | cut -d: -f6) # e.g. /home/user
    if [[ -d "${USERS_HOME}" ]]
    then
        USERS_HOME_EXISTS=true
        log 2 "${USER_TO_PROCCESS}'s home directory is: ${USERS_HOME}"
    else
        USERS_HOME_EXISTS=false
        HOME_REMOVE_ALLOWED=false
        log 2 "${USER_TO_PROCCESS}'s home directory was '${USERS_HOME}' but it does not exist. "
        return
    fi
    
    log 2 "Checking if the home directory of ${USER_TO_PROCCESS} is allowed to be removed."
    log 1 "Will check how many users have the same home."
    COUNT=$(cat /etc/passwd | grep -w "${USERS_HOME}" | wc -l)
    log 2 "Found ${COUNT} user(s) having this home."
    
    HOME_REMOVE_ALLOWED=true
    
    for  (( i=1; i <= "${COUNT}"; i++ ))    # itterate for each user found
    do
        # retrieve only one user's username from the passwd file, incrementally
        OTHER_USER=$(cat /etc/passwd | grep -w "${USERS_HOME}" | cut -d: -f1 | sed -n ${i}p)
        
        # The check will not happen for the same user
        if [[ "${USER_TO_PROCCESS}" != "${OTHER_USER}" ]]
        then
            check_if_user_is_active ${OTHER_USER}
            STATUS=$?
            PREF="${FUNCNAME} >:"
            if [[ "${STATUS}" -eq 0 ]]  # if the other user IS active
            then
                HOME_REMOVE_ALLOWED=false
                log 3 "${OTHER_USER} is active. His home directory is not allowed to be removed."
                log 3 "HOME_REMOVE_ALLOWED set to ${HOME_REMOVE_ALLOWED}."
                break
            fi
        fi
    done
    log 2 "After checking all users that might use the same home directory the result is:"
    log 2 "HOME_REMOVE_ALLOWED : ${HOME_REMOVE_ALLOWED}"
    log 1 "${FUNCNAME} end."
    return 0
}


# This function checks if the user USER_TO_PROCCESS is allowed to be processed, and sets the USER_PROCESSING_ALLOWED accordingly.
# It also sets the USER_IS_ACTIVE depending on whether the user is active or not.
# USER_PROCESSING_ALLOWED=false means one of the following:
#  - the user does not exist
#  - the user exists but is a systems user (has UID less than or equal to SYS_UID_MAX)
#  - return 1
# USER_PROCESSING_ALLOWED=true means all of the following:
#  - the user exists
#  - the user is active or inactive
#  - the user has UID above SYS_UID_MAX
#  - return 0
# 
# Usage: check_if_users_home_removal_is_allowed ${USER_TO_PROCCESS}
# 
check_if_user_processing_is_allowed() {
    PREF="${FUNCNAME} >:"
    local STATUS
    local USER_ID
    local SYS_UID_MAX
    log 1 "${FUNCNAME} start."
    if [[ -z "${USER_TO_PROCCESS}" ]]
    then
        log 4 "USER_TO_PROCCESS must not be empty."
        return 1
    fi
    log 1 "Will find user's id."
    USER_ID=$(id -u ${USER_TO_PROCCESS} 2> /dev/null)
    STATUS=$?

    SYS_UID_MAX=$(cat /etc/login.defs | grep SYS_UID_MAX | sed 's/SYS_UID_MAX//' | sed 's/^[[:blank:]]*//')
    log 1 "SYS_UID_MAX is ${SYS_UID_MAX}."
     
    if [[ "${STATUS}" -ne 0 ]]
    then
        USER_PROCESSING_ALLOWED=false
        log 4 "The user '${USER_TO_PROCCESS}' was not found."
        log 2 "USER_PROCESSING_ALLOWED set to ${USER_PROCESSING_ALLOWED}."
        return 1
    elif [[ "${USER_ID}" -le "${SYS_UID_MAX}" ]]
    then
        USER_PROCESSING_ALLOWED=false
        log 4 "The user '${USER_TO_PROCCESS}' is a system user."
        log 2 "USER_PROCESSING_ALLOWED set to ${USER_PROCESSING_ALLOWED}."
        return 1
    else
        log 1 "Calling check_if_user_is_active."
        check_if_user_is_active ${USER_TO_PROCCESS}
        STATUS=$?
        PREF="${FUNCNAME} >:"
        log 1 "Returned from Calling check_if_user_is_active with status ${STATUS}."
        if [[ "${STATUS}" -eq 0 ]]
        then
            USER_IS_ACTIVE='true'
        else
            USER_IS_ACTIVE='false'
        fi
        log 2 "USER_IS_ACTIVE set to ${USER_IS_ACTIVE}."
    fi

    USER_PROCESSING_ALLOWED=true
    log 2 "The user '${USER_TO_PROCCESS}' was found and is allowed to be processed."
    log 2 "USER_PROCESSING_ALLOWED set to ${USER_PROCESSING_ALLOWED}."
    log 1 "${FUNCNAME} end."
    return 0
}

# Creates the ARCHIVE_DIR if it does not exist.
create_archives_dir(){
    PREF="${FUNCNAME} >:"
    log 1 "${FUNCNAME} start."
    if ! [[ -d "${ARCHIVE_DIR}" ]]
    then
        log 2 "${ARCHIVE_DIR} does not exist. Going to create it."
        mkdir -p ${ARCHIVE_DIR}
        if [[ "${?}" -ne 0 ]]
        then
            log 4 "Failed to create the directory '${ARCHIVE_DIR}'."
            return 1
        fi
        log 2 "The directory '${ARCHIVE_DIR}' was created successfully. "
    fi
    log 1 "${FUNCNAME} end."
    return 0
}

# Archives the users directory. Returns 1 if it fails otherwise 0.
archive_users_home(){
    PREF="${FUNCNAME} >:"
    local STATUS
    case ${ARCHIVE_FORMAT} in
        gz)
            ARCHIVE_FILE_FULL_PATH="${ARCHIVE_DIR}/$(basename ${USERS_HOME}.tar.gz)"
            tar -cvzf "${ARCHIVE_FILE_FULL_PATH}" ${USERS_HOME} &>> ${LOG_PATH}
            STATUS=$?
            ;;
        tgz)
            ARCHIVE_FILE_FULL_PATH="${ARCHIVE_DIR}/$(basename ${USERS_HOME}.tar.tgz)"
            tar -cvzf "${ARCHIVE_FILE_FULL_PATH}" ${USERS_HOME} &>> ${LOG_PATH}
            STATUS=$?
            ;;
        bzip2)
            ARCHIVE_FILE_FULL_PATH="${ARCHIVE_DIR}/$(basename ${USERS_HOME}.tar.bzip2)"
            tar -cvjf "${ARCHIVE_FILE_FULL_PATH}" ${USERS_HOME} &>> ${LOG_PATH}
            STATUS=$?
            ;;
        xz)
            ARCHIVE_FILE_FULL_PATH="${ARCHIVE_DIR}/$(basename ${USERS_HOME}.tar.xz)"
            tar -cvJf "${ARCHIVE_FILE_FULL_PATH}" ${USERS_HOME} &>> ${LOG_PATH}
            STATUS=$?
            ;;
    esac

    if [[ "${STATUS}" -ne 0 ]]
    then
        log 4 "Failed to archive '${USERS_HOME}'."
        return 1
    else
        log 2 "'${USERS_HOME}' was archived successfully."
        return 0
    fi
}

# This function is used to infer the PROCESS_MODE. PROCESS_MODE is a number that
# depicts what processes will be carried on user.
# For an ACTIVE user with EXISTING home we can
#     1  disable the user
#     2  disable the user and delete his home
#     3  disable the user and archive/delete his home
#     4  delete the user
#     5  delete the user and delete his home
#     6  delete the user and archive/delete his home
# For an INACTIVE user with EXISTING home we can
#     7  delete his home
#     8  archive/delete his home
#     9  delete the user
#    10  delete the user and delete his home
#    11  delete the user and archive/delete his home
# For an ACTIVE user with NOT EXISTING home we can
#    12  disable the user
#    13  delete the user
# For an INACTIVE user with NOT EXISTING home we can
#    14  delete the user

infer_process_mode(){
    PREF="${FUNCNAME} >:"
    log 1 "${FUNCNAME} start."
    log 1 "MODE = ${MODE}."
    log 1 "USER_IS_ACTIVE = ${USER_IS_ACTIVE}."
    log 1 "REMOVE_HOME = ${REMOVE_HOME}."
    log 1 "HOME_REMOVE_ALLOWED = ${HOME_REMOVE_ALLOWED}."
    log 1 "USERS_HOME_EXISTS = ${USERS_HOME_EXISTS}."
    log 1 "ARCHIVE = ${ARCHIVE}."
    PROCESS_MODE='0'
    # For ACTIVE users with EXISTING home
    if [[ "${MODE}" = 'disable' ]] && [[ "${USER_IS_ACTIVE}" = 'true' ]] && [[ "${REMOVE_HOME}" = 'false' ]]
    then
        PROCESS_MODE='1'
    elif [[ "${MODE}" = 'disable' ]] && [[ "${USER_IS_ACTIVE}" = 'true' ]] && [[ "${REMOVE_HOME}" = 'true' ]] \
        && [[ "${HOME_REMOVE_ALLOWED}" = 'true' ]] && [[ "${USERS_HOME_EXISTS}" = 'true' ]] && [[ "${ARCHIVE}" = 'false' ]]
    then
        PROCESS_MODE='2'
    elif [[ "${MODE}" = 'disable' ]] && [[ "${USER_IS_ACTIVE}" = 'true' ]] && [[ "${REMOVE_HOME}" = 'true' ]] \
        && [[ "${HOME_REMOVE_ALLOWED}" = 'true' ]] && [[ "${USERS_HOME_EXISTS}" = 'true' ]] && [[ "${ARCHIVE}" = 'true' ]]
    then
        PROCESS_MODE='3'
    elif [[ "${MODE}" = 'delete' ]] && [[ "${USER_IS_ACTIVE}" = 'true' ]] && [[ "${REMOVE_HOME}" = 'false' ]] 
    then
        PROCESS_MODE='4'
    elif [[ "${MODE}" = 'delete' ]] && [[ "${USER_IS_ACTIVE}" = 'true' ]] && [[ "${REMOVE_HOME}" = 'true' ]] \
        && [[ "${HOME_REMOVE_ALLOWED}" = 'true' ]] && [[ "${USERS_HOME_EXISTS}" = 'true' ]] && [[ "${ARCHIVE}" = 'false' ]]
    then
        PROCESS_MODE='5'
    elif [[ "${MODE}" = 'delete' ]] && [[ "${USER_IS_ACTIVE}" = 'true' ]] && [[ "${REMOVE_HOME}" = 'true' ]] \
        && [[ "${HOME_REMOVE_ALLOWED}" = 'true' ]] && [[ "${USERS_HOME_EXISTS}" = 'true' ]] && [[ "${ARCHIVE}" = 'true' ]]
    then
        PROCESS_MODE='6' 
    # For INACTIVE users with EXISTING home
    elif [[ "${MODE}" = 'disable' ]] && [[ "${USER_IS_ACTIVE}" = 'false' ]] && [[ "${REMOVE_HOME}" = 'true' ]] \
        && [[ "${HOME_REMOVE_ALLOWED}" = 'true' ]] && [[ "${USERS_HOME_EXISTS}" = 'true' ]] && [[ "${ARCHIVE}" = 'false' ]]
    then
        PROCESS_MODE='7'
    elif [[ "${MODE}" = 'disable' ]] && [[ "${USER_IS_ACTIVE}" = 'false' ]] && [[ "${REMOVE_HOME}" = 'true' ]] \
        && [[ "${HOME_REMOVE_ALLOWED}" = 'true' ]] && [[ "${USERS_HOME_EXISTS}" = 'true' ]] && [[ "${ARCHIVE}" = 'true' ]]
    then
        PROCESS_MODE='8'
    elif [[ "${MODE}" = 'delete' ]] && [[ "${USER_IS_ACTIVE}" = 'false' ]] && [[ "${REMOVE_HOME}" = 'false' ]] 
    then
        PROCESS_MODE='9'
    elif [[ "${MODE}" = 'delete' ]] && [[ "${USER_IS_ACTIVE}" = 'false' ]] && [[ "${REMOVE_HOME}" = 'true' ]] \
        && [[ "${HOME_REMOVE_ALLOWED}" = 'true' ]] && [[ "${USERS_HOME_EXISTS}" = 'true' ]] && [[ "${ARCHIVE}" = 'false' ]]
    then
        PROCESS_MODE='10'
    elif [[ "${MODE}" = 'delete' ]] && [[ "${USER_IS_ACTIVE}" = 'false' ]] && [[ "${REMOVE_HOME}" = 'true' ]] \
        && [[ "${HOME_REMOVE_ALLOWED}" = 'true' ]] && [[ "${USERS_HOME_EXISTS}" = 'true' ]] && [[ "${ARCHIVE}" = 'true' ]]
    then
        PROCESS_MODE='11'
    
    # For ACTIVE users with NOT EXISTING home
    elif [[ "${MODE}" = 'disable' ]] && [[ "${USER_IS_ACTIVE}" = 'true' ]] && [[ "${USERS_HOME_EXISTS}" = 'false' ]]
    then
        PROCESS_MODE='12'
    elif [[ "${MODE}" = 'delete' ]] && [[ "${USER_IS_ACTIVE}" = 'true' ]] && [[ "${USERS_HOME_EXISTS}" = 'false' ]]
    then
        PROCESS_MODE='13'

    # For INACTIVE users with NOT EXISTING home
    elif [[ "${MODE}" = 'delete' ]] && [[ "${USER_IS_ACTIVE}" = 'false' ]] && [[ "${USERS_HOME_EXISTS}" = 'false' ]]
    then
        PROCESS_MODE='14'
    fi
    log 2 "PROCESS_MODE inferred: ${PROCESS_MODE}"
    log 1 "${FUNCNAME} end."
}

# Handles the processing of a user according to the PROCESS_MODE inferred by the infer_process_mode function.
process_user() {
    PREF="${FUNCNAME} >:"
    local STATUS
    log 1 "${FUNCNAME} start."
    log 1 "Calling infer_process_mode."
    infer_process_mode
    PREF="${FUNCNAME} >:"
    log 1 "Returned from infer_process_mode."

    if [[ "${PROCESS_MODE}" -eq 0 ]]
    then
        log 2 "No process is available for the user '${USER_TO_PROCCESS}'. Will continue with the script execution."
        return 1
    fi

    # Archiving has priority
    case "${PROCESS_MODE}" in
        3 | 6 | 8 | 11)
            log 2 "Will archive the home '${USERS_HOME}' of the user '${USER_TO_PROCCESS}'."
            create_archives_dir
            STATUS=$?
            PREF="${FUNCNAME} >:"
            if [[ "${STATUS}" -ne 0 ]]
            then
                log 2 "Exitng the script with error."
                    exit 1
            fi
            archive_users_home
            STATUS=$?
            PREF="${FUNCNAME} >:"
            if [[ "${STATUS}" -ne 0 ]]
            then
                log 2 "No futher processing of the user '${USER_TO_PROCCESS}'. Will continue with the script execution."
                return 1
            fi
            ;;
    esac

    # Cases when deleting only the user's home - the user is not processed - his home may be archived
    case "${PROCESS_MODE}" in
        2 | 3 | 7 | 8)
            log 2 "Will delete the home '${USERS_HOME}' of the user '${USER_TO_PROCCESS}'."
            rm -rf ${USERS_HOME} &>> ${LOG_PATH}
            if [[ -d "${USERS_HOME}" ]]
            then
                log 4 "Failed to delete '${USER_TO_PROCCESS}' user's home directory '${USERS_HOME}'."
                if [[ -f "${ARCHIVE_FILE_FULL_PATH}" ]]
                then
                    log 2 "Will delete the previously created file '${ARCHIVE_FILE_FULL_PATH}'."
                    rm -rf ${ARCHIVE_FILE_FULL_PATH}
                fi
                log 2 "No futher processing of the user '${USER_TO_PROCCESS}'. Will continue with the script execution."
                return 1
            else
                log 2 "'${USER_TO_PROCCESS}' user's home '${USERS_HOME}' was successfully deleted."
            fi
            ;;
    esac
    
    # Cases when disabling the user - his home may be deleted or archived
    case "${PROCESS_MODE}" in
        1 | 2 | 3 | 12)
            log 2 "Will disable the user '${USER_TO_PROCCESS}'."
            chage -E 0 ${USER_TO_PROCCESS} &>> ${LOG_PATH}
            STATUS=$?
            if [[ "${STATUS}" -eq 0 ]]
            then
                log 2 "The user '${USER_TO_PROCCESS}' was disabled."
            else
                log 4 "The user '${USER_TO_PROCCESS}' was not disabled."
                return 1
            fi
            ;;
    esac

    # Cases when deleting only the user
    case "${PROCESS_MODE}" in
        4 | 9 | 13 | 14)
            userdel ${USER_TO_PROCCESS} &>> ${LOG_PATH}
            STATUS=$?
            if [[ "${STATUS}" -ne 0 ]]
            then
                log 4 "Failed to delete '${USER_TO_PROCCESS}'. Will continue the script execution."
                return 1
            else
                log 2 "User '${USER_TO_PROCCESS}' was deleted successfully."
            fi
            ;;
    esac

    # Cases when deleting the user AND his home
    case "${PROCESS_MODE}" in
        5 | 6 | 10 | 11)
            log 2 "Will delete the user '${USER_TO_PROCCESS}' and delete his home '${USERS_HOME}'."
            userdel -r ${USER_TO_PROCCESS} &>> ${LOG_PATH}
            STATUS=$?
            if [[ "${STATUS}" -ne 0 ]]
            then
                log 4 "Failed to delete the '${USER_TO_PROCCESS}' and his home directory '${USERS_HOME}'."
                if [[ -f "${ARCHIVE_FILE_FULL_PATH}" ]]
                then
                    log 2 "Will delete the previously created file '${ARCHIVE_FILE_FULL_PATH}'."
                    rm -rf ${ARCHIVE_FILE_FULL_PATH}
                fi
                return 1
            else
                log 2 "User '${USER_TO_PROCCESS}' and his home directory '${USERS_HOME}' were deleted."
            fi
            ;;
    esac

    log 1 "${FUNCNAME} end."
}


# A wrapper function for the functions:
#   check_if_user_processing_is_allowed
#   check_if_users_home_removal_is_allowed
#   process_user
wrapper_function() {
    PREF="${FUNCNAME} >:"
    log 1 "${FUNCNAME} start."
    if [[ -z "${1}" ]] || [[ "${#}" -ne 1 ]]
    then
        log 4 "${FUNCNAME} function must be called with 1 non empty argument."
        return 1
    fi

    USER_TO_PROCCESS="${1}"
    log 1 "Request to process the user '${USER_TO_PROCCESS}'."
    log 1 "Calling function check_if_user_processing_is_allowed."
    check_if_user_processing_is_allowed
    PREF="${FUNCNAME} >:"
    log 1 "Returned from function check_if_user_processing_is_allowed."
    
    if [[ "${USER_PROCESSING_ALLOWED}" = 'true' ]]
    then
        if [[ "${REMOVE_HOME}" = 'true' ]]
        then
            log 1 "Calling function check_if_users_home_removal_is_allowed."
            check_if_users_home_removal_is_allowed
            PREF="${FUNCNAME} >:"
            log 1 "Returned from function check_if_users_home_removal_is_allowed."
        fi
        log 1 "Calling function process_user."
        process_user
        PREF="${FUNCNAME} >:"
        log 1 "Returned from function process_user."
    fi
    log 1 "${FUNCNAME} end."
}

if [[ "${UID}" -ne 0 ]]
then
    echo
    echo "Run as root or with sudo." 1>&2
    echo -e "Run\nsudo ${0} -h\nto see the usage." 1>&2
    echo
    exit 1
fi

while getopts :draf:v:hi OPTION
do
    case ${OPTION} in
        h)
            usage
            exit 0
            ;;
        i)
            version
            exit 0
            ;;
        d)
            MODE='delete'
            ;;
        r)
            REMOVE_HOME=true
            ;;
        a)
            ARCHIVE=true
            ;;
        f)
            case ${OPTARG} in
                gz | tgz | bzip2 | xz)
                    ARCHIVE_FORMAT=${OPTARG}
                    ;;
                *)
                    echo
                    echo "${OPTARG} is not a valid compression format." 1>&2
                    echo -e "Run\nsudo ${0} -h\nto see the usage." 1>&2
                    echo
                    exit 1
                    ;;
            esac
            ;;
        v)
            case ${OPTARG} in
                1 | 2 | 3 | 4)
                    VERBOSE_LEVEL=${OPTARG}
                    ;;
                *)
                    echo
                    echo "${OPTARG} is not a valid VERBOSE_LEVEL." 1>&2
                    echo -e "Run\nsudo ${0} -h\nto see the usage." 1>&2
                    echo
                    exit 1
                    ;;
            esac
            ;;
        :)
            echo
            echo "Option -${OPTARG} requires an argument." 1>&2
            echo -e "Run\nsudo ${0} -h\nto see the usage." 1>&2
            echo
            exit 1
            ;;
        \?)
            echo
            echo "Invalid option -${OPTARG}" 1>&2
            echo -e "Run\nsudo ${0} -h\nto see the usage." 1>&2
            echo
            exit 1
            ;;

    esac
done

# if archive home mode, then remove home implies
if [[ "${ARCHIVE}" = 'true' ]]
then
    REMOVE_HOME=true
fi

# get the usernames
shift "$((OPTIND - 1))"
USERNAMES="${@}"

if [[ -z "${USERNAMES}" ]]
then
    echo
    echo "Must provide at least one USERNAME." 1>&2
    echo -e "Run\nsudo ${0} -h\nto see the usage." 1>&2
    echo
    exit 1
fi

show_config
for USER in ${USERNAMES}
do
    resore_defaults
    PREF=''
    log 2 "---------------------------------------------------"
    log 2 "***** Starting processing the user '${USER}'. *****"
    wrapper_function "${USER}"
    PREF=''
    log 2 "***** Finished processing the user '${USER}'. *****"
    log 2 "---------------------------------------------------"
done
log 2 "Finished processing of all users."
log 2 "Exiting script."
exit 0
