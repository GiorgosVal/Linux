# Users and Groups
## Intro
### Rules of thumb
- Every user has:
    - a username (referred also as login)
    - a user ID (UID), which is a unique number
    - a default group
    - comments
        - typically the user's full name
        - in case of system or app account, it often contains what the account is used for
        - may contain additional info like phone number
    - a shell
        - it will be executed when the user log in
        - list of available shells in `/etc/shells`
        - use `/usr/sbin/nologin` or `/bin/false` to prevent interactive use of an account
        - can be command line applications
    - a home directory
- A user can belong in many groups

### The `/etc/passwd` file
Contains all the info of a user in the form:
`username:password:UID:GID:comments:home_dir:shell`<br>
Example
```
$ ls -l /etc/passwd
-rw-r--r--. 1 root root 1186 Apr 30  2020 /etc/passwd

$ tail -1 /etc/passwd
vagrant:x:1000:1000:vagrant:/home/vagrant:/bin/bash
```
>**Note:** The `x` in the password means that the password is stored encrypted in the `/etc/shadow` file

### The `/etc/shadow` file
Contains the encrypted passwords of the users in the form of<br>
`field_1:field_2:field_3:field_4:field_5:field_6:field_7:field_8:field_9`<br>
Where:
- `field_1`: username
- `field_2`: encrypted password
- `field_3`: days since 1/1/1970 since the password last changed
- `field_4`: days before the password can be changed
- `field_5`: days after which the password must be changed. 99999 means that the user never has to change his password
- `field_6`: days to warn the user that his password will expire
- `field_7`: days after the password has expired after which the account is disabled
- `field_8`: days since 1/1/1970 that an account has been disabled
- `field_9`: reserved for future use

Example:
```
$ ls -l /etc/shadow
----------. 1 root root 663 Apr 30  2020 /etc/shadow

$ sudo tail -1 /etc/shadow
vagrant:$1$gPNBpA.5$5pr.KtXhOx6S/Hc69TUZZ.::0:99999:7:::
```

### The `/etc/group` file
Contains all the info about the groups in the form of:<br>
`group_name:password:GID:account1,accountN`<br>
Example:
```bash
employees:x:1001:vagrant,johndoe
```
>**Note:** The `x` in the password means that the password is stored encrypted in the `/etc/gshadow` file

---

## Managing users
### Selecting a username
Here's what to think about when choosing username:
- up to 8 characters long
- use lowercase
- do not use numbers & special characters

>**Note:** Linux support usernames up to **32 characters long**. Also support **uppercase letters, numbers and special characters**. Though, these capabilities are not preferred as in many situations can be proved a problem.
>
> For example, if a user had username `mysuperlongusername` and we'd run the command `ps -fu mysuperlongusername` we would see in the output:
>```bash
> UID       PID   PPID  C STIME TTY  TIME     CMD
> mysuper+  2156  2153  0 11:19 ?    00:00:01 sshd: vagrant@pts
>```

### Adding a user
`useradd [OPTIONS] LOGIN`<br>
Some options:
- `-c COMMENT`: comments of the account
- `-m`: Force the creation of the user's home directory, and copy the contents of `/etc/skel` inside the home directory (.bash_logout, .bash_profile, .bashrc, etc)
- `-s PATH`: The path to the user's shell
- `-g GROUP`: Define the default group of user
- `-G GROUP1,GROUP2,...`: Define additional groups
- `-r`: Create a system account (takes UID in the range of `SYS_UID_MIN`-`SYS_UID_MAX` defined in `/etc/login.defs`)
- `-d`: Define the home directory
- `-u UID`: Define the UID of user

Examples:
```bash
# The user will have the default 'johndoe' home directory, and belong to the default 'johndoe' group
useradd -c "John Doe" -m johndoe -s /bin/bash

# The user will have the 'sales' group as default and also belong to the group 'projectx'
useradd -c "John Doe" -m johndoe -g sales -G projectx -s /bin/bash

# The user will be a system user, with specified home, no shell
# The -m option was not used
useradd -c "Apache Web Server" -d /opt/apache -r -s /usr/sbin/nologin apache
```

