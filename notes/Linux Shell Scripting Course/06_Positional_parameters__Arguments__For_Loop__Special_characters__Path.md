## Positional parameters vs Arguments
>`man bash` search for Positional Parameters

**Positional parameters** are variables that are used in a shell script and hold the context of the command line. 

**Arguments** are the data passed inside a shell script. So an argument supplied on the command line becomes the value stored in a parameter.

Parameters can be referenced inside a script like:
```bash
${0}  # Holds the name of the script
${1}  # Holds the value of the 1st argument
${2}  # Holds the value of the 2nd argument
...
${n}

# Where n positive integer
```

The parameter `${0}` is a *special parameter* and is practically what the user typed to execute the script (without any further arguments). For example:
```bash
# my-script.sh
echo "You executed the script: ${0}"
```
```bash
$ ./my-script.sh
You executed the script: ./my-script.sh

$ /home/user/my-script.sh
You executed the script: /home/user/my-script.sh

# If the script is in the PATH
$ my-script.sh
You executed the script: /usr/local/bin/my-script.sh
```

## Special Parameters
>`man bash` search for Special Parameters

The  shell treats several parameters specially.  These parameters may only be referenced; assignment to them is not allowed. These are:
`*, @, #, ?, -, $, !, 0, _`

Some info:
- `#`: number of arguments passed
- `0`: the name of the script
- `?`: the exit status of the last executed command
- `@`: **list** of all positional parameters, starting from 1
- `*`: **string** of all positional parameters, starting from 1


## Playing with the PATH
PATH variable holds all the paths that the bash will look for executables, for example:
`/usr/local/bin:/usr/bin:/usr/local/sbin:/usr/sbin:/sbin:/usr/sbin:/home/vagrant/bin`

The first found, is executed.

### Changing the default executables
Doing `which head` shows which executable will be executed:
`/usr/bin/head`.

This means that we can write our own `head` script and place it in the `/usr/local/bin`, so it will become the default executable.

If we did this, then the only way to execute the original `head` script is to provide the full path, which can be found by:
```bash
$ type -a head
head is /usr/local/bin/head     # our head script
head is /usr/bin/head           # original head script
```

#### Restoring the defaults
Restoring the default scripts is a two-step procedure:
- remove our script: `sudo rm /usr/local/bin/head`
- make Bash to forget all remembered locations: `hash -r`

>Note:
>Bash uses a hash table to store the paths of executables. If we don't refresh this table by making Bash to forget all remembered locations, then will notice:
>```console
>$ which head
>/usr/bin/head
>
>$ type head
>head is hashed (/usr/local/bin/head)
>
>$ type -a head
>head is /usr/bin/head
>
>$ head
>-bash: /usr/local/bin/head: No such file or directory
>```
><br>

### Adding our scripts to the PATH
Similarly as before, but this time we don't want to change a default script, but to add our own script in the PATH.
```bash
# determine that the script is not in the PATH
$ which my-script.sh

/usr/bin/which: no my-script.sh in (/usr/local/bin:/usr/bin:/usr/local/sbin:/usr/sbin:/sbin:/usr/sbin:/home/vagrant/bin)

# add our script in the PATH
$ sudo cp my-script.sh /usr/local/bin/
$ which my-script.sh
/usr/local/bin/my-script.sh
```


## For Loop
Useful links:
- [Bash For Loop Examples](https://www.cyberciti.biz/faq/bash-for-loop/)

Usage:

`for NAME [in WORDS ... ] ; do COMMANDS; done`

If `[in WORDS ... ]` not specified, `in "$@"` is assumed.

Examples:
```bash
for PARAM   # in "$@" is assumed
do
    echo "You gave the parameter: ${PARAM}"
done

# same as
for PARAM  in "${@}"
do
    echo "You gave the parameter: ${PARAM}"
done

# CAUTION: Not same as
# This will expand in "$1" "$2" ...
# So if $1="Tom", $2="Jane Doe", then we'll have
# PARAMETERS="Tom Jane Doe"
# And the for loop will execute 3 times instead of 2.
PARAMETERS="${@}"
for PARAM in ${PARAMETERS}
do
    echo "You gave the parameter: ${PARAM}"
done
```
And an indexed loop:
```bash
COUNT=2
for  (( i=1; i <= "${COUNT}"; i++ ))
do
    echo "${i} times"
done
```