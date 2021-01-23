## Commands
### Commands reference
We can refer to a command output by using the `$()` or the back ticks `` ` ` ``.
```bash
echo "Hello $(id -un)"
echo "Hello `id -un`"   # old style reference
```


## Variables
### Naming rules
Variable names can contain
- letters
- digits
- underscores

Variable names cannot start with digit.

By convention all variable names should be uppercase.

Examples:
```bash
WORD1=''	# valid
_WORD=''	# valid
3WORD=''	# not valid
A-WORD=''	# not valid
E@MAIL=''	# not valid
word1=''    # valid, not recommended
```

### Value assignment
Assigning a value to a variable happens with the = operator, without any space. Examples:<br>
```bash
WORD='a word'		# valid
WORD = 'a word'		# not valid
```
Later in the script we can reassign a value to a variable.

```bash
NAME='John'
echo "Hello $NAME"  # echos "Hello John"
NAME='Mary'
echo "Hello $NAME"  # echos "Hello Mary"
```
#### Examples of value assignment
```bash
USER_ID=$UID            # variable reference
USER_ID=${UID}          # variable reference
USER_NAME=$(id -un)     # command reference
USER_NAME=`id -un`      # command reference - old style
```

### Variable reference
When we want to refer to a variable we use the `$`. We can also enclose the variable inside `{}` if needed.
Examples:
```bash
#assuming $USER='aUser', and $NAME='John'
echo "Hello $USER"        # echos "Hello aUser"
echo "Hello ${USER}"      # echos "Hello aUser"
echo "Hello ${USER}xyz"   # echos "Hello aUserxyz"
echo "Hello $USERxyz"     # this won't work
echo "Hello ${USER}${NAME}" # echos "Hello aUserJohn"
```

### Variable expansion - single quotes vs. double quotes
**Expansion:** The replacement of a variable's reference with the variable's value

Variable expansion occurs only when using double quotes. Examples:
```bash
echo '$USER' # echos "$USER"
echo "$USER" # echos "aUser"
```

### Variable length
We can find the length of a variable like:
```bash
USER_NAME="guest"
echo ${USER_NAME}   # echos 'guest'
echo ${#USER_NAME}  # echos '5'
```

### Readonly variables
With the command `readonly` we can mark shell variables as unchangeable. Examples:
```bash
readonly A
A=1     # won't work - A has null value

readonly B=1
B=2     # won't work - B has 1 value

C=1
readonly C
C=2     # won't work - C has 1 value

D=1
readonly D=2
D=3     # won't work - D has 2 value
```

### Local variables
Local variables are function scoped, and can be declared as:
```bash
function log {
    local MESSAGE=${1}
    echo "${MESSAGE}"
}
```
