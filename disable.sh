#! /bin/sh
# Leia a entrada do usuário
echo "qual é o nome do dispositivo de rede (tipo enp0s ...)?"
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

echo "#Desabilitar o IPv6" >> /etc/systemd/network/20-wired.network
echo "IPv6AcceptRA=no" >> /etc/systemd/network/20-wired.network

#Para parar o serviço do NetworkManager
echo  'parando o serviço do NetworkManager .....'
systemctl stop NetworkManager

#Para iniciar o serviço do systemd-networkd
echo 'iniciando o serviço do systemd-networkd ....'
systemctl start systemd-networkd

#Para desabilitar o serviço do NetworkManager e ativar o systemd-networkd
systemctl disable NetworkManager
systemctl enable systemd-networkd

#Para remover o serviço do NetworkManager
echo "Seu sistema se baseia em que?"
echo "1 Arch Base"
echo "2 Debian base (Ubuntu, linux Mint)"
read qualsistema

if [ $qualsistema == 1  ]; then
# sistemas operacionais baseados no Arch Linux
     pacman -Rc network-manager-applet
else if [  $qualsistema == 2 ]
 #  sistemas operacionais baseados no Debian (Ubuntu, Mint)
     apt-get remove network-manager
fi

# Configurando proxy para maquinas consulta integrada.
echo "A maquina é consulta integrada? (S/n);"
read maquina

if [ $maquina == "S" ]; then

     echo "Qual o IP do proxy?"
     read proxyIP
     echo "Qual a porta do proxy?"
     read proxyPort
     touch /etc/profile.d/proxy.sh
     echo "export http_proxy=http://$proxyIP:$proxyPort/" >> /etc/profile.d/proxy.sh
     echo "export https_proxy=$http_proxy" >> /etc/profile.d/proxy.sh
     echo "export ftp_proxy=$http_proxy" >> /etc/profile.d/proxy.sh
     echo 'export no_proxy="localhost,127.0.0.1,localaddress,.localdomain.com"' >> /etc/profile.d/proxy.sh
fi

echo "Reinicie a máquina"
