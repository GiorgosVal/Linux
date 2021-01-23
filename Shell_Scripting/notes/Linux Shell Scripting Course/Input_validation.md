## Useful links
- [Regex to validate Linux users](https://unix.stackexchange.com/questions/157426/what-is-the-regex-to-validate-linux-users)
- [About POSIX notation](https://unix.stackexchange.com/questions/530350/what-is-the-meaning-of-space-in-bash)

```bash
# if is empty
if [[ -z "${USER_NAME}"  ]]

# if is not empty
if [[ -n "${USER_NAME}"  ]]

# if length less that 4 or 8
if [[ "${#USER_NAME}" -lt 4 ]] || [[ "${#USER_NAME}" -gt 8 ]]

# if not alphanumeric
if ! [[ "${USER_NAME}" =~ [[:alnum:]] ]]

# if has spaces or tabs
if ! [[ "${USER_NAME}" =~ [[:alnum:]] ]]

# if has punctuation or symbols
if [[ "${USER_NAME}" =~ [[:punct:]] ]]


```

Validate integer
```bash
# Checks if a number is integer
if ! [[ "${NUMBER}" =~ ^[+-]?[0-9]+$ ]]
  then
    echo "${NUMBER} is not an integer" >&2
    return 1
  fi
```