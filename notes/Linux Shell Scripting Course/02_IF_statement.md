## Tips
- Always enclose variable references in double quotes, when using them in a test.
- `help if`
- `help [` or `help [[`
- `help test` 

## Structure
`if COMMANDS; then COMMANDS; [ elif COMMANDS; then COMMANDS; ]... [ else COMMANDS; ] fi`

Where `;` means we can start a new line (and omit writing the `;`). Also notice that `elif` and `else` are optional.

## Exit status
Exit status means whether a condition is true (exit status 0) or false (exit status 1).

## [ ] or [[ ]] ?
Both `[ expression ]` and `[[ expression ]]` will work.<br>
`[` is a shell builtin (synonym of the `test` command), old style<br>
`[[` is a shell keyword, new style<br>
Use `help [` or `help [[` for more info.

## If example
```bash
if [[ "${UID}" -eq 0 ]]
then
    echo 'You are root.'
fi
```
>Note: This can also be written as
>```bash
>if [[ "${UID}" -eq 0 ]]; then echo 'You are root'; fi
>```
><br>

## If Else example
```bash
if [[ "${UID}" -eq 0 ]]
then
    echo 'You are root.'
else
    echo 'You are not root.'
fi
```