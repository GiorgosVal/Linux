#!/bin/bash

# This script takes two integers X, Y as input and calculates their sum (X+Y), difference (X-Y), product (X*)
# and quotient (X/Y).
# -100 <= X,Y <= 100
# Y != 0

INT_MIN='-100'
INT_MAX='100'

# This function checks if a given string is integer
# Usage: is_integer STRING
is_integer() {
  local STRING=${1}
  if ! [[ "${STRING}" =~ ^[+-]?[0-9]+$ ]]
  then
    echo "${STRING} is not an integer" >&2
    return 1
  fi
}

# This function checks if a number is within a given range
# Usage: is_in_range NUMBER
is_in_range() {
  local NUMBER=${1}
  if [[ "${NUMBER}" -lt "${INT_MIN}" ]] || [[ "${NUMBER}" -gt "${INT_MAX}" ]]
  then
    echo "${NUMBER} is not within range" >&2
    return 1
  fi
}

# This function checks if a number is not equal to number(s) passed as list of constraints.
# Usage: is_not_number NUMBER [CONSTRAINT]..
is_not_number() {
  local NUMBER="${1}"
  shift

  while [[ "${#}" -ne 0 ]]
  do
    local CONSTRAINT="${1}"
    if [[ "${NUMBER}" -eq "${CONSTRAINT}" ]]
    then
      echo "${NUMBER} must not be equal to ${CONSTRAINT}." >&2
      return 1
    fi
    shift
  done
}

# This is a wrapper function that controls the validity checks that need to be done.
# You may call this function as
#    validate_number NUM OPTSTRING [NUMBER]...
#       NUM:         The number you want to check
#       OPTSTRING:   The options 'irn'. Each letter is a symbol to the check you want.
#                    'i' is for is_integer, 'r' is for is_in_range, 'n' is for is_not_number
#       [NUMBER]..:  Numbers you want to be the constraints of the is_not_number check.
#
# Examples:
#    validate_number 25 i
#    validate_number 25 irn
#
validate_number() {
  local NUM=${1}
#  echo "NUM ${NUM}"
  shift
  local OPTSTRING=${1}
#  echo "OPTSTRING ${OPTSTRING}"
  shift
#  echo "CONSTRAINTS ${@}"
  case "${OPTSTRING}" in
    i*)
      is_integer ${NUM}
      if [[ "${?}" -eq 1 ]]
      then
        return 1
      fi
      ;;&
    *r*)
      is_in_range ${NUM}
      if [[ "${?}" -eq 1 ]]
      then
        return 1
      fi
      ;;&
    *n)
      is_not_number ${NUM} ${@}
      if [[ "${?}" -eq 1 ]]
      then
        return 1
      fi
      ;;
  esac
}

read X
read Y

validate_number ${X} "ir"
if [[ "${?}" -ne 0 ]]
then
  exit 1
fi

validate_number ${Y} "irn" 0
if [[ "${?}" -ne 0 ]]
then
  exit 1
fi

echo "$((X+Y))"
echo "$((X-Y))"
echo "$((X*Y))"
echo "$((X/Y))"

exit 0