# Viewing files
## The `cat` command
Display the contents of file

## The `more` command
Browse through a file
```bash
more file
```

## The `less` command
Like `more` but with more features.
```bash
less file
```

## The `head` command
Outputs the beginning (top) portion of file.

## The `tail` command
Outputs the ending (bottom) portion of file.
```bash
tail file       # display the last 10 lines (default)
tail -15 file   # display the last 15 lines (default)
tail -f file    # follow the file (display data live)
```

>**Note:** `more` and `less` navigation is similar to the `man`