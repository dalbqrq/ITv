#!/bin/bash

#
#URL=http://www.itvision.com.br/ks-files
#pass='itvision'
#dbpass='mttp0c0s'
user=itv


function insta() {
	apt-get -y install $*
}

function restart() {
	invoke-rc.d $1 restart
}


#sed -i.orig -e 's/# deb/deb/g' -e 's/deb cdrom/\#&/g' /etc/apt/sources.list
#apt-get update
#apt-get upgrade
apt-get autoremove

insta openssh-server
insta build-essential
insta locate
insta apache2
insta libapache2-mod-php5
insta libgd2-xpm-dev
insta graphviz
insta unzip
insta wget
insta vim
insta libreadline6-dev
#insta sysutils
insta lua5.1 liblua5.1-0 liblua5.1-0-dev 
insta libcurl3 libmysqlclient15off uuid-dev mysql-common mysql-server 
insta liblua5.1-sql-mysql-dev
insta libmysqlclient15-dev

#
# LUA ROCKS
#
# Do not install it from apt-get. It is broken!
#insta luarocks
wget -P /tmp http://luarocks.org/releases/luarocks-2.0.2.tar.gz
tar zxf /tmp/luarocks-2.0.2.tar.gz -C /usr/src
cd /usr/src/luarocks-2.0.2/
./configure --prefix=/usr --sysconfdir=/etc/luarocks --with-lua-include=/usr/include/lua5.1
make
make install

#
# LUA COMPONENTS
#
luarocks install wsapi
luarocks install cgilua
luarocks install orbit
luarocks install cosmo
#luarocks install wsapi-xavante
#luarocks install markdown

#
# LUA PAGES PATH CONFIG
#
#cat << EOF > /tmp/bashrc
#
#PATH=\$PATH:/usr/local/itvision/bin
#export LUA_PATH="/usr/local/itvision/model/?.lua;/usr/local/itvision/view/?.lua;/usr/local/itvision/controler/?.lua;/usr/local/itvision/model/db/?.lua;/usr/local/itvision/www/?.lua;/usr/local/itvision/daemon/?.lua;\$LUA_PATH"
#EOF
#
#cat /tmp/bashrc >> /root/.bashrc
#cat /tmp/bashrc >> /home/itvision/.bashrc



#  
# NAGIOS
#
url=http://prdownloads.sourceforge.net/sourceforge

nagver=3.2.1
wget -P /tmp $url/nagios/nagios-$nagver.tar.gz
tar zxf /tmp/nagios-$nagver.tar.gz -C /usr/local/src

#plgver=1.4.14
#wget -P /tmp $url/nagiosplug/nagios-plugins-$plgver.tar.gz
#tar zxf /tmp/nagios-plugins-$plgver.tar.gz -C /usr/local/src

urlitiv=http://itiv.atmatec.com.br/ks-files
wget -P /tmp $urlitiv/nagios-$nagver-itiv.tgz
tar zxf /tmp/nagios-3.2.1-itiv.tgz -C /usr/local/src


cd /usr/local/src/nagios-$nagver
./configure \
	--prefix=/usr/local/monitor \
	--with-nagios-user=$user \
	--with-nagios-group=$user \
	--with-command-user=$user \
	--with-command-group=$user \
	--with-htmurl=/monitor \
	--with-cgiurl=/monitor/cgi-bin \
	--with-httpd-conf=/etc/apache2/sites-available \
	--enable-event-broker


make all
make fullinstall
make install-config
make install-webconf

htpasswd -cb /usr/local/monitor/etc/htpasswd.users $user $user
chown $user.$user /usr/local/monitor/etc/htpasswd.users
sed -i.orig -e "s/nagiosadmin/$user/g" /usr/local/monitor/etc/cgi.cfg

cd /usr/local/monitor
for f in `grep nagiosadmin */* */*/* | cut -d: -f1 | sort | uniq`; do
	sed -i.orig -e "s/nagiosadmin/$user/g" $f
done

/usr/sbin/usermod -a -G $user www-data

insta nagios-plugins
insta nagios-nrpe-plugin nagios-nrpe-server
mv libexec libexec.orig
ln -s /usr/lib/nagios/plugins/ libexec

