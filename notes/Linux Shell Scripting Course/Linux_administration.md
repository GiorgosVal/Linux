## Change permissions
Read:	 4<br>
Write:	 2<br>
Execute: 1<br>

```console
chmod 755 <filename>

# gives:
# read, write, execute permission to the owner
# read, execute permission to the group
# read, execute permission to anyone else
```

## sudo
`sudo` let's us execute commands as the root user, without having to switch user. Examples:
```bash
[guest@localhost]$ ./myscript.sh   # will be executed by the guest user

[guest@localhost]$ sudo ./myscript.sh   # will be executed by the guest user, as root

[guest@localhost]$ su   # switch to root user
Password:
[root@localhost]$ ./myscript.sh   # will be executed by the root user

```

## Switching users
```bash
[guest@localhost]$ su           # Switch to root - Asks for password
[guest@localhost]$ sudo su      # Switch to root - No password

[guest@localhost]$ su guest2    # Switch to guest2 - Asks for password
[guest@localhost]$ sudo su guest2 # Switch to guest2 - No password

```
## Adding users
Username conventions:
- prefer usernames up to 8 characters long
- usernames are case-sensitive
- usernames can have special characters

Some options:
- `-c`: Write a comment (usually used to write the full name of the user)
- `-m`: Force the creation of the user's home directory

Example:
```bash
useradd -c "${COMMENT}" -m ${USER_NAME}
```

>Note: Enclosing the `${COMMENT}` in quotes, ensures that the variable value is treated as one piece. So, in case the variable contains spaces, it won't break anything.

## Changing password of users
Needs root privileges.

Setting the password examples:
```bash
passwd <username>
# Will open an interactive dialog for changing the password of the
# specified user.
```

```bash
echo ${PASSWORD} | passwd --stdin ${USER_NAME}
# This way we skip the interactive dialog. The new password is read from standard input, which is a pipe.
```
A quick way to expire a password for an account. The user will be forced to change the password during the next login attempt.
```bash
passwd -e ${USER_NAME}
```

## Locking Users
### With `chage` - best way
```bash
# Lock the user
chage -E 0 ${USER_NAME}

# Unlock the user
chage -E -1 ${USER_NAME}
```

### With `passwd`
```bash
# Lock the user
passwd -l ${USER_NAME}

# Unlock the user
passwd -u ${USER_NAME}
```
>**Note:** The account is not fully locked - the user can still log in by other means of authentication such as the ssh public key authentication.

### With `usermod` and `/sbin/nologin`
Setting the user's shell to nologin will not let the user login.
```bash
# To lock
usermod -s /sbin/nologin ${USER_NAME}

# To unlock
usermod -s /bin/bash ${USER_NAME}
```
>**Note 1:** In this way the root will not be able to login to the account either. 
>**Note 2:** There are actions that don't require an interactive login, or a shell, such as port fordwarding.


## Deleting Users
Without any option we delete the user, but keep his `/home/` directory (so as for us to have access). Example:
```bash
# This is our user
[vagrant@localusers vagrant]$ tail -1 /etc/passwd
johnsnow:x:1016:1017:John Snow:/home/johnsnow:/bin/bash

# And his /home
drwx------  2   johnsnow    johnsnow 4096 Jan  1 12:56 johnsnow

# We delete the user
sudo userdel johnsnow

# His home still exists
drwx------  2   1016    1017 4096 Jan  1 12:56 johnsnow
```

With the `-r` option, files in the user's home directory will be removed along with the home directory itself and the user's mail spool. Files located in other file systems will have to be searched for and deleted manually. Example:
```bash
# This is our user
[vagrant@localusers vagrant]$ tail -1 /etc/passwd
johnsnow:x:1016:1017:John Snow:/home/johnsnow:/bin/bash

# And this is the /home
drwx------  2 johnsnow  johnsnow 4096 Jan  1 12:56 johnsnow
drwx------. 3 vagrant   vagrant  4096 Jan  1 14:43 vagrant

# We delete the user
sudo userdel -r johnsnow

# His home gone
drwx------. 3 vagrant   vagrant  4096 Jan  1 14:43 vagrant
```
>**CAUTION:** Before deleting any user, always check that this user is not a system user (e.g. sshd). Do this by comparing that his id is greater than the `SYS_UID_MAX` value configured in the `/etc/login.defs`. For example:
>```bash
>USER_TO_DEL='mario'
>if [[ "$(id -u ${USER_TO_DEL})" -gt 999 ]]
>then
>  sudo userdel -r ${USER_TO_DEL}
>fi
>```
><br>

## See the status of a User
```bash
$ chage -l root
Last password change					            : never
Password expires					                : never
Password inactive					                : never
Account expires						                : never
Minimum number of days between password change		: 0
Maximum number of days between password change		: 99999
Number of days of warning before password expires	: 7
```

## Searching Users
### The `UID` variable
Holds the current users id.

### The `id` command
Using the `id -u <LOGIN>` command we can see the id of any user:
```bash
$ id -u root
0

$ id -u sshd
74

# With the `-n` option instead of id numbers we print names:
$ id -un root
root

# If we don't specify a LOGIN then it defaults to the current user:
$ id -u
1000

# If we don't give anything it defaults to the current user and shows all info
$ id
uid=1000(vagrant) gid=1000(vagrant) groups=1000(vagrant)
```

### Finding the `/home` of users with the `getent` command
```bash
getent passwd root  # with username
getent passwd 0     # with user id
# outputs
root:x:0:0:root:/root:/bin/bash

getent passwd root | cut -d: -f6  # with username
getent passwd 0 | cut -d: -f6     # with user id
# outputs the home
/root

# generic form
getent passwd ${USER} | cut -d: -f6
getent passwd ${UID} | cut -d: -f6
```


System accounts have lower id numbers as configured in the `/etc/login.defs`

## The `/etc/login.defs` file
It is the configuration file were some options about the login are defined, like:
- **PASS_MAX_DAYS:** Maximum number of days a password may be used.
- **PASS_MIN_DAYS:** Minimum number of days allowed between password changes.
- **PASS_MIN_LEN:** Minimum acceptable password length.
- **PASS_WARN_AGE:** Number of days warning given before a password expires.
- **UID_MIN:** Min value for automatic uid selection in useradd
- **UID_MAX:** Max value for automatic uid selection in useradd
- **SYS_UID_MIN:** Min value for system uid
- **SYS_UID_MAX:** Max value for system uid
- **GID_MIN:** Min value for automatic gid selection in useradd
- **GID_MAX:** Max value for automatic gid selection in useradd
- **SYS_GID_MIN:** Min value for system gid
- **SYS_GID_MAX:** Max value for system gid
- **CREATE_HOME:** If useradd should create home directories for users by default
- and more...