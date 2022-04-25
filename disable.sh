#! /bin/sh

echo "qual é o nome da rede?"
read nome

echo "qual é IP com /máscara?"
read IP

echo "qual é o gateway?"
read gateway

echo "qual é o DNS?"
read DNS

echo "[Match]" > /etc/systemd/network/20-wired.network
echo "Name=$nome" > /etc/systemd/network/20-wired.network

echo > /etc/systemd/network/20-wired.network
echo "[Network]" > /etc/systemd/network/20-wired.network

echo "Address=$IP" > /etc/systemd/network/20-wired.network
echo "Gateway=$gateway" > /etc/systemd/network/20-wired.network
echo "DNS=$DNS" > /etc/systemd/network/20-wired.network

systemctl stop NetworkManager
systemctl start systemd-networkd

systemctl disable NetworkManager
systemctl enable systemd-networkd

echo "seu sistema dasea on que?"
echo "1 Arch"
echo "2 Debin (Ubuntu, linux Mint)"
read qual-sistema

if [ $qual-sistema == 1  ]; then
     pacman -Rc network-manager-applet
else
     apt-get uninstall network-manager-applet
fi

echo "Reinicie a máqina"