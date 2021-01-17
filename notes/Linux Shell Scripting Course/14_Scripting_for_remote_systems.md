When we want to execute scripts on remote systems, we must first have ssh keys to connect to these systems without a password.


# Generating ssh keys
## `ssh-keygen` and `ssh-copy-id`
If we want to connect to a server via `ssh` without providing a password then we've got to generate public/private ssh keys. To do this:

### 1. Generate a private/public key
```bash
# run the ssh-keygen command
$ ssh-keygen
# output
Generating public/private rsa key pair.
# we usually accept the default directory
Enter file in which to save the key (/home/vagrant/.ssh/id_rsa):
# we leave the password empty
Enter passphrase (empty for no passphrase):
Enter same passphrase again:
# result
Your identification has been saved in /home/vagrant/.ssh/id_rsa.
Your public key has been saved in /home/vagrant/.ssh/id_rsa.pub.
The key fingerprint is:
SHA256:QgkaAsdXoYr2LNmos4Q8pK71lUz/6P5DIOWWzWOodfg vagrant@admin01
The key''s randomart image is:
+---[RSA 2048]----+
|+.o ..o.         |
| o.o.o ..        |
|  ... oo *       |
| . . .. O *      |
|.o.   o=S= .     |
|* *  o.+  E      |
|oB.+  + ..       |
|=.o. .   o.      |
|=+  .  o+.o.     |
+----[SHA256]-----+
```

### 2. Copy the public key to the other machines
```bash
$ ssh-copy-id server01
/usr/bin/ssh-copy-id: INFO: Source of key(s) to be installed: "/home/vagrant/.ssh/id_rsa.pub"
The authenticity of host 'server01 (10.9.8.11)' can''t be established.
ECDSA key fingerprint is SHA256:Fi4FisVgFyEkos9NgKz0q+zzZwe3+xhCHWGrXL+jZck.
ECDSA key fingerprint is MD5:b6:04:55:d7:db:3c:a8:a1:b6:f6:15:1f:be:7e:48:41.
Are you sure you want to continue connecting (yes/no)? yes
/usr/bin/ssh-copy-id: INFO: attempting to log in with the new key(s), to filter out any that are already installed
/usr/bin/ssh-copy-id: INFO: 1 key(s) remain to be installed -- if you are prompted now it is to install the new keys
vagrant@server01''s password:

Number of key(s) added: 1

Now try logging into the machine, with:   "ssh 'server01'"
and check to make sure that only the key(s) you wanted were added.
```

# Executing commands remotely
Having 'paired' our local and our remote server with the ssh keys, we can execute commands to the remote server like:
```bash
[vagrant@admin01 ~]$ ssh server01 hostname
server01

# Where admin01 is our administration server, and server01 is another remote server.
```
This way we execute the command on the remote server without starting a new interactive shell.

Another example:
```bash
# assuming we have the following file:
$ cat servers
# output
server01
server02


for SERVER in $(cat servers)
do
  ssh ${SERVER} hostname
  ssh ${SERVER} uptime
done

# output
server01
 08:13:45 up 49 min,  0 users,  load average: 0.00, 0.01, 0.05
server02
 08:13:45 up 47 min,  0 users,  load average: 0.00, 0.01, 0.05
```
To execute multiple commands we must enclose the commands in single or double quotes (if we want variable expansion):
```bash
# without variable expansion
ssh server01 'hostname ; uptime'

# with variable expansion
CMD1='hostname'
CMD2='uptime'
ssh server01 "${CMD1} ; ${CMD2}"

# output for both ways
server01
 08:20:02 up 55 min,  0 users,  load average: 0.00, 0.01, 0.05
```
Another example with multiple commands:
```bash
$ ssh server01 'hostname | sed "s/server/remote server/" ; cd ~ ; mkdir files && echo "Hello" >> files/hello.txt && cat files/hello.txt'
# output
remote server01
Hello
```
## Exit statuses
**ssh** exits with the **exit status of the last remote command or with 255** if an error occurred.

This means that if we have a series of commands that all fail except the last one, then we may be mislead and think that all commands were executed successfully. Here's a demonstration:
```bash
$ ssh server01 "true | false"
$ echo $?
1

$ ssh server01 "false | true"
$ echo $?
0

# note: where 'false' and 'true' commands that will fail or success.
```
To overcome this, we need to use `set -o pipefail` which ***sets the return value of a pipeline as the status of the last command to exit with a non-zero status, or zero if no command exited with a non-zero status.***

Here's a demonstration:
```bash
$ ssh server01 "set -o pipefail; false | true"
$ echo $?
1

$ ssh server01 "set -o pipefail; true | false"
$ echo $?
1

$ ssh server01 "set -o pipefail; true | true"
$ echo $?
0
```

## Sudo on remotes
Assuming that we're the user `vagrant` on our local machine and we want to execute a command to the remote machine. Here are some ways that we may do this:
```bash
$ ssh server01 'id'
uid=1000(vagrant) gid=1000(vagrant) groups=1000(vagrant)
# We execute the ssh command as 'vagrant', connect to the remote as 'vagrant' and execute the command as 'vagrant'.

$ ssh server01 'sudo id'
uid=0(root) gid=0(root) groups=0(root)
# We execute the ssh command as 'vagrant', connect to the remote as 'vagrant' and execute the command as 'root'.

$ sudo ssh server01 'id'
root@server01''s password:
uid=0(root) gid=0(root) groups=0(root)
# We execute the ssh command as 'root', connect to the remote as 'root' and execute the command as 'root'.
```
>**Note 1:** When we connect as root, we are asked for the root user's password on the remote machine. If we want to overcome this we must generate ssh keys and place for our local root user and place the public key to the remote machine.
>**Note 2:** Some Linux distributions are configured to not allow root ssh connections. In this case the best is to connect as other user and execute the commands with sudo.

## Timeouts
If we want to specify how long foran ssh command it will take until it times out, we use the `-o ConnectTimeout=[number]` option. Example:
```bash
ssh -o ConnectTimeout=2 server01 'id'
```