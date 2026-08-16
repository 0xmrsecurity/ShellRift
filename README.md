# ShellRift
A cross‑platform reverse shell payload generator for Linux and Windows – built for authorized penetration testing and CTF.


## ShellRift-linux.sh
Auto Assign your tun0 Interface Ip Address and Default Port 9001
```bash
wget https://raw.githubusercontent.com/0xmrsecurity/ShellRift/refs/heads/main/ShellRift-linux.sh
chmod +x ShellRift-linux.sh
bash ./ShellRift-linux.sh --help

bash ./ShellRift-linux.sh
[+] No --lhost provided, detecting tun0 IP...
[+] tun0 IP: x.x.x.x
[+] Linux Reverse Shell Payloads (LHOST=x.x.x.x, LPORT=9001)

<Sniped all>
```

## ShellRift-Window.sh
```bash
wget https://raw.githubusercontent.com/0xmrsecurity/ShellRift/refs/heads/main/ShellRift-Window.sh
chmod +x ShellRift-Window.sh
bash ./ShellRift-Window.sh --help

bash ./ShellRift-Window.sh --lhost x.x.x.x --lport 9001 --sport 8000 
[*] Configuration:
    Listener IP:   x.x.x.x
    Listener Port: 9001
    Server Port:   8000
    Server URL:    http://x.x.x.x:8000/touch.ps1

[+] Generating random variable names...
[+] Creating PowerShell reverse shell...
[+] Creating download cradle...
[+] Encoding payload...
[+] Saving payloads to payload.txt...

<sniped all>
```
