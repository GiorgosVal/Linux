### Case statement
More info in `man bash`. Search for `case`, `Pathname Expansion`.

Execute commands based on pattern matching.

`case WORD in [PATTERN [| PATTERN]...) COMMANDS ;;]... esac`

Selectively execute COMMANDS based upon WORD matching PATTERN.  The `|` is used to separate multiple patterns.

Where `;;` can be:
- `;;`: Break - no subsequent matches are attempted after the first pattern match.
- `;&`: Continue - execution continues with the commands associated with the next set of patterns.
- `;;&`: Test the next pattern list in the statement, if any, and execute any associated commands on a successful match.

`~`

Examples:

```bash
case "${1}" in
    (start)
        echo "Starting."
        ;;
esac

case "${1}" in
    start)      # the stating parentheses ( is optional
        echo "Starting."
        ;;
esac


case "${1}" in
    start | starting)   # multiple patterns allowed
        echo "Starting."
        ;;
 esac
 
 case "${1}" in
    start*)          # this will match any string starting with 'start'
        echo "Starting."
        ;;
 esac

 case "${1}" in
    start*)          # the ;; are also optional for single cases
        echo "Starting."
 esac
```

The difference of `;;`, `;&` and `;;&`:
```bash
case "${1}" in
    one)
        echo "one"          #1
        ;;
    one*)
        echo "one"          #2
        ;;
    two)
        echo -n "two "      #3
        ;&
    three)
        echo "three"        #4
        ;;
    four)
        echo -n "four "     #5
        ;;&
    five)
        echo "five"         #6
        ;;
    four*)
        echo "four"         #7
        ;;
    *)
        echo "Invalid" >&2  #8
        exit 1
        ;;
esac

# Possible cases and outputs
# script run          script output     executed blocks
# ./script.sh one     one               1
# ./script.sh ones    one               2
# ./script.sh two     two three         3, 4
# ./script.sh three   three             4
# ./script.sh four    four four         5, 7
# ./script.sh five    five              6
# ./script.sh six     Invalid           8
```

```bash


```