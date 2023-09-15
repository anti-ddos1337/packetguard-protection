for i in `cat /root/BlackList.txt|grep -v "#"`
do
ADDR=$i
ipset add blacklist $ADDR > /dev/null 2>&1 &
echo "$ADDR"
done