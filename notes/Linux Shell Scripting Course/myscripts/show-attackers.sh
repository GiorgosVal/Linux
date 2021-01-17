#!/bin/bash
FILE="${1}"
LIMIT='10'
FOUND=0
SEP=","
OUTPUT_FILE="attackers.csv"

if ! [[ -f "${FILE}" ]]
then
    echo "Please provide a file"
    exit 1
fi

grep "Failed" ${FILE} | awk -F 'from' '{print $2}' | awk '{print $1}' | sort | uniq -c | sort -nr | \
    while read COUNT IP
    do
        if [[ "${COUNT}" -gt "${LIMIT}" ]]
        then
            FOUND=$(( FOUND + 1 ))
            LOCATION=$(geoiplookup ${IP} | awk -F ', ' '{print $2}')
            
            if [[ "${FOUND}" -eq 1 ]]
            then
                echo "Count${SEP}IP${SEP}Location" > ${OUTPUT_FILE}
            fi
            echo "${COUNT}${SEP}${IP}${SEP}${LOCATION}" >> ${OUTPUT_FILE}
        fi
    done


