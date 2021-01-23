## The getopts command
Getopts is used by shell procedures to parse positional parameters as options. If we're about to write a script with many options, and we want these options to be recognized independently of their position, then `getopts` is suitable for this job. 

`getopts optstring name [arg]`

Where:
- `optstring`: is the options that the script will recognize. Options by a colon (`:`) expect to have an argument.
- `name`: is a variable that is going to be populated with an option

Every time `getopts` is called, it reads an option and it returns 0 or non 0. This is why we call `getopts` inside a `while` loop.

An example implementation:
```bash
# This scrip generates a password
# User can set a password length with -l
# User can add a special character with -s
# User can turn on verbose mode with -v

# Set a default password length.
LENGTH=48
 while getopts vl:s OPTION
 do
     case ${OPTION} in
         v)
             VERBOSE='true'
             echo 'Verbose mode on.'
             ;;
         l)
             LENGTH=${OPTARG}
             echo "Length ${LENGTH}."
             ;;
         s)
             USE_SPECIAL_CHARACTER='true'
             echo 'Will use special character.'
             ;;
         *)
             echo 'Invalid option.' >&2
             exit 1
             ;;
     esac
 done

# Remove the options while leaving the remaining arguments.
shift "$(( OPTIND - 1 ))"

if [[ "${#}" -gt 0 ]]
then
  usage
fi

# This script can be called with various ways:
script.sh -v
script.sh -s
script.sh -l
script.sh -v -l 8 -s
script.sh -v -s -l 8
script.sh -vs -l 8
script.sh -vl 8 -s
script.sh -vsl 8
#... and nany more combinations

# But will fail if we provide any other arguments
script.sh -v -l 7 asd   # will fail after reading the -l 7
script.sh -v asd -l 7   # Will fail after reading the -v
script.sh asd -v -l 7   # Will fail instantly
```