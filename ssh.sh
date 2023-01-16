#! /bin/sh
# Alteração da porta do SSH e Habilitação de senha de acesso ao SSH

if  ! command -v ssh & > /dev/null then

    echo "SSH não está instalado na máquina.."
    echo "Voce quer instalar o SSH? (S/n)..."
    read instalSsh
    echo "Seu sistema se baseia em que?"
    echo "1 Arch Base"
    echo "2 Debian base (Ubuntu, linux Mint)"
    read qualsistema
    if [$instalSsh == "S"]; then 
        echo "Instalando SSh ...."
        if [$qualsistema == 1]; then

            pacman -S openssh -y
        else if [$qualsistema == 2];then
            apt-get update && apt-get install openssh-server
        fi
        echo "SSH foi instalado"
    fi
fi

echo "Porta do SSH?"
read porta

echo "Mudando a porta do SSH e habilitando a senha de acesso ao SSH"
cp /etc/ssh/sshd.conf >> /etc/ssh/sshd.conf.bk
echo "Port $porta" >> /etc/ssh/sshd.conf
echo "PermitRootLogin prohibit-password" >> /etc/ssh/sshd.conf

echo "Ativando o serviço do SSH"
systemctl start ssh
systemctl enable ssh