# Finding files and directories
## The `find` command
Recursively finds files in path that match expression. If no args are supplied it finds all files.

`find [options] [path...] [expression]`<br>

The `expression` has options, tests, and actions.<br>
Some `expression tests:`
- numeric arguments:
    - `+n`: greater than
    - `-n`: less than
    - `+n`: exactly
- `-name PATTERN`: Find files and directories that match the pattern
- `-iname PATTERN`: Like `-name` but case insensitive.
- `-mtime DAYS`: Files that las modified DAYS ago
- `-size NUM`: Files that are of size NUM
- `-newer FILE`: Files that are newer that the file
- `-gid GID`: Files belonging to a GID
- `-group NAME`: Files belonging to a group
- `-empty`: Files or directories that are empty
- `-type c`: Files that are of type c (d - directory, f - regular file, l - symbolic link, etc)
- `-uid N`: File belongs to a user with UID=N
- `-uid LOGIN`: File belongs to a user

Some `expression actions`:
- `-delete`: Delete files
- `-exec COMMAND {} \;`: Execute the command (up to `;`) once for each found file. The string `{}` is replaced by the current file name being processed.
- `-ls`: Performs an `ls` on each found item.

Examples:
```bash
find . -iname 'file*' -group employees -empty -type f -exec cp {} {}_new \;
# Will start searching from the current directory
# and find files stating with the name 'file' (case insensitive)
# that belong to the group 'employees'
# that are empty regular files.
# Any file found will be copied with the name to be like 'filename_new'
```
```bash
find . -iname 'file*' -newer /home/vagrant/file -size -1M -mtime -10 -mtime +5
# Will start searching from the current directory
# and find files stating with the name 'file' (case insensitive)
# and are newer than the 'file'
# with size less than 1 Megabytes
# and with modification time less than 10 days and greater than 5
```
## The `locate` command
Lists files that match a pattern.
- Faster than the `find`
- Queries an index
- Results are not in real time
- May not be enabled on all systems
Example:
```bash
locate file
```