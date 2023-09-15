for i in `cat /root/blackhole.txt|grep -v "#"`
do
ADDR=$i
ipset add blackhole $ADDR > /dev/null 2>&1 &
echo "$ADDR"
done