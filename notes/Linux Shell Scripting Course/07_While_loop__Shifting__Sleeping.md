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