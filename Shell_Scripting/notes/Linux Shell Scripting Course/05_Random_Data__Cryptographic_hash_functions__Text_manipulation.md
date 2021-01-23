## Generating random data
### RANDOM variable
`RANDOM` is a bash variable that generates a random integer between 0 and 32767.

### date command
A naive way to generate a unique number is to use the `date +%s` which outputs the epoch (seconds since 1970-01-01 00:00:00 UTC). We can also use `date +%s%N` which outputs the seconds and nanoseconds.

## Checksums
Checksums are used to check the uniqueness of a file. There are many hash algorithms (do `ls -l /usr/bin/*sum` to find them):
- cksum
- md5sum
- sha1sum
- sha224sum
- sha256sum
- sha384sum
- sha512sum
- sum

To find the checksum of a file:
```bash
sha1sum file.txt
```

If the file is not specified, then the input comes from stdin. So, piping the `date` and `sha256sum` commands will generate a the checksum of the date:
```bash
$ date +%s%N | sha256sum
788347b13361d42a808bcf36158989757781fee7480489400940ed10b3216bf2  -
```

## Manipulating Text
### The `head` command
Print  the first 10 lines of each FILE to standard output.  With more than one FILE, precede each with a header giving the file name.  With no FILE, or when FILE is -, read standard input.

Examples:
```bash
head -n1 /etc/passwd          # outputs only the 1st line
head --lines=-5 /etc/passwd   # outputs all the file except the last 5 lines
head -c10 /etc/passwd         # outputs the first 10 characters
```

### The `fold` command
Wrap input lines in each FILE (standard input by default), writing to standard output. Example:
```bash
S='!@#$%^&*()-_+='
echo ${S} | fold -w1 # Will echo every character in a separate line
```

### The `shuf` command
Write a random permutation of the input lines to standard output. Example:
```bash
shuf /etc/passwd # will echo the passwd file lines, but every time with random permutation

S='!@#$%^&*()-_+='
echo ${S} | fold -w1 | shuf # Will echo every character in a separate line, and every time with random permutation
```


## Combining all the above to generate a random password
```bash
PASSWORD=$(date +%s%N${RANDOM}${RANDOM} | sha256sum | head -c48)
SPECIAL_CHARACTER=$(echo '!@#$%^&*()_-+=' | fold -w1 | shuf | head -c1)
echo ${PASSWORD}${SPECIAL_CHARACTER}

# Example outputs:
# 96230154e52ffd87988da62d172d97cf8f6800d6ad9688fb&
# 7a1a468f9630dd03994f40e6cc8a37ff1435f0177f1a6ea5^
# eb13fcdc97dc461307b7fb4fd71b1c198d64883176d85835#
# 3bf8e4b3c947094b895092b1ad129ba1d76fde8f7568eff8(
# 9c105e76b2066e29cb31667a07305aae73e8907219827890^
# c56b4a5bfcf1d14bc3e6b64247e2fcb819059a2e61af603b#
# fbcce4c86465fbc7a6156e474b6788d27dd74f7080a1ebc2!
# 315486a86426febf766ae72761195ce2e821aebdcb93f025*
# 731681998746967e12f1fe54b1e1a6473227a8b1f48f48a2)
# 190d26e9318e30847494ac95ebfa793b8e7603af542386b9!
```