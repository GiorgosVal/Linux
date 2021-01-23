## The `wc` command
Counts the lines, the words (sequence of characters separated by space), the characters, the bytes, the max line length of a file.

Options:
- `-c`: show only the bytes
- `-m`: show only the characters
- `-w`: show only the words
- `-l`: show only the lines
- `-L`: show the max length of lines

Examples:
```bash
$ wc /etc/passwd
# output
  29   46 1395 /etc/passwd

# 29 lines
# 46 words
# 1395 characters

$ wc -l /etc/passwd
# output
29 /etc/passwd

$ grep bash /etc/passwd | wc -l
# output
7
```

>**Note:** Depending on the situation, counting can be done also with other commands, such:
>- `grep -c`
>- `uniq -c`


