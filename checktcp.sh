#!/bin/bash
# Script to print Linux TCP connections using netstat
# Github: https://github.com/jmutai
#  
#    vvvv vvvv-- the code from above
RED='\033[0;31m'
NC='\033[0m' # No Color
echo ""
echo -en "${RED} ALL TCP Connections Count: ${NC}\n"
netstat -nat | awk '{print $6}' | sort | uniq -c | sort -r
echo ""
echo -en "${RED} Top CLOSE_WAIT state TCP Connections: ${NC}\n"
netstat -apn | grep CLOSE_WAIT | awk '{ print $7 }' | sort | uniq -c | sort -nr | head -n 10