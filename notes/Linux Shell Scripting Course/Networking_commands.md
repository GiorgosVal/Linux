## The `netstat` command
Options:
- `-n`: Display numbers instead of names. E.g. instead `localusers:ssh` and `gateway:52846` will show `10.0.2.15:22` and `10.0.2.2:52846`.
- `-u`: Get information on udp
- `-t`: Get information on tcp
- `-l`: Listening ports
- `-4`: For tcp4 / udp4
- `-6`: For tcp6 / udp6
- `-p`: display PID/Program name for sockets

Example:
```bash
$ netstat -4nutl
# output
Active Internet connections (only servers)
Proto Recv-Q Send-Q Local Address           Foreign Address         State
tcp        0      0 0.0.0.0:22              0.0.0.0:*               LISTEN
tcp        0      0 127.0.0.1:25            0.0.0.0:*               LISTEN
udp        0      0 0.0.0.0:11486           0.0.0.0:*
udp        0      0 127.0.0.1:323           0.0.0.0:*
udp        0      0 0.0.0.0:68              0.0.0.0:*
```