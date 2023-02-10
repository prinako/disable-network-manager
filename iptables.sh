#! /bin/sh

iptables -A INPUT -p tcp --dport 80 -s 10.7.5.0/26 -j ACCEPT
iptables -A INPUT -p tcp --dport 7283 -s 10.7.5.0/26 -j ACCEPT

iptables -A INPUT -p tcp --dport 80 -j DROP
iptables -A INPUT -p tcp --dport 7283 -j DROP

iptables -N SCANNER
iptables -A SCANNER -m limit --limit 3/m -j LOG --log-level 6 --log-prefix "FW: port scanner: "
iptables -A SCANNER -m recent --name blacklist_60 --set -m comment --comment "Drop/Blacklist Null scan" -j DROP
iptables -A SCANNER -m limit --limit 3/m --limit-burst 5 -j LOG --log-prefix "Firewall> Null scan "
iptables -A SCANNER -m limit --limit 3/m --limit-burst 5 -j LOG --log-prefix "Firewall> XMAS scan "
iptables -A SCANNER -m limit --limit 3/m --limit-burst 5 -j LOG --log-prefix "Firewall> XMAS-PSH scan "
iptables -A SCANNER -m limit --limit 3/m --limit-burst 5 -j LOG --log-prefix "Firewall> XMAS-ALL scan "
# Drop and blacklist for 60 seconds IP of attacker
iptables -A SCANNER -m comment --comment "Drop/Blacklist Xmas/PSH scan" -j DROP # Xmas-PSH scan
iptables -A SCANNER -m comment --comment "Drop/Blacklist Xmas scan" -j DROP # Against nmap -sX (Xmas tree scan)
iptables -A SCANNER -m comment --comment "Drop/Blacklist Xmas/All scan" -j DROP # Xmas All scan


iptables -A SCANNER -j DROP

iptables -A INPUT -p tcp --tcp-flags ALL FIN,URG,PSH -i -j SCANNER
iptables -A INPUT -p tcp --tcp-flags ALL NONE -i -j SCANNER
iptables -A INPUT -p tcp --tcp-flags ALL ALL -i -j SCANNER
iptables -A INPUT -p tcp --tcp-flags ALL FIN,SYN -i -j SCANNER
iptables -A INPUT -p tcp --tcp-flags ALL SYN,RST,ACK,FIN,URG -i -j SCANNER
iptables -A INPUT -p tcp --tcp-flags SYN,RST SYN,RST -i -j SCANNER
iptables -A INPUT -p tcp --tcp-flags SYN,FIN SYN,FIN -i -j SCANNER


iptables-save >> rules.v4
iptables-save >> rules.v6

mv rules.v4 /etc/iptables/
mv rules.v6 /etc/iptables/

systemctl start iptables
systemctl enable iptables

