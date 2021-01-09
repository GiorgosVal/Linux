## Useful links
[What are stdin, stderr and stdout in Bash](https://linuxhint.com/bash_stdin_stder_stdout/)

## Bash default standard IO
The default streams that bash creates are:
- Standard Input (STDIN)
    - It takes text as input
    - file descriptor 0
    - usually comes from the **keyboard** but can also come from **pipes** that generate an output which in turn it is used as input, or **files**
- Standard Output (STDOUT)
    - Where the text output of a command is stored
    - file descriptor 1
- Standard Error (STDERR)
    - Where an error message of a command is stored
    - file descriptor 2

Where **file descriptors** can be thought as pointers to sources of data, or places that data can be written.

## Read from keyboard
The `read` command reads from the keyboard and stores the input in the `$REPLY` variable. We can define different variables. Examples:
```bash
$ read
something
$ echo $REPLY
something

$ read
something else
$ echo $REPLY
something else

$ read USERNAME
guest
$ echo $USERNAME    # $REPLY will be empty
guest

$ read USERNAME PASSWORD
guest 1234
$ echo $USERNAME
guest
$ echo $PASSWORD
1234

$ read USERNAME PASSWORD
guest
$ echo $USERNAME
guest
$ echo $PASSWORD #empty


$ read USERNAME PASSWORD
guest 1234 something
$ echo $USERNAME
guest
$ echo $PASSWORD
1234 something
```
We can also add a prompt:
```bash
$ read -p "Enter your username: " USERNAME
```
And we can also hide the text enter by the user:
```bash
$ read -s -p "Enter your password: " -s PASS
```

## Redirecting STDOUT
Redirecting is done with the symbols `>` (replace - same as `1>`) or `>>` (append - same as `1>>`). We can redirect to:
- a file (as long we have permission)
- `/dev/null`

Examples
```bash
# Here is the normal output of the head command
$ head -n1 /etc/passwd
root:x:0:0:root:/root:/bin/bash

# Redirecting to the file temp.txt
# If the file doesn't exist it is created.
# If the file exists, all it's contents are replaced.
$ head -n1 /etc/passwd > temp.txt
$ head -n1 /etc/passwd 1> temp.txt  # same

# Redirecting to the file temp.txt
# If the file doesn't exist it is created.
# If the file exists, the output is appended to the file's content.
$ head -n1 /etc/passwd >> temp.txt
$ head -n1 /etc/passwd 1>> temp.txt # same
```

## Redirecting STDERR
Redirecting is done with the symbols `2>` (replace) or `2>>` (append). We can redirect to:
- a file (as long we have permission)
- `/dev/null`

Examples
```bash
# Here is the normal output of the head command
$ head -n1 /etc/fakefile
head: cannot open ‘/etc/fakefile’ for reading: No such file or directory

# Redirecting to the file error.log
# If the file doesn't exist it is created.
# If the file exists, all it's contents are replaced.
$ head -n1 /etc/fakefile 2> error.log

# Redirecting to the file error.log
# If the file doesn't exist it is created.
# If the file exists, the output is appended to the file's content.
$ head -n1 /etc/fakefile 2>> error.log
```

## Redirecting STDIN
Redirecting is done either through piping commands or with the symbol `<` (same as `0<`).

```bash
# we create a temp.txt file
$ echo "myusername" > temp.txt

# we use the temp.txt file as input for the read command
$ read LINE < temp.txt
$ read LINE 0< temp.txt # same
$ echo $LINE
myusername
```

Another example:
```bash
# normal execution, without input redirection
$ sudo passwd guest
Changing password for user guest.
New password:

# input redirection through pipe
echo "1234" | sudo passwd --stdin guest

# input redirection with file
sudo passwd --stdin guest < temp.txt
```

## Redirecting Combinations
```bash
# Redirecting STDOUT and STDERR in different files
$ head -n1 /etc/passwd /fakefile >> head.out 2>> head.err

# Redirecting STDOUT and STDERR in same file - OLD SYNTAX
# Here >> head.both means that STDOUT is redirected to head.both
# The 2>&1 means that the STDERR (2) is redirected to the STDOUT (1)
# Since STDERR is redirected to STDIN, and STDIN is redirected to head.both, then the STDERR is redirected to the head.both too.
$ head -n1 /etc/passwd /fakefile >> head.both 2>&1
# reverse - here we redirect the STDOUT to STDERR
$ head -n1 /etc/passwd /fakefile 2>> head.both 1>&2

# Redirecting STDOUT and STDERR in same file - NEW SYNTAX
$ head -n1 /etc/passwd /fakefile &>> head.both

# Redirecting STDIN, STDOUT and STDERR at the same time
$ sudo passwd --stdin guest < temp.txt &>> head.both
```
```bash
# output of the head command - 3 lines, 2 line STDOUT, 1 line STDERR
$ head -n1 /etc/passwd /fakefile
==> /etc/passwd <==
root:x:0:0:root:/root:/bin/bash
head: cannot open ‘/fakefile’ for reading: No such file or directory

# redirecting the STDOUT to STDIN through pipe
# the 1st line is the STDERR which was not redirected
# the lines 2,3 are the STDOUT which was redirected to the STDIN of the cat command
$ head -n1 /etc/passwd /fakefile | cat -n
head: cannot open ‘/fakefile’ for reading: No such file or directory
     1	==> /etc/passwd <==
     2	root:x:0:0:root:/root:/bin/bash

# redirecting STDERR to STDOUT, and STDOUT and to STDIN through pipe
# the lines 1,2 are the STDOUT
# the line 3 is the STDERR which was redirected to STDOUT
# the final STDOUT was redirected to STDIN through the pipe
$ head -n1 /etc/passwd /fakefile 2>&1 | cat -n
     1	==> /etc/passwd <==
     2	root:x:0:0:root:/root:/bin/bash
     3	head: cannot open ‘/fakefile’ for reading: No such file or directory

# same resule as before, but easier SYNTAX
$ head -n1 /etc/passwd /fakefile |& cat -n
     1	==> /etc/passwd <==
     2	root:x:0:0:root:/root:/bin/bash
     3	head: cannot open ‘/fakefile’ for reading: No such file or directory
```
```bash
# Here the STDOUT was redirected to STDERR
# Thus the cat command didn't had an input
$ echo "hello" >&2 | cat -n
hello
```

## Other uses
### Creating our own error messages in a script
Usually in our script we'll have error messages. These messages can be redirected to STDERR:
```bash
echo "This is an error message." >&2
```
So, we can execute out script as: `./script.sh 2> head.err`

### The null device - discarding STDOUT, STDERR
If we don't want to show output on the screen, and also not to redirect them in a file, we can use the `/dev/null` to just throw them away. Examples:
```bash
$ head -n1 /etc/passwd /fakefile > /dev/null        # STDOUT
$ head -n1 /etc/passwd /fakefile 2> /dev/null       # STDERR
$ head -n1 /etc/passwd /fakefile > /dev/null 2>&1   # both
$ head -n1 /etc/passwd /fakefile &> /dev/null       # both
```
**Use case:** When in our script we execute commands and we don't want to show any output generated by these commands. We can always use the `${?}` to check the exit status of the commands.