### Giving a user a password
`passwd LOGIN`<br>
Example:
```bash
passwd johndoe
# Will open an interactive dialog for changing the password of the specified user.
```

### Deleting users
`userdel [OPTIONS] LOGIN`<br>
Some options:
- `-r`: Remove the user's home directory, and mail spoof file if exists.
Examples:
```bash
userdel johndoe     # Will delete the user
userdel -r johndoe  # Will delete the user AND hos home & mail spoof
```
>**CAUTION:** Before deleting any user, always check his `UID` to find out if this user is a system user (e.g. sshd). If the user is a system user proceed with caution. Find info in `/etc/login.defs` (`SYS_UID_MIN`, `SYS_UID_MAX` variables).
### Modify users
`usermod [OPTIONS] LOGIN`<br>
Some options:
- `-c COMMENT`: Edit the comments
- `-g GROUP`: Specify the default group
- `-G GROUP1,GROUP2,...`: Additional groups
- `-s PATH`: Edit shell path

### Locking Users
#### With `chage` - best way
```bash
# Lock the user
chage -E 0 johndoe

# Unlock the user
chage -E -1 johndoe
```

#### With `passwd`
```bash
# Lock the user
passwd -l johndoe

# Unlock the user
passwd -u johndoe
```
>**Note:** The account is not fully locked - the user can still log in by other means of authentication such as the ssh public key authentication.

#### With `usermod` and `/sbin/nologin`
Setting the user's shell to nologin will not let the user login.
```bash
# To lock
usermod -s /sbin/nologin johndoe

# To unlock
usermod -s /bin/bash johndoe
```
>**Note 1:** In this way the root will not be able to login to the account either. 
>**Note 2:** There are actions that don't require an interactive login, or a shell, such as port fordwarding.


### Find info about users (apart from `/etc/passwd`).
#### See the status of a User
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
#### The `id` command
Using the `id -u <LOGIN>` command we can see the id of any user:
```bash
$ id -u johndoe    # see the UID of user
1002

$ id -un johndoe   # see the name of user instead UID
root

$ id -Gn johndoe   # see the groups of the USER
johndoe employees

$ id johndoe       # see the full id of user
uid=1002(johndoe) gid=1003(johndoe) groups=1003(johndoe),1001(employees)

$ id -u            # see the UID of the current user
1000

$ id                # see the full id of the current user
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

### Find the groups a user belongs
```bash
# With the id command
$ id -Gn johndoe
johndoe employees

# With the groups command
$ groups johndoe
johndoe : johndoe employees
```

System accounts have lower id numbers as configured in the `/etc/login.defs`


---

## Managing groups
### Create a group
`groupadd [OPTIONS] GROUP`<br>
Some options:
- `-g GID`: Define the GID
```bash
groupadd sales              # create the group sales
groupadd -g 2500 sales      # create the group sales with GID=2500
```

### Delete a group
`groupdel GROUP`
```bash
groupdel sales              # delete the group sales
```

### Modify a group
`groupmod [OPTIONS] GROUP`<br>
Some options:
- `-g GID`: Set a new GID
- `-n NEW_NAME`: Rename the group
```bash
groupmod -g 1500 sales      # change the GID of sales to 1500
groupmod -n salesnew sales  # change the name of sales to salesnew
```


---
## How users can use other users and groups
### Switching users

### Switching groups
Here are the groups that the user `vagrant` belongs to:
```bash
[root@localhost ~]$ id -Gn vagrant
vagrant employees
```
```bash
# We switch to vagrant user and create a file
[root@localhost ~]$ su vagrant
[vagrant@localhost ~]$ touch file
# The file was created for the vagrant group
[vagrant@localhost ~]$ ls -l
0 -rw-rw-r--. 1 vagrant vagrant    0 Jan 23 15:37 file

# We switch to the employees group and create a file
[vagrant@localhost ~]$ newgrp employees
[vagrant@localhost ~]$ touch file2

# The new file was created for the employees group
[vagrant@localhost ~]$ ls -l
0 -rw-rw-r--. 1 vagrant vagrant    0 Jan 23 15:37 file
0 -rw-r--r--. 1 vagrant employees  0 Jan 23 15:37 file2
```