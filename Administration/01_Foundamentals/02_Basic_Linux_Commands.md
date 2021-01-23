# Basic Linux Commands
## `cat`
Concatenates and displays files

## `cd`
Changes the current directory
```bash
cd /path
cd -        # return to previous directory
cd ..       # go one directory up (parent dir)
cd ../..    # go two directories up
cd ~        # go to home
cd          # go to home
```

## `clear`
Clears the screen

## `echo`
Displays arguments to the screen

## `exit`
Exits the shell or the current session

## `ls`
Lists directory contents
```bash
ls      # lists directory contens
ls -l   # lists in long format
ls -a   # include hidden files (starting with .)
ls -h   # human readable format for sizes
ls -F   # reveal file types (/ - directory, @ - Link, * - executable)
ls -t   # List files by time
ls -r   # reverse order
ls -R   # Lists subdirectories recursively
ls -d   # list directories only
ls --color  # colorize output

# permissions  links   user          group       size  | date last |  filename
#    |         |        |             |            |   |  modified |   |
-rw-r--r--     1    gvalamatsas  gvalamatsas     123K  23 Jan 12:50  file1*
#                                                                         |
#                                                                      executable
```

## `man`
Displays the online manual

## `mkdir`
Creates a directory
```bash
mkdir dir1  # creates the dir dir1
mkdir -p dir1/dir2/dir3  # creates the dir3 - if dir1/dir2 not exist, creates them

```
## `pwd`
Displays the present working directory

## `rm`
Removes files or directories
```bash
rm file1 file2     # removes the file1 file2
rm -rf directory    # removes a directory (r) and it's contents without confirmation (f)
```

## `rmdir`
Removes an **empty** directory
```bash
rmdir dir1                # removes dir1 if it's empty
rmdir -p dir1/dir2/dir3   # removes dir3 and it's parents - if empty
```
## `tree`
Similar to `ls -R` but creates a visual output
```bash
tree -d     # list directories only
tree -C     # colorize output
```