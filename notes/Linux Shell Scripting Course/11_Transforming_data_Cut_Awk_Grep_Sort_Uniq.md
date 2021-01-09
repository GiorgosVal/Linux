## The `cut` command
Is used to cut is used to cut out sections of each line input it receives, and display them.

`cut OPTION... [FILE]...`

`-c`: Cuts the characters passed 
```bash
# Example input
LINES='()*I\nrhglove\nqwebash shelluhf\nasxscripting'
echo -e $LINES

#output
()*I
rhglove
qwebash shelluhf
asxscripting

# But with cut
echo -e $LINES | cut -c 4,5,6,7-13

# output
I
love
bash shell
scripting
```
`-b`: Cuts the bytes passed. It is different than `-c` since there are characters that may not be single-byte. For example the letter `ñ` is a 2-byte.
```bash
echo "mañana" | cut -c 3
# outputs the 3rd caracter
ñ

echo "mañana" | cut -b 3
# outputs
�
echo "mañana" | cut -b 4
# outputs
�
echo "mañana" | cut -b 3,4
# outputs
ñ
```
`-f`: Cuts the fields of TAB separated lines
```bash
echo -e "one\ttwo\tthree\tfour"
# output
one     two     three   four

echo -e "one\ttwo\tthree\tfour" | cut -f 2-3
# output
two     three

# NOTE: It does not remove the TAB delimiter
```
`-f` with `-d`: Cuts the fields of lines using a delimiter
```bash
echo "one:two:three:four"
# output
one:two:three:four

echo "one:two:three:four" | cut -d ':' -f 2-3   # Best practice is to quote the delimiter
# output
two:three

# NOTE: It does not remove the delimiter
```
```bash
$ cat people.csv
# output
First Name;Last Name
Mario;Plumber
Luigi;MacPlumber
Maria;Dolorez
Giorgio;Harmani

cut -d ';' -f 1 people.csv
# output
First Name
Mario
Luigi
Maria
Giorgio
```
`--output-delimiter`: replaces the delimiter with a string
```bash
echo "one:two:three:four"
# output
one:two:three:four

echo "one:two:three:four" | cut -d ':' -f 1- --output-delimiter ','
# output
one,two,three,four
```

>**Note 1:** Selection can be passed as:
>- specific numbers, e.g. 1,2,3,4,10,15
>- closed range, e.g. 4-10
>- open range, e.g. -4, 15-
>- combinations, e.g. -4,8,11,12,18-20,25-
>
>**Note 2:** The delimiter must be a single character
><br>
><br>

## The `grep` command
Searches for a PATTERN inside a FILE or the STDIN and prints the lines that match.

Having the following csv
```bash
$ cat people.csv
# output
First Name;Last Name
Mario;Plumber
Luigi;MacPlumber
Maria;Dolorez
Georgio;Harmani
John;First
Anna;Lastly
Firster;John
Lastly;MacName
Mr Smith;Mac Name
Joana;Namely
```
```bash
$ grep First people.csv
# output
First Name;Last Name
John;First
Firster;John

$ grep Last people.csv
# output
First Name;Last Name
Anna;Lastly
Lastly;MacName
```
The `-w` option selects only those lines containing matches that form whole words
```bash
$ grep -w Last people.csv   # selects all lines having the word 'Last'
# output
First Name;Last Name
```
The `^PATTERN` will select only the lines **starting** with this pattern:
```bash
$ grep '^First' people.csv  # selects all lines starting with 'Name'
# output
First Name;Last Name
Firster;John
```
The `PATTERN$` will select only the lines **ending** with this pattern:
```bash
$ grep 'Name' people.csv    # selects all lines containing 'Name'
# output
First Name;Last Name
Lastly;MacName
Mr Smith;Mac Name
Joana;Namely

$ grep 'Name$' people.csv   # selects all lines ending in 'Name'
# output
First Name;Last Name
Lastly;MacName
Mr Smith;Mac Name
Joana;Namely
```
The `-v` inverts the sense of matching:
```bash
$ grep -v "Name$" people.csv    # selects all lines NOT ending in 'Name'
# output
Mario;Plumber
Luigi;MacPlumber
Maria;Dolorez
Georgio;Harmani
John;First
Anna;Lastly
Firster;John
Joana;Namely
```
The `-E` allows multiple patterns (with `|`):
```bash
$ grep -E '^First|Name$' people.csv # selects all lines starting with 'First' OR ending in 'Name'
# output
First Name;Last Name
Firster;John
Lastly;MacName
Mr Smith;Mac Name

# -v will invert this
$ grep -Ev '^First|Name$' people.csv # selects all lines NOT starting with 'First' OR ending in 'Name'
# output
Mario;Plumber
Luigi;MacPlumber
Maria;Dolorez
Georgio;Harmani
John;First
Anna;Lastly
Joana;Namely
```

