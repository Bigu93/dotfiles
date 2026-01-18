#!/bin/bash

# Check if tun0 interface exists
ifconfig tun0 2>/dev/null | grep "inet " | awk '{print $2}' | cut -d/ -f1

# If no tun0, check for tun1 (sometimes used)
if [ $? -ne 0 ]; then
    ifconfig tun1 2>/dev/null | grep "inet " | awk '{print $2}' | cut -d/ -f1
fi
