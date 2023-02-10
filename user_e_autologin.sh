#! /bin/sh
# Criação do usuário CONSULTAXX
echo "Nome do Usuário?"
read nome

#echo "Defina a senha:"
#read senha

echo "Criando usuário com senha..."
useradd -m $nome 
passwd

echo "Esse Usuário precisa de Autologin? (S/n).."
read autoLogin

if [ $autoLogin == "S" ]; then
    echo "Criando grupo de autologin"
    cp /etc/lightdm/lightdm.conf /etc/lightdm/lightdm.conf.bk
    chmod 777 /etc/lightdm/lightdm.conf
    echo "allow-user-switching=true" >> /etc/lightdm/lightdm.conf
    echo "autologin-user=$nome" >> /etc/lightdm/lightdm.conf
    groupadd -r autologin
    gpasswd -a $nome autologin

    echo "Removendo o acesso ao terminal para o usuário..."
    sudo chmod o=r /usr/bin/xfce4-terminal
fi