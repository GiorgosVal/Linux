# Getting Help in the command line

## `man COMMAND`
See the manual page of the command. Once you enter use:
- `Enter` key: Moves down one line
- `Space` key: Moves down one page.
- `g`: Moves to the top of page
- `G`: Moves to the bottom of the page
- `q`: Quit
- `/pattern`: Search for a pattern
- `n`: Move to the next result of search (to the bottom)
- `N`: Move to the next result of search (to the top)

### Find manual pages
`man -k SEARCH-TERM`<br>
For example:
```
man -k copy

# result
asr(8)                   - Apple Software Restore; copy volumes (e.g. from disk images)
copy(9), copyin(9), copyinstr(9), copyout(9), copystr(9) - kernel copy functions
copyops(n), transfer::copy(n) - Data transfer foundation
cp(1)                    - copy files
cpio(1)                  - copy files to and from archives
dd(1)                    - convert and copy a file
ditto(1)                 - copy directory hierarchies, create and extract archives
fcopy(ntcl)              - Copy data from one channel to another
pax(1)                   - read and write file archives and copy directory hierarchies
pbcopy(1), pbpaste(1)    - provide copying and pasting to the pasteboard (the Clipboard) from command line
scp(1)                   - secure copy (remote file copy program)
ssh-copy-id(1)           - use locally available keys to authorise logins on a remote machine
text(ntcl), tk_textCopy(ntcl), tk_textCut(ntcl), tk_textPaste(ntcl) - Create and manipulate text widgets
tqueue(n), transfer::copy::queue(n) - Queued transfers
uucp(1)                  - Unix to Unix copy

```
## `type -a COMMAND`
Shows the paths of the COMMAND

## `which COMMAND`
Shows which command will be executed if invoked.

## `COMMAND --help` or `COMMAND -h`
Many commands offer this option.

## `help COMMAND`
For built-in shell commands

## `info COMMAND`
Extensive information about a command