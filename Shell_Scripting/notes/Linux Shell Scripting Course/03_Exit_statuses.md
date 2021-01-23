## What are exit statuses
A script or a command may be executed successfully or unsuccessfully. By convention, when a program exits successfully it returns an exit status of 0. If it exits unsuccessfully it returns an exit status of not 0.

For example, some of the exit statuses of the `useradd` command are:
- 0: success
- 1: can't update password file
- 9: username already in use

So depending on the exit status of the command, we know if something went wrong.

## The special variable `?`
`?` is a special variable that holds the exit status of the last executed command. We can refer to it in tests:
```bash
USER_NAME=$(id -un)

if [[ "${?}" -ne 0 ]]
then
    echo 'The id command did not execute successfully.'
    exit 1
fi
echo "Your username is ${USER_NAME}"
```