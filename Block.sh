start=$SECONDS
yum install ipset -y >> log.txt
ipset create blacklist hash:ip hashsize 4096 >> log.txt
ipset create blackhole hash:ip hashsize 4096 >> log.txt
if ! iptables -C INPUT -p tcp --dport 443 -m set --match-set blacklist src -j DROP; then
   iptables -I INPUT -p tcp --dport 443 -m set --match-set blacklist src -j DROP
fi
if ! iptables -C INPUT -p tcp --dport 443 -m set --match-set blackhole src -j DROP; then
   iptables -I INPUT -p tcp --dport 443 -m set --match-set blackhole src -j DROP
fi
if ! iptables -C INPUT -p tcp --dport 80 -m set --match-set blackhole src -j DROP; then
   iptables -I INPUT -p tcp --dport 80 -m set --match-set blackhole src -j DROP
fi
if ! iptables -C INPUT -p tcp --dport 80 -m set --match-set blacklist src -j DROP; then
   iptables -I INPUT -p tcp --dport 80 -m set --match-set blacklist src -j DROP
fi
while :; do
   rm BlackList.txt
   #IPAdd=$(netstat -ntu | grep :443 | grep ESTAB | grep ':' | awk '{print $5}' | sed 's/::ffff://' | cut -f1 -d ':' | sort | uniq -c | sort -nr | head | awk '{print $2}' > IP.txt)
   Count=$(netstat -ntu | grep :443 | grep ESTAB | grep ':' | awk '{print $5}' | sed 's/::ffff://' | cut -f1 -d ':' | sort | uniq -c | sort -nr | awk '{print "Connection:""["$1"]"" -> ""IPAddress:"$2}' | wc -l)
   Blacklist=$(netstat -ntu | grep :443 | grep ESTAB | grep ':' | awk '{print $5}' | sed 's/::ffff://' | cut -f1 -d ':' | sort | uniq -c | sort -nr | awk '{if($1>5)print$2}' > BlackList.txt)
   timewait=$(netstat -ntu | grep :443 | grep TIME_WAIT | grep ':' | awk '{print $5}' | sed 's/::ffff://' | cut -f1 -d ':' | sort | uniq -c | sort -nr | awk '{if($1>5)print$2}' >> BlackList.txt)
   finwait2=$(netstat -ntu | grep :443 | grep FIN_WAIT2 | grep ':' | awk '{print $5}' | sed 's/::ffff://' | cut -f1 -d ':' | sort | uniq -c | sort -nr | awk '{if($1>5)print$2}' >> BlackList.txt)
   finwait1=$(netstat -ntu | grep :443 | grep FIN_WAIT1 | grep ':' | awk '{print $5}' | sed 's/::ffff://' | cut -f1 -d ':' | sort | uniq -c | sort -nr | awk '{if($1>5)print$2}' >> BlackList.txt)
   last_ack=$(netstat -ntu | grep :443 | grep LAST_ACK | grep ':' | awk '{print $5}' | sed 's/::ffff://' | cut -f1 -d ':' | sort | uniq -c | sort -nr | awk '{if($1>5)print$2}' >> BlackList.txt)
   syn_recv=$(netstat -ntu | grep :443 | grep SYN_RECV | grep ':' | awk '{print $5}' | sed 's/::ffff://' | cut -f1 -d ':' | sort | uniq -c | sort -nr | awk '{if($1>5)print$2}' >> BlackList.txt)
   syn_listen=$(netstat -ntu | grep :443 | grep LISTEN | grep ':' | awk '{print $5}' | sed 's/::ffff://' | cut -f1 -d ':' | sort | uniq -c | sort -nr | awk '{if($1>5)print$2}' >> BlackList.txt)
   netstat -ntu | grep :443 | grep ESTAB | grep ':' | awk '{print $5}' | sed 's/::ffff://' | cut -f1 -d ':' | sort | uniq -c | sort -nr | awk '{if($1>50)print$2}' > blackhole.txt
   netstat -ntu | grep :443 | grep TIME_WAIT | grep ':' | awk '{print $5}' | sed 's/::ffff://' | cut -f1 -d ':' | sort | uniq -c | sort -nr | awk '{if($1>50)print$2}' >> blackhole.txt
   netstat -ntu | grep :443 | grep FIN_WAIT2 | grep ':' | awk '{print $5}' | sed 's/::ffff://' | cut -f1 -d ':' | sort | uniq -c | sort -nr | awk '{if($1>50)print$2}' >> blackhole.txt
   netstat -ntu | grep :443 | grep FIN_WAIT1 | grep ':' | awk '{print $5}' | sed 's/::ffff://' | cut -f1 -d ':' | sort | uniq -c | sort -nr | awk '{if($1>50)print$2}' >> blackhole.txt
   netstat -ntu | grep :443 | grep LAST_ACK | grep ':' | awk '{print $5}' | sed 's/::ffff://' | cut -f1 -d ':' | sort | uniq -c | sort -nr | awk '{if($1>50)print$2}' >> blackhole.txt
   netstat -ntu | grep :443 | grep SYN_RECV | grep ':' | awk '{print $5}' | sed 's/::ffff://' | cut -f1 -d ':' | sort | uniq -c | sort -nr | awk '{if($1>50)print$2}' >> blackhole.txt
   netstat -ntu | grep :443 | grep LISTEN | grep ':' | awk '{print $5}' | sed 's/::ffff://' | cut -f1 -d ':' | sort | uniq -c | sort -nr | awk '{if($1>50)print$2}' >> blackhole.txt
   #dataip=$(bash iplookup.sh)
   ipblacklist=$(ipset -L blacklist | tail -n +9 | wc -l)
   permblocked=$(ipset -L blackhole | tail -n +9 | wc -l)
   duration=$(( SECONDS - start ))
   timer=$(date -d@$duration -u +Hour:%H:Minute:%M:Second:%S)
   attackdur=$(echo " ")
   bash blackhole.sh
   if [ $Count -gt 10 ]
   then
   bash ipset.sh > log.txt
   Status="\e[0m \033[0;31m Under Attack \033[0;31m \e[0m"
   
   attackdur=$(echo "Attack Duration -> [$timer]")
   else
   Status="\e[0m \033[0;32m Excellent \033[0;32m \e[0m"
   #clear="\033[0m"
   start=$SECONDS
   ipset -F blacklist
   fi
   clear
   echo -e ""
   echo -e "Live Connection -> [$Count]"
   echo -e "IP Blacklist -> [$ipblacklist]"
   echo -e "Perm Blacklist -> [$permblocked]"
   echo -e "Status -> $Status"
   echo -e "$attackdur"
   echo -e ""
   echo -e "$dataip"
   sleep 1
done