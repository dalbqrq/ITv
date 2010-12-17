#!/bin/bash

#######################################
# Arquivo: client_nagios
# Definição: Script para instalar o cliente de sistema de monitoramento "Nagios"
# Requisitos: Instalação básica do CentOS 5.x
# Versão: 1.1 - 18/01/2010 
# Autor: Ricardo Gomes da Silva
# Email: rgomes@impa.br
#######################################

#NAGIOS_HOST=147.65.1.78
USERNAGIOS=nagios
#UIDNAGIOS=8322
#GROUPNAGIOS=8322
RELEASE=(`cat /etc/issue |awk -F" " '{print $1}'`)

#groupadd -g $GROUPNAGIOS -o $USERNAGIOS
#useradd -u $UIDNAGIOS -g $GROUPNAGIOS -s /bin/false $USERNAGIOS

useradd -s /bin/false $USERNAGIOS

if [ $RELEASE == "CentOS" ]; then
	rpm -ivh /usr/local/itvision/ks/nrpe-2.12-12.el5.x86_64.rpm
	mkdir -p /usr/local/nagios/libexec/
	tar -xzf /usr/local/itvision/ks/plugins.tar.gz -C /usr/local/nagios/libexec/
	chown -R nagios.nagios /usr/local/nagios/

elif [ $RELEASE == "Ubuntu" ]; then
	apt-get install nagios-nrpe-plugin
	apt-get install nagios-plugins
else
	echo "Sistema operacional não reconhecido"
	exit 0
fi
	

sed -i.orig -e "s/nrpe_user=nrpe/nrpe_user=$USERNAGIOS/" \
	-e "s/nrpe_group=nrpe/nrpe_group=$USERNAGIOS/" \
	-e "s/allowed_hosts=127.0.0.1/#allowed_hosts=127.0.0.1/" /etc/nagios/nrpe.cfg

sed -i '/^command/Id' /etc/nagios/nrpe.cfg
sed -i '/^#command/Id' /etc/nagios/nrpe.cfg
cat << EOF >> /etc/nagios/nrpe.cfg
command[check_load]=/usr/local/nagios/libexec/check_load -w 15,10,5 -c 30,25,20
command[check_mem]=/usr/local/nagios/libexec/check_mem -f -w 20 -c 10 -C
command[check_swap]=/usr/local/nagios/libexec/check_swap -w 30% -c 10%
command[check_zombie_procs]=/usr/local/nagios/libexec/check_procs -w 5 -c 10 -s Z
command[check_total_procs]=/usr/local/nagios/libexec/check_procs -w 150 -c 200 
EOF

DISK=(`df -h |awk -F " " '{print $1}' |awk -F "/" '{print $3}' |sed '/^$/d'`)
LINHA=(`wc -l /etc/nagios/nrpe.cfg`)

for ((d = 0 ; d < ${#DISK[@]} ; d++ ))
do
	echo "command[check_${DISK[$d]}]=/usr/local/nagios/libexec/check_disk -w 20% -c 10% -p /dev/${DISK[$d]}" >> /etc/nagios/nrpe.cfg
done


##Firewall
#sed -i -e "/^-A INPUT -i lo -j ACCEPT/a\
#-A INPUT -s $NAGIOS_HOST -p tcp -m tcp --dport 5666 -j ACCEPT" /etc/sysconfig/iptables

chkconfig nrpe on
/etc/init.d/nrpe start


#SUBJECT="Nova Monitacao Nagios $SHNAME"
#EMAIL="netadm@impa.br"
#echo "O servidor $SHNAME foi reinstalado, favor verificar a nova monitoração para os serviços no servidor Magiros" > /tmp/message.txt
#grep ^command nrpe.cfg |awk -F "check" '{print $3}' |sed -e 's/_//g' >> /tmp/message.txt
#/bin/mail -s "$SUBJECT" "$EMAIL" < /tmp/message.txt
#
#rm -f /tmp/message.txt
