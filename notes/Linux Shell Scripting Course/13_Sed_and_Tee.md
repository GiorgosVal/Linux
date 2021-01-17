# Sed (Stream EDitor)
## What streams are
A stream is data that travels from
- one process to another though a pipe
- one file to another as a redirect
- one device to another

Some streams are STDIN, STDOUT, STDERR.

## What Sed does
Performs text transformations on streams programmatically. For example:
- Substitute some text for other text
- remove lines
- append text after given lines
- insert text before certain lines
- etc

## Usage
`sed [OPTION]... {script-only-if-no-other-script} [input-file]...`

Options:
- `i[SUFFIX]`: edit files in place. If SUFFIX is given, creates a backup file named filenameSUFFIX. Example `-i.back` (with no space)
- `f` : use a file as an external script that contains sed commands

### Substitute function (find and replace)
`sed 'address s/search-pattern/replacement-string/flags' input-file`

Where `address` is optional and means on which line this command will be executed. Default is all lines.

Where `flags` are optional:
- `i` or `I`: case insensitive search
- `g`: global replacement - every occurrence will be replaced, not only the 1st of each line
- `number`: instead of `g` flag, we can specify which occurrence will be replaced
- `p`: If the substitution was made, then print the new pattern space
- `w file`: If the substitution was made, then write out the result to the named file
- `e`
- `m` or `M`: match the regular expression in `multi-line' mode

Examples:
```bash
$ cat love.txt
# output of the love.txt
I love my dog.
My dog loves sausages and caresses.
I believe my dog is perfect and I love to play with my dog.

# case sensitive substitution
$ sed 's/my dog/my wife/' love.txt
# output
I love my wife.
My dog loves sausages and caresses.
I believe my wife is perfect and I love to play with my dog.
# note 1: sed didn't altered the content of the love.txt file - it just displays the result
# note 2: sed performed case sensitive search
# note 3: sed replaced only the 1st occurrence of each line

# case insensitive substitution
$ sed 's/my dog/my wife/i' love.txt
# output
I love my wife.
my wife loves sausages and caresses.
I believe my wife is perfect and I love to play with my dog.

# global replacement
$ sed 's/my dog/my wife/ig' love.txt
# output
I love my wife.
my wife loves sausages and caresses.
I believe my wife is perfect and I love to play with my wife.

# specific occurrence replacement
$ sed 's/my dog/my wife/i2' love.txt
# output
I love my dog.
My dog loves sausages and caresses.
I believe my dog is perfect and I love to play with my wife.

# in-place editing creating backup file
$ sed -i.back 's/my dog/my wife/ig' love.txt
# Will edit the love.txt and create love.txt.back file
# edited file
$ cat love.txt
# output
I love my wife.
my wife loves sausages and caresses.
I believe my wife is perfect and I love to play with my wife.
# backup file
$ cat love.txt.back
# output
I love my dog.
My dog loves sausages and caresses.
I believe my dog is perfect and I love to play with my dog.

# writing to a new file
$ sed 's/love/like/igw like.txt' love.txt
# output
I like my dog.
my dog likes sausages and caresses.
I believe my dog is perfect and I like to play with my dog.
# note 1: sed displays the result AND also creates the like.txt

# pattern to match only the beginning of line
$ sed 's/^my/your/g' love.txt
# output
I love my dog.
your dog loves sausages and caresses.
I believe my dog is perfect and I love to play with my dog.
# note: since sed searches using a pattern, the ^ symbol means 'any line that starts with'

# pattern to match only the end of line
$ sed 's/dog.$/monkey./g' love.txt
# output
I love my monkey.
my dog loves sausages and caresses.
I believe my dog is perfect and I love to play with my monkey.
```

### Delete function
`sed '/search-pattern/d' input-file`

Deletes the lines that match the pattern. Examples:

```bash
$ cat love.txt
# output
I love my dog.
my dog loves sausages and caresses.
I believe my dog is perfect and I love to play with my dog.


