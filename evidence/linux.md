# Task 01: Linux Diagnostics & Operational Evidence

## 1. System & Kernel Identification
```bash
$ uname -a
Linux ip-172-31-26-30 7.0.0-1006-aws #6-Ubuntu SMP PREEMPT Tue May 26 12:04:34 UTC 2026 x86_64 GNU/Linux

$ cat /etc/os-release
PRETTY_NAME="Ubuntu 26.04.1 LTS"
NAME="Ubuntu"
VERSION_ID="26.04"
VERSION="26.04.1 LTS (Resolute Raccoon)"
VERSION_CODENAME=resolute
ID=ubuntu
ID_LIKE=debian
HOME_URL="https://www.ubuntu.com/"
SUPPORT_URL="https://help.ubuntu.com/"
BUG_REPORT_URL="https://bugs.launchpad.net/ubuntu/"
PRIVACY_POLICY_URL="https://www.ubuntu.com/legal/terms-and-policies/privacy-policy"
UBUNTU_CODENAME=resolute
LOGO=ubuntu-logo
```

## 2. Resource Utilization (CPU, Memory, Disk)
```bash
$ top -bn1 | head -n 5
top - 06:31:41 up 41 min,  1 user,  load average: 0.00, 0.00, 0.00
Tasks: 158 total,   1 running, 157 sleeping,   0 stopped,   0 zombie
%Cpu(s):  4.8 us,  0.0 sy,  0.0 ni, 95.2 id,  0.0 wa,  0.0 hi,  0.0 si,  0.0 st 
MiB Mem :   7775.4 total,   4815.1 free,    636.6 used,   2645.2 buff/cache     
MiB Swap:      0.0 total,      0.0 free,      0.0 used.   7138.8 avail Mem 

$ free -h
               total        used        free      shared  buff/cache   available
Mem:           7.6Gi       636Mi       4.7Gi       2.9Mi       2.6Gi       7.0Gi
Swap:             0B          0B          0B

$ df -h
Filesystem       Size  Used Avail Use% Mounted on
/dev/root         28G  3.5G   25G  13% /
tmpfs            3.8G     0  3.8G   0% /dev/shm
tmpfs            1.6G  1.1M  1.6G   1% /run
efivarfs         128K  3.1K  120K   3% /sys/firmware/efi/efivars
tmpfs            3.8G     0  3.8G   0% /tmp
/dev/nvme0n1p13  989M  165M  757M  18% /boot
/dev/nvme0n1p15  105M  6.3M   99M   7% /boot/efi
none             1.0M     0  1.0M   0% /run/credentials/getty@tty1.service
none             1.0M     0  1.0M   0% /run/credentials/serial-getty@ttyS0.service
tmpfs            778M  8.0K  778M   1% /run/user/1000
none             1.0M     0  1.0M   0% /run/credentials/systemd-journald.service
none             1.0M     0  1.0M   0% /run/credentials/systemd-networkd.service
none             1.0M     0  1.0M   0% /run/credentials/systemd-resolved.service
```

## 3. Network & Listening Ports
```bash
$ ss -tulpn
Netid State  Recv-Q Send-Q        Local Address:Port Peer Address:PortProcess
udp   UNCONN 0      0                127.0.0.54:53        0.0.0.0:*          
udp   UNCONN 0      0             127.0.0.53%lo:53        0.0.0.0:*          
udp   UNCONN 0      0      172.31.26.30%enp39s0:68        0.0.0.0:*          
udp   UNCONN 0      0                 127.0.0.1:323       0.0.0.0:*          
udp   UNCONN 0      0                     [::1]:323          [::]:*          
tcp   LISTEN 0      4096                0.0.0.0:22        0.0.0.0:*          
tcp   LISTEN 0      4096             127.0.0.54:53        0.0.0.0:*          
tcp   LISTEN 0      4096          127.0.0.53%lo:53        0.0.0.0:*          
tcp   LISTEN 0      4096                   [::]:22           [::]:*          

$ ping -c 3 google.com
PING google.com (142.251.179.101) 56(84) bytes of data.
64 bytes from pd-in-f101.1e100.net (142.251.179.101): icmp_seq=1 ttl=106 time=1.56 ms
64 bytes from pd-in-f101.1e100.net (142.251.179.101): icmp_seq=2 ttl=106 time=1.59 ms
64 bytes from pd-in-f101.1e100.net (142.251.179.101): icmp_seq=3 ttl=106 time=1.60 ms

--- google.com ping statistics ---
3 packets transmitted, 3 received, 0% packet loss, time 2003ms
rtt min/avg/max/mdev = 1.563/1.583/1.595/0.014 ms
```

## 4. Top Memory Consuming Processes & Disk Distribution
### Memory Usage by Process
```bash
$ ps aux --sort=-%mem | head -n 10
USER         PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
root       28776  0.0  1.1 1952048 90016 ?       Ssl  05:54   0:00 /usr/bin/dockerd -H fd:// --containerd=/run/containerd/containerd.sock
root       29321  0.1  0.6 574364 49596 ?        Ssl  06:13   0:01 /usr/libexec/fwupd/fwupd
root       28618  0.0  0.5 1821100 43764 ?       Ssl  05:54   0:02 /usr/bin/containerd
root       16726  0.0  0.5 1886408 41880 ?       Ssl  05:53   0:00 /usr/lib/snapd/snapd
root         887  0.0  0.4 126208 32272 ?        Ssl  05:50   0:00 /usr/bin/python3 /usr/share/unattended-upgrades/unattended-upgrade-shutdown --wait-for-signal
root         768  0.0  0.3  46808 29804 ?        Ss   05:50   0:00 /usr/bin/python3 /usr/bin/networkd-dispatcher --run-startup-triggers
root        1176  0.0  0.2 1759280 20884 ?       Ssl  05:50   0:00 /snap/amazon-ssm-agent/13009/amazon-ssm-agent
root           1  0.4  0.2  25776 16868 ?        Ss   05:50   0:11 /usr/lib/systemd/systemd --system --deserialize=12
root        9501  0.0  0.1  50400 15276 ?        S<s  05:53   0:00 /usr/lib/systemd/systemd-journald
```

### Disk Usage by Directory
```bash
$ sudo du -sh /* 2>/dev/null | sort -hr | head -n 10
2.8G	/usr
622M	/var
510M	/snap
171M	/boot
6.3M	/etc
1.2M	/run
424K	/home
36K	/root
16K	/opt
16K	/lost+found
```

## 5. Troubleshooting Procedures

### High CPU Utilization
1. Identify high-load process PID via `top` or `htop`.
2. Inspect active threads and system calls using `strace -p <PID>` or `perf top`.
3. Check for application-level infinite loops, thread starvation, or garbage collection spikes.

### Low Disk Space
1. Trace large directory trees with `du -sh /* | sort -hr`.
2. Locate un-rotated log files in `/var/log` or container mount volumes.
3. Clear dangling containers and images using `docker system prune -af --volumes`.

### Unreachable API
1. Verify if the target process is running using `systemctl status <service>` or `docker ps`.
2. Confirm binding state and port listening status via `ss -tulpn | grep <port>`.
3. Validate network path, firewall rules, and security groups with `curl -iv http://127.0.0.1:<port>/health` and `iptables -L`.

### Repeatedly Terminating Process
1. Query kernel memory manager for Out-Of-Memory (OOM) kills using `dmesg -T | grep -i oom`.
2. Inspect service system log stream via `journalctl -u <service-name> -e --no-pager`.
3. Review container crash states and exit codes using `docker inspect <container> --format='{{.State.ExitCode}}'`.
