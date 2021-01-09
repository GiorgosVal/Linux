#!/bin/bash

echo "${1}"
echo "${2}"
echo "${3}"
echo

while [[ "${#}" -ne 0 ]]
do
	echo "${1}"
	echo "${2}"
	echo "${3}"
	echo
	shift
done
echo

echo "${1}"
echo "${2}"
echo "${3}"
