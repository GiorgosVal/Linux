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

The `-c` counts the occurrences
```bash
$ grep -Ec '^First|Name$' people.csv
# output
4
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
Sorts the lines of text files.

Here are the first 5 lines of the `/etc/passwd`:
```bash
$ cat /etc/passwd
# output
root:x:0:0:root:/root:/bin/bash
bin:x:1:1:bin:/bin:/sbin/nologin
daemon:x:2:2:daemon:/sbin:/sbin/nologin
adm:x:3:4:adm:/var/adm:/sbin/nologin
lp:x:4:7:lp:/var/spool/lpd:/sbin/nologin
```
The `sort` command sorts the `/etc/passwd` alphabetically:
```bash
$ sort /etc/passwd
# output
adm:x:3:4:adm:/var/adm:/sbin/nologin
bin:x:1:1:bin:/bin:/sbin/nologin
chrony:x:998:996::/var/lib/chrony:/sbin/nologin
daemon:x:2:2:daemon:/sbin:/sbin/nologin
dbus:x:81:81:System message bus:/:/sbin/nologin
```
And with the `-r` sorts them reverse alphabetically:
```bash
$ sort -r /etc/passwd
# output
vboxadd:x:997:1::/var/run/vboxadd:/bin/false
vagrant:x:1000:1000:vagrant:/home/vagrant:/bin/bash
systemd-network:x:192:192:systemd Network Management:/:/sbin/nologin
sync:x:5:0:sync:/sbin:/bin/sync
sshd:x:74:74:Privilege-separated SSH:/var/empty/sshd:/sbin/nologin
```
To sort numbers the `-n` option is required:
```bash
$ cut -d ':' -f 3 /etc/passwd | sort -n
# output
0
1
2
3
4
5
6
7
8
...

# and reverse
$ cut -d ':' -f 3 /etc/passwd | sort -nr
# output
65534
1009
1008
1007
1005
1003
1000
...
```
To sort numbers representing data units in human readable format we user the `-h` option:
```bash
$ sudo du -h /var | sort -h
# output
...
788K	/var/lib/yum/history
804K	/var/lib/yum/yumdb/p
920K	/var/lib/yum/yumdb/l
1.2M	/var/log
1.7M	/var/cache
1.7M	/var/cache/man
1.8M	/var/lib/mlocate
5.2M	/var/lib/yum/yumdb
6.0M	/var/lib/yum
98M	/var/lib/rpm
106M	/var/lib
109M	/var
```
To show only unique results we can use the `-u` option:
```bash
# with no sorting
$ echo -e "101\n1500\n10\n3\n4\n17\n4\n17\n22"
# output
101
1500
10
3
4
17
4
17
22

# with simple sorting
$ echo -e "101\n1500\n10\n3\n4\n17\n4\n17\n22" | sort -n
# output
3
4
4
10
17
17
22
101
1500

# with sorting and filtering unique
$ echo -e "101\n1500\n10\n3\n4\n17\n4\n17\n22" | sort -nu
# output
3
4
10
17
22
101
1500
```
By default `sort` uses space separator, and sorts the files using the 1st field. To use another separator we use the `-t` option, and to sort the file using a different field we use the `-k` option:
```bash
# The reverse sorting happens according to the id column
$ sort -t ':' -k 3 -nr /etc/passwd
# output
nfsnobody:x:65534:65534:Anonymous NFS User:/var/lib/nfs:/sbin/nologin
luigi:x:1009:1010:luigi:/home/luigi:/bin/bash
mario:x:1008:1009:mario:/home/mario:/bin/bash
isaac:x:1005:1006:Isaac Newton:/home/isaac:/bin/bash
mary:x:1003:1004:mary poppins:/home/mary:/bin/bash
vagrant:x:1000:1000:vagrant:/home/vagrant:/bin/bash
```

## The `uniq` command
It's similar to the `sort -u` but in order to work the lines must be sorted. It provides though other functions which makes it handy.

Here's the original lines sorted and unique:
```bash
$ echo -e "101\n1500\\n22\n10\n3\n4\n17\n4\n17\n22" | sort -n | uniq
# output
3
4
10
17
22
101
1500
```
To count the occurrence of each line we use the `-c` option:
```bash
$ echo -e "101\n1500\\n22\n10\n3\n4\n17\n4\n17\n22" | sort -n | uniq -c
# output
      1 3
      2 4
      1 10
      2 17
      2 22
      1 101
      1 1500
```

## The `tail` command
Outputs the last part of lines (default 10)
```bash
$ tail /etc/passwd
# output
postfix:x:89:89::/var/spool/postfix:/sbin/nologin
chrony:x:998:996::/var/lib/chrony:/sbin/nologin
sshd:x:74:74:Privilege-separated SSH:/var/empty/sshd:/sbin/nologin
vagrant:x:1000:1000:vagrant:/home/vagrant:/bin/bash
vboxadd:x:997:1::/var/run/vboxadd:/bin/false
mary:x:1003:1004:mary poppins:/home/mary:/bin/bash
isaac:x:1005:1006:Isaac Newton:/home/isaac:/bin/bash
gior:x:1007:1008:Giorgos Valamatsas 14/11/1987:/home/gior:/bin/bash
mario:x:1008:1009:mario:/home/mario:/bin/bash
luigi:x:1009:1010:luigi:/home/luigi:/bin/bash
```
With `-n` we specify the number of lines
```bash
$ tail -n 2 /etc/passwd
# output
mario:x:1008:1009:mario:/home/mario:/bin/bash
luigi:x:1009:1010:luigi:/home/luigi:/bin/bash

# Which is the same as doing
$ tail -2 /etc/passwd
```

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

## Combination of `awk`, `sort`, `uniq` example
```bash
# Having something like this
$ sudo cat /var/log/messages
# output
... many lines
Jan 10 03:23:46 localusers NetworkManager[619]: <info>  [1610267026.8490] manager: NetworkManager state is now CONNECTED_SITE
Jan 10 03:23:46 localusers NetworkManager[619]: <info>  [1610267026.8492] policy: set 'System eth0' (eth0) as default for IPv4 routing and DNS
Jan 10 03:23:46 localusers NetworkManager[619]: <info>  [1610267026.8539] device (eth0): Activation: successful, device activated.
Jan 10 03:23:47 localusers systemd: Starting Notify NFS peers of a restart...
Jan 10 03:23:47 localusers sm-notify[914]: Version 1.3.0 starting
Jan 10 03:23:47 localusers kdumpctl: No memory reserved for crash kernel
Jan 10 03:23:47 localusers kdumpctl: Starting kdump: [FAILED]
Jan 10 03:26:03 localusers chronyd[626]: Selected source 185.120.22.12
Jan 10 03:38:51 localusers systemd: Starting Cleanup of Temporary Directories...
Jan 10 03:38:51 localusers systemd: Started Cleanup of Temporary Directories.

# Our goal is to count how many logs are generated by each system procedure.
# To achieve this we'll awk the 5th field, sort alphabetically the results, count the uniq lines, sort them again numerically:
$ sudo cat /var/log/messages | awk '{print $5}' | sort | uniq -c | sort -nr
# output
   1847 kernel:
   1438 systemd:
    178 systemd[1]:
    118 NetworkManager[619]:
     71 NetworkManager[631]:
        ... more lines
```