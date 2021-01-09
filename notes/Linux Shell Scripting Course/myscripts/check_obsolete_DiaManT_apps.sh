#!/bin/bash
# This script checks for obsolete apps that are deployed in DiaManT(s).
# To achieve this, the script first retrieves the unique app names in both DiaManT's /apps directory.
# It then makes a query to the database that both DiaManT's use and exports the most recent timestamp of the application.
# If the application has not been used for over a configurable amount of days (default 90), it logs a message in a log file.


# Environment specific variables
DIAMANT1_HOME="/omilia/apps/DiaManT/"
DIAMANT2_HOME="/omilia/apps/DiaManT2/"
DIAMANT_APPS="${DIAMANT1_HOME}apps/ ${DIAMANT2_HOME}apps/"
HUBOT_HOME="/omilia/apps/hubot/"
DB_USER='diamant'
DB_NAME='diamant'
DB_PASS='diamant'
NOW=$(date +%s)

# Variables that affect script logic
DAYS_TO_CONSIDER_OBSOLETE=90
LOG_FILE_PATH="/root/$(basename ${0} .sh)-$(date +%F-%H_%M_%S).log"

# Other variables
LINE="----------------------------------------"
GLOBAL_MB_COUNTER=0

# Functions

# Displays the usage message.
usage() {
  echo
  echo "USAGE: ${0} [-d DAYS] [-h]"
  echo
  echo "DESCRIPTION: Search in DiaManT's database for obsolete apps."
  echo
  echo "OPTIONS"
  echo "    -d DAYS   Specify the days to consider an app obsolete (default 90)."
  echo "              Must be 0 or positive integer."
  echo "    -h        Display usage."
  echo
  echo "Examples"
  echo "    ${0}"
  echo "    ${0} -d 120"
}

# Logs in the specified logs file
log(){
 echo "${@}" >> ${LOG_FILE_PATH}
}

# Validates the days the user provided as input.
validate_days() {
  local NUMBER=${1}
  
  # Check that days provided is inrteger
  if ! [[ "${NUMBER}" =~ ^[+-]?[0-9]+$ ]]
  then
    echo "${NUMBER} is not an integer" >&2
    return 1
  fi

  if [[ "${NUMBER}" -lt 0 ]]
  then
    echo "${NUMBER} is not positive." >&2
    return 1
  fi
}

# Accepts a file size in the form '123M	total' and ads it to the total GLOBAL_MB_COUNTER.
add_to_total(){
  # retrieves the number
  local digits=$(echo "${1}" | sed 's/^[[:blank:]]*//' | sed 's/total//g' \
        | sed 's/G//g'| sed 's/K//g' | sed 's/M//g')
  # retrieved the unit of the number (K, B, G)
  local unit=$(echo "${1}" | sed 's/^[[:blank:]]*//' | sed 's/total//g' \
        | sed 's/^[[:digit:]]*//' | sed 's/^[[:punct:]]*//' | sed 's/^[[:digit:]]*//')

  case "${unit}" in
     K)
       digits=$((digits/1000))
       ;;
     M)
       ;;
     G)
       digits=$((digits*1000))
       ;;
     *)
       ;;
  esac
  GLOBAL_MB_COUNTER=$(awk "BEGIN {print ${GLOBAL_MB_COUNTER}+${digits}; exit}")
}

# Queries the database to find obsolete apps.
check_apps(){
  echo "This will take a while..."
  # Find the unique application names for both DiaManT's so as to query only once the database for each app
  local APPS=$(find ${DIAMANT_APPS} -maxdepth 1 -exec basename {} \; | sort | uniq)
  local APPS_NUMER=$(find ${DIAMANT_APPS} -maxdepth 1 -exec basename {} \; | sort | uniq | wc -l)
  
  # Some counters
  local OBSOLETE_APPS_FOUND=0
  local APPS_CHECKED=0
  
  # for each up we query the db, check if it's obsolete, find it's disk usage and report it
  for APP_NAME in ${APPS}
  do
    # query the db
    local APP_MOST_RECENT_TIMESTAMP=$(mysql -u ${DB_USER} -p${DB_PASS} ${DB_NAME} \
         -e "select DIALOG_DATE from DIALOGS where APP_NAME='${APP_NAME}' order by DIALOG_DATE DESC LIMIT 1;" 2> /dev/null | grep 202*)
    
    # transform the timestamp to epoch
    local PAST=$(date +%s --date "${APP_MOST_RECENT_TIMESTAMP}")
    local DAYS_PASSED=$(((NOW-PAST)/(3600*24)))
    
    # check if it is obsolete
    if [[ "${DAYS_PASSED}" -gt "${DAYS_TO_CONSIDER_OBSOLETE}" ]]
    then
      # report
      log "${LINE}"
      log "Application:           ${APP_NAME}"
      log "Hasn't been used for:  ${DAYS_PASSED} days."
     
      # find disk usage and report also
      log "Disk usage:"
      log 
      log "$(du -csh ${DIAMANT1_HOME}apps/${APP_NAME}/ ${DIAMANT2_HOME}apps/${APP_NAME}/ \
         ${HUBOT_HOME}rootFolderFileContent/appConfigs/*/${APP_NAME}.zip 2> /dev/null)"
      log "${LINE}"
      add_to_total "$(du -csh ${DIAMANT1_HOME}apps/${APP_NAME}/ ${DIAMANT2_HOME}apps/${APP_NAME}/ \
         ${HUBOT_HOME}rootFolderFileContent/appConfigs/*/${APP_NAME}.zip 2> /dev/null | grep total)"     
      OBSOLETE_APPS_FOUND=$((OBSOLETE_APPS_FOUND+1))
    fi
    
    # display progress
    APPS_CHECKED=$((APPS_CHECKED+1))
    echo -ne "    Progress:     [$(((APPS_CHECKED*100)/APPS_NUMER))%]\r"
  done
  
  # display result
  echo
  echo "${LINE}"
  echo "Found ${OBSOLETE_APPS_FOUND} obsolete applications."

  if [[ "${OBSOLETE_APPS_FOUND}" -gt 0 ]]
  then
    echo "Deleting them will free up ${GLOBAL_MB_COUNTER}MB in your machine."
    echo "Check ${LOG_FILE_PATH} for details".
    log "${LINE}"
    log "CHECK SUMMARY"
    log "    Configuration:"
    log "        Days:          ${DAYS_TO_CONSIDER_OBSOLETE}"
    log "    Result:"
    log "        Obsolete apps: ${OBSOLETE_APPS_FOUND}"
    log "        Disk usage:    ${GLOBAL_MB_COUNTER}MB"
    log "${LINE}"
  fi
  echo "${LINE}"
}

# Parse options
if [[ "${#}" -gt 0 ]]
then
  while getopts d:h OPTION
  do
    case ${OPTION} in
       d)
         INPUT=${OPTARG}
         validate_days ${INPUT}
         if [[ "$?" -eq 1 ]]
         then
            usage
         else
           DAYS_TO_CONSIDER_OBSOLETE=${OPTARG}
           echo
	   echo "Changed default configuration for days to ${DAYS_TO_CONSIDER_OBSOLETE}."
           echo "Started checking."
         check_apps
         fi
         ;;
       h)
         usage
         ;;
       *)
        echo
        echo "No valid option provided, starting with default configuration".
        check_apps
         ;;
    esac
  done
else
  echo
  echo "Started with default configuration."
  check_apps
fi