$ sed '/I believe/d' love.txt
# output
I love my dog.
my dog loves sausages and caresses.
```

### Delimiters
`sed` doesn't necessarily use the `/` as a delimiter. Any character `!@#$%^&*()-_=+[]{};:'"\|,.<>/?|` (or even a letter or number) following the `s` in a sed script will be considered as a delimiter, as soon as it does not generate an error. Examples:
- `'s/search-pattern/replacement-string/'`
- `'s#search-pattern#replacement-string#'`
- `'s;search-pattern;replacement-string;'`
- `'s!search-pattern!replacement-string!'`
- `'s@search-pattern@replacement-string@'`
- `'s$search-pattern$replacement-string$'`
- `'s^search-pattern^replacement-string^'`

### Patterns
- `^`: match the start of line
- `$`: match the end of line
- `^$`: match blank lines (since the start of line is followed by the end of line)

### Combine functions
To use multiple sed functions, we separate them with `;` or use multiple `-e` option. The two following examples are equivalent. Sed performs 2 deletes and 1 substitution
- `sed '/^#/d ; /^$/d ; s/apache/httpd/g' file`
- `sed -e '/^#/d' -e '/^$/d' -e 's/apache/httpd/g' file`

### Use external script
We can use an external script that contains the sed commands. Example:
```bash
$ cat myscript
# output
/^#/d
/^$/d
s/apache/httpd/g

The following commands are equivalent
sed -f myscript file
sed -e '/^#/d' -e '/^$/d' -e 's/apache/httpd/g' file
```

### Working with addresses
We can specify the line(s) on which a sed command will be performed by specifying a line number (or range), or a pattern to match (or range of patterns). Examples:

Here is the content of a config file:
```bash
# User to run service as.
User apache

# Group to run service as.
Group apache
```
In the following example the sed command will act on the 2nd line only:
```bash
$ sed '2 s/apache/httpd/' config
# output

#User to run service as.
User httpd

# Group to run service as.
Group apache
```
In the following example the sed command will act on the lines 2 to 5 only:
```bash
$ sed '2,5 s/apache/httpd/' config
# output

#User to run service as.
User httpd

# Group to run service as.
Group httpd
```

In the following example the sed command will act only one the lines that start with `Group`:
```bash
$ sed '/^Group/ s/apache/httpd/' config
# output

# User to run service as.
User apache

# Group to run service as.
Group httpd
```
In the following example the sed command will act only one these lines starting from the line that begins with `User` and ending to the line starting with `Group`:
```bash
$ sed '/^User/,/^Group/ s/apache/httpd/' config
# output

#User to run service as.
User httpd

# Group to run service as.
Group httpd
```
In the following example the sed command will act only one these lines starting from the line that begins with `User` and ending to the 5th line:
```bash
$ sed '/^User/,5 s/apache/httpd/' config
# output

#User to run service as.
User httpd

# Group to run service as.
Group httpd
```

-----
# The `tee` command
The `tee` command reads from STDIN and writes to STDOUT and to files.<br>
Usage:<br>
`tee [OPTION]... [FILE]...`

Very useful option is:
- `a`: append to the given FILEs, do not overwrite

Example:

Let's say we want to append to the `/etc/hosts`:
```bash
# initial content
$ cat /etc/hosts
# output
127.0.0.1   localhost localhost.localdomain localhost4 localhost4.localdomain4
::1         localhost localhost.localdomain localhost6 localhost6.localdomain6
127.0.1.1 admin01 admin01

# we append with tee
echo "10.9.8.11 server01" | sudo tee -a /etc/hosts
echo "10.9.8.12 server02" | sudo tee -a /etc/hosts

# new content
$ cat /etc/hosts
# output
127.0.0.1   localhost localhost.localdomain localhost4 localhost4.localdomain4
::1         localhost localhost.localdomain localhost6 localhost6.localdomain6
127.0.1.1 admin01 admin01
10.9.8.11 server01
10.9.8.12 server02
```
>**Note:** Notice that the above operation would faild if we tried it like:
>```bash
>sudo echo "10.9.8.11 server01" >> /etc/hosts
># output
>-bash: /etc/hosts: Permission denied
>```
>The reason that we execute the `echo` command with `sudo` but we cannot execute the redirection with `sudo`. This is where the `tee` command comes to solve this.<br>
><br>