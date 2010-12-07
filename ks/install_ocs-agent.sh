#!/bin/bash

##########################
# Arquivo install_ocs-agente
#
# INSTALACAO DO ocsinventory-agent - CLIENTE
#
##########################
echo "Insira o ip do servidor ITvision;"
read ADDRESS

OS=(`uname -a |awk -F" " '{print $1}'`)

if [ "$OS" == "Linux" ]; then
        RELEASE=(`cat /etc/issue |awk -F" " '{print $1}'`)
                else if [ "$OS" == "SunOS" ]; then
                REALEASE="SunOS"
                        else
                        echo "Sistema operacional não reconhecido"
                fi
fi

if [ "$RELEASE" == "Ubuntu" ]; then
        INSTALL="/usr/bin/apt-get -y"
        ${INSTALL} install ocsinventory-agent
	/bin/cat << EOF > /etc/ocsinventory/ocsinventory-agent.cfg
basevardir=/var/lib/ocsinventory-agent
server=${ADDRESS}
EOF
		else if [ "$RELEASE" == "CentOS" ]; then
                INSTALL="/usr/bin/yum -y"
		rpm  -ivh  http://download.fedora.redhat.com/pub/epel/5/i386/epel-release-5-3.noarch.rpm
		/usr/bin/yum update
		/usr/bin/yum repolist
		${INSTALL} ocsinventory-agent
		/bin/sed -i.orig -e 's/OCSMODE\[0\]\=none/OCSMODE\[0\]\=cron/' /etc/sysconfig/ocsinventory-agent

                        else
                        echo "Ditribuição não reconhecida"
                fi
fi
