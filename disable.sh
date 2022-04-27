#! /bin/sh
# Leia a entrada do usuário
echo "qual é o nome do dispositivo de rede (tipo enp0s...)?"
read nome

echo "qual é IP com /máscara (IP/24 ou IP/8)?"
read IP

echo "qual é o gateway?"
read gateway

echo "qual é o DNS?"
read DNS

#Crie o arquivo em '/etc/systemd/network/' com o nome 20-wired.network e copie as informações que o usuário digitou
echo "[Match]" > /etc/systemd/network/20-wired.network
echo "Name=$nome" >> /etc/systemd/network/20-wired.network

echo >> /etc/systemd/network/20-wired.network
echo "[Network]" >> /etc/systemd/network/20-wired.network

echo "Address=$IP" >> /etc/systemd/network/20-wired.network
echo "Gateway=$gateway" >> /etc/systemd/network/20-wired.network
echo "DNS=$DNS" >> /etc/systemd/network/20-wired.network

#Para parar o serviço do NetworkManager
systemctl stop NetworkManager

#Para iniciar o serviço do systemd-networkd
systemctl start systemd-networkd

#Para desabilitar o serviço do NetworkManager e ativar o systemd-networkd
systemctl disable NetworkManager
systemctl enable systemd-networkd

#Para remover o serviço do NetworkManager
echo "Seu sistema se baseia em que?"
echo "1 Arch"
echo "2 Debian (Ubuntu, linux Mint)"
read qualsistema

if [ $qualsistema == 1  ]; then
# sistemas operacionais baseados no Arch Linux
     pacman -Rc network-manager-applet
else if [ $]
 sistemas operacionais baseados no Debian (Ubuntu, Mint)
     apt-get remove network-manager
fi

echo "Reinicie a máqina"
