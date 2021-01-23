# Save file, Exit
## Save (write) file
1. Press `Esc` to exit any mode you are and enter `NORMAL` mode.
2. Type `:w` and press `Enter` to save the file.

## Exit (quit) editing
1. Press `Esc` to exit any mode you are and enter `NORMAL` mode.
2. Type `:q` and press `Enter` to quit editing and exit vim.

## Force quit
1. Press `Esc` to exit any mode you are and enter `NORMAL` mode.
2. Type `:q!` and press `Enter` to quit editing and exit vim.

# Search in a file
1. Press `Esc` to exit any mode you are and enter `NORMAL` mode.
2. Type `/`, type the text you want to search and press `Enter`.
3. Navigate from top to bottom with `N` or from bottom to top with `Shift + N`.

# Editing a file
## Insert text
1. Press `Esc` to exit any mode you are and enter `NORMAL` mode.
2. Press `i` to enter `INSERT` mode, and start writing.
3. When you're done, press `Esc` to exit `INSERT` mode.

## Copy and Paste
### one line of code
1. Place the cursor on the line you want to copy
2. Press `yy` to copy it.
3. Using the arrow keys, go to the line you want. The line copied will be inserted above or bellow that line.
4. Press `p` to add the copied line bellow that line, or `P` to add it above that line. Keep pressing as many times you want.

### a block of code
1. Place the cursor on the first `#` and press `Shift + V`. This will enter the editor in `VISUAL LINE` mode.
2. Using the up/down arrow keys select the lines you want.
3. Press `y` and this will copy (yarn) all the lines selected. The editor will return to `NORMAL` mode.
4. Using the arrow keys, go to the line you want to insert the block. The block will be inserted above or bellow that line.
5. Press `p` to add the block bellow that line, or `P` to add it above that line.

## Delete
### one line
1. Place the cursor on the line you want to delete
2. Press `dd` to delete it.
3. Keep pressing to delete all lines below one by one.

### a block of code
1. Place the cursor on the first `#` and press `Shift + V`. This will enter the editor in `VISUAL LINE` mode.
2. Using the up/down arrow keys select the lines you want.
3. Press `d` and the editor will delete the lines selected.

## Comment
### a block of code
1. Place the cursor on the first line of the block you want to comment and press `Ctrl + V`. This will enter the editor in `VISUAL BLOCK` mode.
2. Using the up/down arrow keys select the lines you want.
3. Press `Shift + I`, which will put the editor in `INSERT` mode and then press `#`. This will add a hash to the first line.
4. Press `Esc` and it will insert a `#` on all selected lines.

## Uncomment
### a block of code
1. Place the cursor on the first `#` and press `Crtl + V`. This will enter the editor in `VISUAL BLOCK` mode.
2. Using the up/down arrow keys select the lines you want.
3. Press `x` and the editor will delete all `#` characters vertically.







