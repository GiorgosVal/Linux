## Functions
- Always declare the functions at the top of the script
- Inside a function use `return [n]` instead of `exit [n]`.

## Always backup files
Always create a backup of a file before editing. Backup files should be kept in `/var/tmp/` directory which guarantees that the files will survive a reboot. Note that `/tmp/` directory does not guarantee that.

An example simple implementation:
```bash
backup_file() {
    local FILE="${1}"

    # Make sure the file exists
    if [[ -f "${FILE}" ]]
    then
        local BACKUP_FILE="/var/tmp/$(basename ${FILE}).$(date+%F-%N)"
        log "Backing up ${FILE} to ${BACKUP_FILE}."

        # Copy the file and preserve mode,ownership,timestamps
        # The exit status of the function will be the exit status of the cp command.
        cp -p ${FILE} ${BACKUP_FILE}
    else
        # The file does not exist, so return a non-zero exit status.
        return 1
    fi
}
```
Another way would be to create three functions:
- a perform_backup() function
- a check_backup() function
- a backup_file() function - wrapper function that calls the other two functions


## Add a progress bar
```bash
# APPS_NUMER and APPS_CHECKED are normally set by a procedure
APPS_NUMER=30
APPS_CHECKED=$((APPS_CHECKED+1))

# Here is what will generate something like a progress bar
echo -ne "    Progress:     [$(((APPS_CHECKED*100)/APPS_NUMER))%]\r"
```