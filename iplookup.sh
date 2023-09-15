#!/bin/sh
for i in `cat /root/IP.txt|grep -v "#"`
do
ADDR=$i
geo=$(curl -s http://ipwhois.pro/$ADDR?key=TOYJBJQ5GEp2iWhC)
geo_country=$(echo $geo | jq -r '.country')
geo_region=$(echo $geo | jq -r '.region')
geo_city=$(echo $geo | jq -r '.city')
geo_isp=$(echo $geo | jq -r '.connection' | jq -r '.isp')
ADDRPRIVATE=$(echo $ADDR | sed 's/.........$/x.xx.xx/')
echo -e "\e[0m$ADDRPRIVATE || $geo_country || $geo_city -> $geo_region || $geo_isp"
done