## The `awk` command
An example similar to the cut with delimiter:
```bash
awk -F ':' '{print $1,$3}' /etc/passwd
# uses the : delimiter and prints the 1st, 2nd, 3rd field

# output - dy default it uses spaces to separate the fields
root 0
bin 1
daemon 2
adm 3
lp 4
sync 5
shutdown 6
halt 7
mail 8
operator 11

# we can change the order too
awk -F ':' '{print $3,$1}' /etc/passwd
# output
0 root
1 bin
2 daemon
3 adm
4 lp
5 sync
6 shutdown
7 halt
8 mail
11 operator
```
> **Note**: The variable `NF` is set to the total number of fields. So, `print $NF` will print the last field, and `print $(NF - 1)` will print the 2nd from the end field, etc.

The `OFS` (output field separator) is variable, and is a space by default. We can change it by changing the variables value with the `-v` option.
```bash
$ awk -F ':' -v OFS=',' '{print $1,$3}' /etc/passwd
# output
root,0
bin,1
daemon,2
adm,3
lp,4
sync,5
shutdown,6
halt,7
mail,8
operator,11
```
We can customize over more the output by writing the text we want `awk` to print:
```bash
awk -F ':' -v OFS=',' '{print "user: " $1,"\tid: " $3}' /etc/passwd
# output
user: root,	    id: 0
user: bin,	    id: 1
user: daemon,	id: 2
user: adm,	    id: 3
user: lp,	    id: 4
user: sync,	    id: 5
user: shutdown,	id: 6
user: halt,	    id: 7
user: mail,	    id: 8
user: operator,	id: 11
```
>**Note:** The delimiter can be multi-character
Handling irregular data is pretty easy:
```bash
cat lines
# output
l1c1     l1c2
   l2c1     l2c2
      l3c1  l3c2
 l4c1  l4c2
  l5c1  l5c2
l6c1        l6c2
	l7c1  		l7c2

awk '{print $1, $2}' lines
# output
l1c1 l1c2
l2c1 l2c2
l3c1 l3c2
l4c1 l4c2
l5c1 l5c2
l6c1 l6c2
l7c1 l7c2
```

## The `sort` command

## The `uniq` command


___
## Combination of`grep` and `awk` example
```bash
# Having
$ netstat -4nutl | grep ':'
# output
tcp        0      0 0.0.0.0:22              0.0.0.0:*               LISTEN
tcp        0      0 127.0.0.1:25            0.0.0.0:*               LISTEN
udp        0      0 0.0.0.0:11486           0.0.0.0:*
udp        0      0 127.0.0.1:323           0.0.0.0:*
udp        0      0 0.0.0.0:68              0.0.0.0:*

# The following commands will generate the same output
netstat -4nutl | grep ':' | awk '{print $4}' | cut -d ':' -f 2
netstat -4nutl | grep ':' | awk '{print $4}' | awk -F ':' '{print $NF}'
netstat -4nutl | grep ':' | awk '{print $4}' | awk -F ':' '{print $2}'
# output
22
25
11486
323
68

# We must use "awk '{print $4}' " to narrow down the columns - something not possible with cut
# Then we can either use awk again, or cut
```