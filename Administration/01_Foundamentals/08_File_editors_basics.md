# File editors basics
## The `nano` editor
Is the easier to use, but not as powerful as others. Usage:<br>
`nano filename`

Once it is open, all commands are shown at the bottom, like `^G` (Get Help), `^X` (Exit), etc, where `^` is the `CTRL` key.

## The `vi` and `vim` editors
Has advanced and powerful features, it's harder to learn though. `Vim` is same as `Vi` but has even more features. Usage: <br>
- `vi [file]` : Start editing a file
- `vim [file]` : Start editing a file
- `view [file]`: Start vim in read-only mode
- `vimtutor`: Start the vimtutor - an program that gets installed when installing `vim` and helps you lean the `vim` editor.

It has the concept of modes:
- In COMMAND mode (enter with `ESC`)
    - navigating
        - arrow keys
        - `k`: up one line
        - `j`: down one line
        - `h`: left one character
        - `l`: right one character
        - `w`: right one word
        - `b`: left one word
        - `^`: go to the beginning of the line
        - `$`: go to the end of the line
    - deleting
        - `x`: delete a character
        - `dw`: delete a word
        - `dd`: delete a line
        - `D` : delete from the current position to the end of the line
    - replacing
        - `r`: replace the current character
        - `cw`: change the current word
        - `cc`: change the current line
        - `c$`: change the text from the current position
        - `C`: same as `c$`
        - `~`: reverses the case of a character
    - copying
        - `yy`: copy (yank) the current line
        - `y<position>`: yank the position. Examples
            - `yw`: will yank from the current position up to 1 word right
            - `yb`: will yank from the current position up to 1 word left
            - `yk`: will yank from the current position up to 1 line up
            - similarly with all navigation characters
        - `p`: paste the most recent deleted or yanked text
    - repeat commands like:
        - `5k`: move up a line 5 times
        - `80i<Text><ESC>`: Insert `<Text>` 80 times
        - `80i_<ESC>`: Insert `_` 80 times
    - undo / redo:
        - `u`: undo
        - `CTRL + R`: redo
    - search
        - `/<pattern>`: start a forward search
        - `?<pattern>`: start a reverse search
        - `n`: go to the next match
        - `N`: go to the previous match
- In INSERT mode (enter with `iIaA`)
    - `i`: insert at the cursor position
    - `I`: insert at the beginning of the line
    - `a`: append after the cursor position
    - `A`: append at the end of the line
- In LINE mode (enter with `ESC` and then `:`)
    - `:w`: writes the file
    - `:w!`: forces the file to be saved
    - `:q`: quit
    - `:q!`: force quit without saving changes
    - `:wq`: write and quit
    - `:wq!`: force write and quit
    - `:x`: same as `:wq`
    - `:n`: position the cursor at the line n
    - `:$`: position the cursor at the last line
    - `:set nu`: turn on line numbering
    - `:set nonu`: turn off line numbering
    - `help [subcommand]`: Get help



## Graphical editors
### The `emacs` editor
Emacs has graphical mode too

### The `gedit` editor
The default text editor for Gnome

### The `gvim` editor
The graphical version of vim

### The `kedit` editor
The default text editor for the KDE

### AbiWord
MS Word alternative

### LibreOffice
Full office suite

### Kate
Source code editor