cd /usr/local/monitor/etc
mkdir orig
mv *.orig nagios.cfg objects/* orig
wget $urlitiv/nagios-config.tgz
tar zxf nagios-config.tgz
chown -R $user.users /usr/local/monitor/etc



# 
# NDO UTILS - Nagios
#
#wget -P /tmp http://prdownloads.sourceforge.net/sourceforge/nagios/ndoutils-1.4b9.tar.gz
insta ndoutils-nagios3-mysql ndoutils-common ndoutils-doc
#
# CORRIGIR ESTAS CONFIGS
#
#cp ndo*.cfg /usr/local/monitor/etc
#
#sed -e '/broker_module=\/somewhere\/module2/a  \
#broker_module=@bindir@/ndomod-3x.o config_file=@sysconfdir@/ndomod.cfg # MUDAR AQUI!!!
#' /usr/local/monitor/etc/nagios.cfg

#
# BUSINESS PROCESS
#
bp=monitorbp
insta libcgi-simple-perl
wget -P /tmp https://www.nagiosforge.org/gf/download/frsrelease/154/411/nagios-business-process-addon-0.9.5.tar.gz
tar zxf /tmp/nagios-business-process-addon-0.9.5.tar.gz -C /usr/local/src
cd /usr/local/src/nagios-business-process-addon-0.9.5

./configure --prefix=/usr/local/$bp --with-nagiosbp-user=itiv --with-nagiosbp-group=itiv --with-nagetc=/usr/local/monitor/etc --with-naghtmurl=/monitor --with-nagcgiurl=/monitor/cgi-bin --with-htmurl=/$bp --with-cgiurl=/$bp/cgi-bin
make all
make install
mv /usr/local/monitor/share/site.php /usr/local/monitor/side.php.orig
cp ~/site.php /usr/local/monitor/share





###
### APACHE
###
cd /etc/apache2/
#wget -P ./sites-available $URL/itvision.conf
cp ~/itvision.conf ./sites-available
cd ./sites-enabled
rm -f ./000-default
sed -i -e "s/Nagios/ITVision Monitor/g" ../sites-available/nagios.conf
ln -s ../sites-available/itvision.conf 100-itvision
ln -s ../sites-available/nagios.conf 001-nagios

mkdir -p /usr/local/itvision/www
chown -R $user.$user /usr/local/itvision






#####  ATÉ AQUI  #####
insta ndoutils-nagios3-mysql ndoutils-common ndoutils-doc

#
# EDITAR nagios.cfg
#

# 
# NSCA - Nagios
#
cd /usr/local/src
wget http://prdownloNSCAads.sourceforge.net/sourceforge/nagios/nsca-2.7.2.tar.gz
tar zxf nsca-2.7.2.tar.gz
cd nsca-2.7.2
./configure --prefix=/usr/local/monitor  --with-nsca-user=$user --with-nsca-grp=$user --with-nsca-port=5555
# FALTA INSTALAR!!!



#
# BUSINESS PROCESS - NAgios
#
wget https://www.nagiosforge.org/gf/download/frsrelease/138/316/nagios-business-process-addon-0.9.3.tar.gz
tar zxf nagios-business-process-addon-0.9.3.tar.gz
cd nagios-business-process-addon-0.9.3
./configure --prefix=/usr/local/monitor --with-ndo2db-user=$user --with-ndo2db-group=$user 
make all
make install-init

echo "CREATE DATABASE $user;" | mysql -u root --password=$dbpass
echo "CREATE USER '$user'@'localhost' IDENTIFIED BY '$dbpass';" | mysql -u root --password=$dbpass mysql
echo "GRANT ALL PRIVILEGES ON *.* TO '$user'@'localhost' WITH GRANT OPTION;" | mysql -u root --password=$dbpass mysql
./db/installdb -u $user -p mttp0c0s -h localhost -d $user
cp src/ndomod-3x.o /usr/local/monitor/bin/ndomod.o
sed -e "s/nagios/monitor/g" config/ndomod.cfg > /usr/local/monitor/etc/ndomod.cfg
cat << EOF >> /usr/local/monitor/etc/nagios.cfg 

#
# NDO
#
broker_module=/usr/local/monitor/bin/ndomod.o config_file=/usr/local/monitor/etc/ndomod.cfg

EOF
cp src/ndo2db-3x /usr/local/monitor/bin/ndo2db
#cp config/ndo2db.cfg /usr/local/itvision/etc
sed -e "s/=nagios$/=$user/g" -e "s/nagios/itvision_monitor/g" -e "s/ndouser/$user/g" -e "s/ndopassword/$user/g" -e "s/monitor_/nagios_/g" config/ndo2db.cfg > /usr/local/monitor/etc/ndo2db.cfg

sed -i -e "/Starting /a \
     \/usr\/local\/monitor\/bin\/ndo2db -c \/usr\/local\/monitor\/etc\/ndo2db.cfg
" /etc/init.d/nagios

sed -i -e "/Stopping /a \
     killall ndo2db
" /etc/init.d/nagios


#
# ITVision
#
VERSION=0.2.5
wget -P /tmp $URL/itvision-$VERSION.tgz
tar zxf /tmp/itvision-$VERSION.tgz -C /usr/local
chown -R itvision.users /usr/local/itvision
chown www-data /usr/local/itvision/www/figs


#
# MAIL
#
email=alert@itvision.com.br
pass=serserfm

##################################
### FROM: http://ez.no/developer/forum/install_configuration/sending_mail_via_gmail_or_google_apps_smtp

insta ssmtp mailx stunnel4

mv /etc/ssmtp/ssmtp.conf /etc/ssmtp/ssmtp.conf.orig
cat << EOF > /etc/ssmtp/ssmtp.conf
#
# ssmtp.conf
#
#
# GOOGLE APPS ACCOUNT 
#
root=alert@itvision.com.br
mailhub=smtp.gmail.com:587
rewriteDomain=
hostname=alert@itvision.com.br
UseSTARTTLS=YES
AuthUser=alert@itvision.com.br
AuthPass=serserfm
FromLineOverride=YES
#
# GMAIL (STANDARD) ACCOUNT
#
# root=daniel.dalb@gmail.com
# mailhub=smtp.gmail.com:587
# rewriteDomain=
# hostname=daniel.dalb@gmail.com
# UseSTARTTLS=YES
# AuthUser=daniel.dalb
# AuthPass=0tucamis
# FromLineOverride=YES
EOF

cd /etc/stunnel
mv stunnel.conf stunnel.conf_
cat << EOF > gmail-smtp.conf
; Use it for client mode
client = yes
; Service-level configuration
[ssmtp]
accept = 1925
connect = smtp.gmail.com:465
EOF

sed -i -e "s/ENABLED=0/ENABLED=1/g" /etc/default/stunnel4
restart stunnel4
### 
### To test ssmtp with stunnel4 run: 
###    telnet localhost 1925
###    echo test | mail -s "test ssmtp" daniel.dalb@gmail.com
###






#
# FIM
#
insta autoremove


