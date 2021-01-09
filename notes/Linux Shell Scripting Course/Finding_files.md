## Useful links
- [Linux File System Hierarchy](https://www.geeksforgeeks.org/linux-file-hierarchy-structure/)

## type

## which

## find
Search for files in a directory hierarchy. Examples:

`sudo find / -iname '*userdel*' | sort`<br>
or<br>
`find / -iname '*userdel*' 2> /dev/null | sort`


## locate & updatedb
`locate` reads one or more databases prepared by `updatedb` and writes file names matching at least one of the PATTERNs to standard output, one per line.

`updatedb` creates or updates a database used by locate. It is usually run by `cron` but we can enforce an update by just doing `sudo updatedb`.

Use cases:
- When we just search for a file
- When we search for an executable and the `which <command>` and `type -a <command>` commands return ***not found*** but we're not sure if the executable indeed does not exist, or wether it exists but it's not in our `PATH`.

Example:
```bash
# type command can't find the userdel command
[vagrant@localusers vagrant]$ type -a userdel
-bash: type: userdel: not found

# which command reports that there's no userdel command in out PATH
[vagrant@localusers vagrant]$ which userdel
/usr/bin/which: no userdel in (/usr/local/bin:/usr/bin:/usr/local/sbin:/usr/sbin:/sbin:/usr/sbin:/home/vagrant/bin)

# locate command finds the userdel
[vagrant@localusers vagrant]$ locate userdel
/usr/sbin/luserdel
/usr/sbin/userdel
/usr/share/bash-completion/completions/userdel
/usr/share/man/de/man8/userdel.8.gz
/usr/share/man/fr/man8/userdel.8.gz
/usr/share/man/it/man8/userdel.8.gz
/usr/share/man/ja/man8/userdel.8.gz
/usr/share/man/man1/luserdel.1.gz
/usr/share/man/man8/userdel.8.gz
/usr/share/man/pl/man8/userdel.8.gz
/usr/share/man/ru/man8/userdel.8.gz
/usr/share/man/sv/man8/userdel.8.gz
/usr/share/man/tr/man8/userdel.8.gz
/usr/share/man/zh_CN/man8/userdel.8.gz
/usr/share/man/zh_TW/man8/userdel.8.gz

# Indeed, it exists but the user doesn't have read permission:
[vagrant@localusers vagrant]$ ls -lsa /usr/sbin/userdel
80 -rwxr-x---. 1 root root 80360 Nov  5  2016 /usr/sbin/userdel
```

>**Note**: In the above example, the output of `locate userdel` will be the same as executing `sudo find / -iname '*userdel*' | sort` or `find / -iname '*userdel*' 2> /dev/null | sort`

## What if nothing works?
If none of the above commands returns results, or if e.g. the `locate` command is not installed, then we must do manual search in the Files System. This is why we need to have knowledge on the [Linux File System Hierarchy](https://www.geeksforgeeks.org/linux-file-hierarchy-structure/).