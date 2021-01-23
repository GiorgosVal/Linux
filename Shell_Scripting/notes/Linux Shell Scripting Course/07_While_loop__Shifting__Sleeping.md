### While loop
Execute commands as long as a test succeeds.

`while COMMANDS; do COMMANDS; done`

Examples:

### Looping through the positional parameters
```bash
# Supposing user enter arguments: John Mary Luke

echo "${1}"     # 'John'
echo "${2}"     # 'Mary'
echo "${3}"     # 'Luke'
echo

while [[ "${#}" -ne 0 ]]
do
                #  1st     2nd      3r
    echo "${1}" # 'John'  'Mary'  'Luke'
    echo "${2}" # 'Mary'  'Luke'  empty
    echo "${3}" # 'Luke'  empty   empy
    shift
done
echo
echo "${1}"     # empty
echo "${2}"     # empty
echo "${3}"     # empty
```

### Looping through command output
```bash
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

# In the above example, the command:
# grep "Failed" ${FILE} | awk -F 'from' '{print $2}' | awk '{print $1}' | sort | uniq -c | sort -nr
# produced the below output
   6749 182.100.67.59
   3379 183.3.202.111
   3085 218.25.208.92
    142 41.223.57.47
     87 195.154.49.74
     57 180.128.252.1
     27 208.109.54.40
     20 159.122.220.20
      4 8.19.245.2
      1 185.110.132.54
      1 119.15.137.149
# So to loop in this output we pipe the 'while' command and make user of the 'read' command to initialize each word of the line to a variable.
```