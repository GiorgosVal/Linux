## Functions
`function name { COMMANDS ; } or name () { COMMANDS ; }`

Define shell function.

Create a shell function named `NAME`. When invoked as a simple command, `NAME` runs `COMMANDs` in the calling shell's context. When `NAME` is invoked, the arguments are passed to the function as `$1...$n`, and the function's name is in `$FUNCNAME`.

### Declaration
There are two ways to declare a function:
```bash
function log {
    echo "Hello"
}

# same
log () {
    echo 'Hello'
}
```

### Calling a function
We can call a function with or without arguments:
```bash
log
log arg1 "arg2" 'arg3'
```

### Positional Parameters
Functions have the same positional parameters as the script, with few differences:
- `0`: remains the script's name. Use `${FUNCNAME}` for the function's name instead.
- `#`: is updated to hold the number of arguments passed in the function

All other positional parameters have same functionality:
- `1`, `2`, ... `n` : the arguments passed in the function
- `@`: the list of all arguments passed
- etc

### Local variables
Local variables are function scoped, and can be declared as:
```bash
function log {
    local MESSAGE=${1}
    echo "${MESSAGE}"
}
```

### Return statement
Inside a function we can use `return [n]`. We prefer this that `exit [n]` since the `exit` command will exit the entire script, while the `return` command will exit the function only.

The function completes and execution resumes with the next command after the function call:
```bash
function log {
    echo "Before the return"
    return
    echo "After the return"
}

echo "Before the function"
log
echo "After the function"
```
The output of this script will be
```
Before the function
Before the return
After the function
```

### Global variables - bad practices
Global variables can be declared inside a function. This is considered a bad practice, as this global variable is available only after the 1st call of the function:
```bash
function log {
    GLOBAL=${1}
    echo "${GLOBAL}"
}

echo ${GLOBAL}  # empty
log "Hi"
echo ${GLOBAL}  # "Hi"
```

### Functions - best practices
- Always declare the functions at the top of the script
- Inside a function use `return [n]` instead of `exit [n]`.