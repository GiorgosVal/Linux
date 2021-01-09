#!/bin/bash

#if [[ "${1}" = "start" ]]
#then
#	echo "Starting."
#elif [[ "${1}" = "stop" ]]
#then
#	echo "Stoping."
#elif [[ "${1}" = "status" ]]
#then
#	echo "Status:"
#else
#	echo "nothing."

case "${1}" in
	one)
		echo "one"
		;;
	one*)
		echo "one and something"
		;;
	two)
		echo -n "two "
		;&
	three)
		echo  "three"
		;;
	four)
		echo -n "four "
		;;&
	five)
		echo "five"
		;;
	four*)
		echo "four"
		;;
	*)
		echo "Invalid" >&2
		exit 1
		;;
esac

