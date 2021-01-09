#!/bin/bash

# This scrip generates a password
# User can set a password length with -l
# User can add a special character with -s
# User can turn on verbose mode with -v

# Set a default password length.
LENGTH=48

usage() {
  echo "Usage: ${0} [-vs] [-l LENTH]" >&2
  echo "Generate a random password." >&2
  echo "  -l LENGTH  Specify the password length." >&2
  echo "  -s         Append a special character." >&2
  echo "  -v         Increase verbosity." >&2
  exit 1
}

log() {
  local MESSAGE="${@}"
  if [[ "${VERBOSE}" = true ]]
  then
    echo "${MESSAGE}"
  fi
}

while getopts vl:s OPTION
do
    case ${OPTION} in
	v)
	  VERBOSE='true'
	  log 'Verbose mode on.'
	  ;;
	l)
          LENGTH=${OPTARG}
          log "Length ${LENGTH}."
          ;;
        s)
          USE_SPECIAL_CHARACTER='true'
          log 'Will use special character.'
          ;;
        *)
          log 'Invalid option.' >&2
          usage
          exit 1
          ;;
    esac
done

# Remove the options while leaving remaining arguments.
shift "$((OPTIND - 1))"

if [[ "${#}" -gt 0 ]]
then
  log 'Not valid arguments: ' "${@}" >&2
  usage
fi

log 'Generaring a password.'
PASSWORD=$(date +%s%N${RANDOM}${RANDOM} | sha256sum | head -c${LENGTH})

# Append a special character if requested to do so.
if [[ "${USE_SPECIAL_CHARACTER}" = 'true' ]]
then
  log 'Selecting a random special character.'
  SPECIAL_CHARACTER=$(echo '!@#$%^&*()_-+=' | fold -w1 | shuf | head -c1)
  PASSWORD="${PASSWORD}${SPECIAL_CHARACTER}"
fi

log 'Done.'
log 'Here is the password.'
echo "${PASSWORD}"
exit 0
