# Linux Directory Structure

- `/` : Root, the top of FSH
- `/bin`: Essential user binaries (programs) that must be present when the system is mounted in single-user mode.
- `/boot`: Files needed to boot the operating system
- `/cdrom`: Mounting point for CD-ROMs, not part of the FSH standard (standard location is `/media`)
- `/cgroup`: Control Groups hierarchy
- `/dev`: Device files, typically controlled by the operating system and the system administrations. Devices can be physical (e.g `/dev/sda` for the first SATA hard drive of the system) or pseudo-devices (e.g. `/dev/random` produces random numbers, `/dev/null` produces no output, etc)
- `/etc`: System configuration files
- `/export`: Shared file systems
- `/home`: Home directories of users
- `/lib`: System libraries
- `/lib64`: System libraries, 64-bit
- `/lost+found`: Used by the file system to store recovered files after a file system check has been performed, for example after a file system crash
- `/media` : Mount point for removable media like CD-ROMs.
- `/mnt`: Used to mount external file systems (e.g. mounting a Windows partition like `/mnt/windows` to perform some file recovery operations)
- `/opt`: Optional 3rd party software (commonly used by 3rd party software that doesn’t obey the standard FSH). 
- `/proc`: Contains special files that represent system and processes information
- `/root`: The home directory of the root account
- `/run`: A new directory that gives applications a standard place to store transient files they require (e.g. sockets and process IDs). These files can’t be stored in /tmp because files in /tmp may be deleted.
- `/sbin`: Essential system administration binaries
- `/selinux`: Used to display information about [SELinux](https://www.redhat.com/en/topics/linux/what-is-selinux). Similar to `/proc`, but for SELinux.
- `/srv`: Data for services provided by the system. For example, the files of a website served by an Apache HTTP server. Examples, `srv/www` for web server files, `/srv/ftp` for FTP files.
- `/tmp`: Temporary space, typically cleared on reboot.
- `/sys`: Used to display and sometimes configure the devices known to the Linux kernel.
- `/usr`: Contains applications and files used by users (e.g. firefox). Non-essential apps are stored in the `/usr/bin`. Non-essential system administration binaries are stored in `/usr/sbin`. Libraries for each are located inside `/usr/lib`. Architecture-independent files like graphics are located in `/usr/share`. `/usr/local` contains locally compiled applications install to by default – this prevents them from mucking up the rest of the system.
- `/var`: Variable data, most probably logs

## Some example structures
```
# An app that's installed in /usr/local
/usr/local/crashplan/bin
/usr/local/crashplan/etc
/usr/local/crashplan/lib
/usr/local/crashplan/log

# An app that's installed in /opt
/opt/avg/bin
/opt/avg/etc
/opt/avg/lib
/opt/avg/log

# An app that's installed in different places
/etc/opt/myapp
/opt/myapp/bin
/opt/myapp/lib
/val/opt/myapp

# An app that uses a shared directory
/usr/local/bin/myapp
/usr/local/etc/myapp.conf
/usr/local/lib/libmyapp.so
```