# Permissions
## What are the available permissions
|Permission|Symbol|Number|File                         |Directory                                          |
|----------|------|------|-----------------------------|---------------------------------------------------|
|Read      |r     |4     | File content can be read    | File names in the directory can be read           |
|Write     |w     |2     | File content can be modified| Entries within the directory can be modified      |
|Execute   |x     |1     | File can be executed        | Allows access to contents and metadata for entries|

## Combining permissions
A user or group can have multiple permissions. It is as simple as adding the number of the permissions:
```
read                               = 4
read + execute         = 4 + 1     = 5
read + write           = 4 + 2     = 6
read + write + execute = 4 + 2 + 1 = 7
```

## Who can have permission
|Symbol|Category  |
|------|----------|
|u     |owner user|
|g     |group     |
|o     |other     |
|a     |all       |

## Seeing permissions of file
```bash
ls -l file
# output
#
#  owner
#  user  others
#   |     |
#  |-|   |-|
  -rw-r--r--. 1 root    root      0 Jan 23 11:25 file
#     |_|
#      |
#    group
```

## What permissions to give and to whom
### Most common permissions
```bash
-rwx------  700
-rwxr-xr-x  755
-rw-rw-r--  664
-rw-rw----  660
-rw-r--r--  644


# And the ones that someone should avoid
-rwxrwxrwx  777
-rw-rw-rw-  666
```
>**Caution:** The `w` permission should not be given to everyone (`o`). If you want many users to have write permission, add them to a group, and give the group the write permission.

## Changing permissions
There are two common formats:<br>
`chmod [ugoa] +||-||= PERMISSIONS FILE... `<br>
`chmod NUMBER FILE...`

Examples:
```bash
# + : gives a permission
# - : removes a permission
# = : sets permissions to the exact value (removes anything else)

chmod g+rwx file    # gives to the group read/write/execute permission
chmod ugo-x file    # removes the X permission for the owner user, group and others
chmod a+rw  file    # gives all read/write permission
chmod u+rwx,g+rw,o-rwx file     # gives the user rwx permissions, group rw permissions,
                                # removes all permissions for others
chmod a=r file      # sets the read ONLY permission for all - removes wx permissions (if any)
chmod go= file       # if no value specified, removes all permissions


```
```bash
chmod 755 file

# gives:
# read, write, execute permission to the owner
# read, execute permission to the group
# read, execute permission to anyone else
```
## Changing the owner of file/directory
`chown [OPTION...] [OWNER]:[GROUP] FILE/DIRECTORY...`
```bash
chown john file1    # will make john the owner of file1
chown john dir1     # will make john the owner of dir1 (not it's contents)
chown john dir1/*   # will make john the owner of dir1 and it's 1st level contents
chown -R john dir1  # will make john the owner of dir1 and all it's contents
```

## Changing the group of file/directory
When a file is created by default belongs to the primary group of the user. To change the group:<br>
`chgrp [OPTIONS] GROUP FILE/DIRECTORY...`
```bash
chgrp employees dir1        # Will change the group of the dir1
chgrp employees dir1/*      # Will change the group of the 1st level contents of dir1
chgrp -R employees dir1     # Will change the group of the dir1 and all it's contents recursively

```
## Changing the default user's file-creation mask
User file-creation mask: is the permissions that will be given to newly created files/directories by default.

### See the current value
```bash
umask
# output
0002

# or
umask -S
u=rwx,g=rwx,o=rx
```
>**Note:** Notice that the output is 4-digit. This is because the 1st digit refers to the [special modes (setuid, setgid, sticky)](https://www.linuxtopia.org/online_books/introduction_to_linux/linux_Special_modes.html)
### How it works
The value of `umask` is subtracted from the values `666` for files and `777` for directories. The result number is the default permissions.

So, for the above output:
```bash
# For files
666 - 002 = 664
-rw-rw-r--

# For directories
777 - 002 = 775
drwxrwxr-x
```
### Change the value
```bash
umask 077   # will filter rwx from the group and others

# Will result in
# For files
666 - 077 = 600
-rw-------

# For directories
777 - 077 = 700
drwx------
```

### Common values
```
002
022
007
077
```
