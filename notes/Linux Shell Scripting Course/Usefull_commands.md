## About shell's builtin and non-builtin commands
If you want to find out if a command is a shell builtin command
(e.g. the `echo` command) you can do:
```console
type echo

# Output
echo is a shell builtin

type -a echo

# Output
echo is a shell builtin
echo is /bin/echo


type uptime

# Output - not a builtin command
uptime is /usr/bin/uptime

```

All commands can be executed by their command name, or the full path:
```console
echo 'Hello'

# same as
/bin/echo 'Hello'
```
----

## Shell builtin commands
### type
Display information about command type.
```console
type echo

# Output
echo is a shell builtin

type -a echo

# Output
echo is a shell builtin
echo is /bin/echo


type uptime

# Output - not a builtin command
uptime is /usr/bin/uptime
```

### help
Display information about **builtin** commands.
```console
help <command>

# e.g.
help echo
```

### .
Execute commands from a file in the current shell.
Example: `. my-script.sh`

Same as `source`, similar to `sh`.

### source
Execute commands from a file in the current shell.
Example: `source my-script.sh`

Same as `.`, similar to `sh` and `bash`.

### echo
Write arguments to the standard output.

### test
Evaluate conditional expression. Generates no output. Exits with a status of 0 (true) or 1 (false) depending on the evaluation of the expression.

### [
Evaluate conditional expression. Synonym for the `test` builtin, but the last argument must be a literal `]`, to match the opening `[`.

### exit
Exits the shell with a status of N.  If N is omitted, the exit status is that of the last command executed.

### return

### read
 Read a line from the standard input and split it into fields.

### hash
Remember or display program locations. To refresh the table `hash -r`

### for
Execute commands for each member in a list.

`for NAME [in WORDS ... ] ; do COMMANDS; done`

If `[in WORDS ... ]` not specified, `in "$@"` is assumed.

### while
Execute commands as long as a test succeeds.

`while COMMANDS; do COMMANDS; done`

### case
Execute commands based on pattern matching.

`case WORD in [PATTERN [| PATTERN]...) COMMANDS ;;]... esac`

Selectively execute COMMANDS based upon WORD matching PATTERN.  The `|` is used to separate multiple patterns.

### true
returns true (status code 0)

### false
returns false (status code 1)


### shift
Shifts positional parameters by N: `shift [n]`

### getopts
Getopts is used by shell procedures to parse positional parameters as options.




----

## Not builtin commands
### man
Man  is the system's manual pager. Each page argument given to man is normally the name of a program, utility or function.
```console
man <command>

# e.g.
man echo
man uptime
man bash
```

### info
Read info documents of commands. Similar to `man` command. Example:
```console
info echo
```

### bash
Execute commands from a file in the current shell.
Example: `bash my-script.sh`

Same as `sh`, similar to `.` and `source`.

### sh
Execute commands from a file in the current shell.
Example: `sh my-script.sh`

Same as `bash`, similar to `.` and `source`.

### id
Print  user  and group information for the specified USER, or (when USER omitted) for the current
       user.
```bash
id
# example output
uid=1000(vagrant) gid=1000(vagrant) groups=1000(vagrant)

id -u       # -u: user, g: group, G: all groups
# example output
1000

id -u -n    # -n: print only the name
id -n -u
id -nu
id -un
# example output
vagrant
```
### whoami
Print the user name associated with the current effective user ID.  Same as `id -un`.

### useradd
create a new user or update default new user information

### userdel

### passwd
The passwd utility is used to update user's authentication token(s).

### date
Display the current time in the given FORMAT, or set the system date.

### head
Print  the first 10 lines of each FILE to standard output.  With more than one FILE, precede each with a header giving the file name.  With no FILE, or when FILE is -, read standard input.

Examples:
```bash
head -n1 /etc/passwd          # outputs only the 1st line
head --lines=-5 /etc/passwd   # outputs all the file except the last 5 lines
head -c10 /etc/passwd         # outputs the first 10 characters

date +%s%N | sha256sum | head -c8 # outputs only the first 8 characters of the generated checksum
```

### fold
Wrap input lines in each FILE (standard input by default), writing to standard output. Example:
```bash
S='!@#$%^&*()-_+='
echo ${S} | fold -w1 # Will echo every character in a separate line
```

### shuf
Write a random permutation of the input lines to standard output. Example:
```bash
shuf /etc/passwd # will echo the passwd file lines, but every time with random permutation

S='!@#$%^&*()-_+='
echo ${S} | fold -w1 | shuf # Will echo every character in a separate line, and every time with random permutation
```

### which
Which takes one or more arguments. For each of its arguments it prints to stdout the full path of the executables that would have been executed when this argument had been entered at the shell prompt. It does this by searching for an executable or script in the directories listed in the environment variable PATH using the same algorithm as bash(1).

### basename
Strips directory and suffix from filenames - opposite of `dirname`.
```bash
basename /usr/bin/sort
    -> "sort"

basename include/stdio.h .h   # remove trailing .h suffix
    -> "stdio"

basename -s .h include/stdio.h  # remove trailing .h suffix
    -> "stdio"

basename -a any/str1 any/str2   # multiple arguments
    -> "str1" followed by "str2"
```
### dirname
Strips last component from file name - opposite of `basename`.
```bash
dirname /usr/bin/
    -> "/usr"

dirname dir1/str dir2/str
    -> "dir1" followed by "dir2"

dirname stdio.h
    -> "."
```

### sleep
Delay for a specified amount of time

`sleep NUMBER[SUFFIX]...`

NUMBER: int or float
SUFFIX: `s`, `m`, `h`, `d` (seconds-default, minutes, hours, days)
```bash
sleep 4         # sleep 4 seconds
sleep 0.1m      # sleep 6 seconds
sleep 4s 0.1m   # sleep 10 seconds
sleep 0.1m 4s   # sleep 10 seconds
```

### logger
logger makes entries in the system log.  It provides a shell command interface to the syslog(3) system log module. The logs we sent are available to `/var/log/messages`. Examples:
```bash
logger "Hello from the command line"

# Will write to the logs something like:
Dec 27 06:11:42 localusers guest: Hello from the command line
# Where 'localusers` is the hostname and 'guest' the user
```

```bash
logger -t my-script "Hello from the command line"

# Will write to the logs something like:
Dec 27 06:16:22 localusers my-script: Hello from the command line
```

```bash
log () {
    local MESSAGE="${@}"
    TAG="$(basename ${0}) > ${FUNCNAME}"
    logger -t ${TAG} "${MESSAGE}"
}

log "Hello"

# Will write to the logs something like:
Dec 27 06:43:35 localusers luser-demo09.sh: > log Hello
```

### locate and updatedb

### find



---

## Useful Shell variables
### RANDOM

### HOSTNAME

### UID

### USER

### PATH
The  search  path  for commands. A common value is `/usr/gnu/bin:/usr/local/bin:/usr/ucb:/bin:/usr/bin`.

---
## Shortcuts

### `!!`
Execute the previous command. Add `sudo` to execute with root.