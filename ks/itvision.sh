#!/bin/bash
# --------------------------------------------------
# ITvision MONITOR INSTALL for Ubuntu 10.04.1
# --------------------------------------------------

user=itv
dbpass=itv
dbuser=$user
dbname=itvision
itvhome=/usr/local/itvision
instance=ROOT
hostname=itvision

function install_pack() {
	apt-get -y install $1
}

function install_msg() {
	sep=`for _ in \`seq 60\`; do echo -n "-"; done;`
	echo $sep; echo Configurando $1 ...; echo $sep; echo
	sleep 3
}

sed -i -e "s/`hostname`/$hostname/g" /etc/hosts; echo $hostname > /etc/hostname; hostname --file /etc/hostname



# --------------------------------------------------
# INSTALL UBUNTU NATIVE PACKAGES VIA apt-get
# --------------------------------------------------
apt-get -y update
apt-get -y upgrade

install_pack openssh-server
install_pack build-essential
install_pack locate
install_pack apache2 
install_pack libapache2-mod-php5
install_pack libgd2-xpm-dev
install_pack graphviz
install_pack graphviz-dev
install_pack unzip
install_pack wget
install_pack vim
install_pack ntp
install_pack ksh # script caldate
install_pack libreadline6-dev
install_pack lua5.1
install_pack liblua5.1-0
install_pack liblua5.1-0-dev
install_pack luarocks
install_pack libcurl3
install_pack uuid-dev
install_pack mysql-common
install_pack mysql-server
install_pack liblua5.1-sql-mysql-dev
install_pack git-core
install_pack nagios3
install_pack nagios-nrpe-plugin
install_pack nagios-nrpe-server
install_pack ndoutils-nagios3-mysql
install_pack php5-mysql # OCSNG - NEDI
install_pack perl # OCSNG
install_pack libapache2-mod-perl2 # OCSNG
install_pack libxml-simple-perl # OCSNG
install_pack libcompress-zlib-perl # OCSNG
install_pack libdbi-perl # OCSNG
install_pack libdbd-mysql-perl # OCSNG
install_pack libcgi-simple-perl # OCSNG
install_pack php5 # OCSNG
install_pack php5-gd # OCSNG - NEDI
install_pack php5-ldap
install_pack php5-imap
install_pack libapache-dbi-perl # OCSNG
install_pack libnet-ip-perl # OCSNG
install_pack libsoap-lite-perl # OCSNG
install_pack libc6-dev # OCSNG
install_pack libcalendar-simple-perl
install_pack autoconf
install_pack snmpd
#install_pack cacti
install_pack libgd-gd2-perl
install_pack perlmagick
install_pack librrds-perl
install_pack nagiosgrapher
install_pack libnet-snmp-perl  # NEDI
install_pack libnet-telnet-cisco-perl # NEDI
install_pack php5-snmp # NEDI
install_pack libalgorithm-diff-perl # NEDI
install_pack rrdtool # NEDI
install_pack mbrola # Synthesizing Voice
install_pack mrbrola-br3 # Synthesizing Voice
install_pack festival # Synthesizing Voice


# --------------------------------------------------
# STOP ALL PROCESSES
# --------------------------------------------------
/usr/sbin/invoke-rc.d ndoutils stop
/usr/sbin/invoke-rc.d nagios3 stop
/usr/sbin/invoke-rc.d nagios-nrpe-server stop
/usr/sbin/invoke-rc.d apache2 stop
/usr/sbin/invoke-rc.d nagiosgrapher stop
rm -rf /var/cache/nagios3/ndo.sock

exit

# --------------------------------------------------
# ITVISION
# --------------------------------------------------
install_msg ITVISION
echo "CREATE DATABASE $dbname DEFAULT CHARACTER SET utf8  DEFAULT COLLATE utf8_general_ci;" | mysql -u root --password=$dbpass
echo "CREATE USER '$dbuser'@'localhost' IDENTIFIED BY '$dbpass';" | mysql -u root --password=$dbpass
echo "GRANT ALL PRIVILEGES ON *.* TO '$dbuser'@'localhost' WITH GRANT OPTION;" | mysql -u root --password=$dbpass
mysql -u root --password=$dbpass $dbname < $itvhome/ks/db/itvision.sql
mkdir -p /var/log/itvision/apache2
mkdir -p /var/log/itvision/nagios3
mkdir -p /var/log/itvision/nagiosgrapher
chown -R $user.$user /var/log/itvision
chmod -R 755 /var/log/itvision
cat << EOF > /etc/apache2/conf.d/itvision.conf
<VirtualHost *:80>
        ServerAdmin webmaster@itvision.com.br

        DocumentRoot $itvhome/html
        <Directory "$itvhome/html">
                Options Indexes FollowSymLinks MultiViews
                AllowOverride None
                Order allow,deny
                allow from all
        </Directory>

        ScriptAlias /orb $itvhome/orb
        <Directory "$itvhome/orb">
                AllowOverride None
                Options +ExecCGI +MultiViews +SymLinksIfOwnerMatch FollowSymLinks
                Order allow,deny
                Allow from all
        </Directory>

        # Possible values: debug, info, notice, warn, error, crit,
        # alert, emerg.
        LogLevel warn

        ErrorLog /var/log/apache2/itvision_error.log
        CustomLog /var/log/apache2/itvision_access.log combined

</VirtualHost>
EOF

cat << EOF > $itvhome/orb/config.lua
module("config", package.seeall)

app_name = "ITvision"

database = {
        instance_id = 1,
        instance_name = "$instance",
        dbname = "$dbname",
        dbuser = "$dbuser",
        dbpass = "$dbpass",
        driver = "mysql",
}

monitor = {
        dir        = "/etc/nagios3",
        bp_dir     = "/usr/local/nagiosbp",
        script     = "/etc/init.d/nagios3",
        bp_script  = "/etc/init.d/ndoutils",
        bp2cfg     = "bp2cfg",
        check_host = "HOST_ALIVE",
        check_app  = "BUSPROC_HOST",
        cmd_app    = "BUSPROC_STATUS",
}

view = {
	-- GERAR NOVA CHAVE EM: http://code.google.com/apis/maps/signup.html
        google_maps_key = "ABQIAAAAsqOIUfpoX_G_Pw0Ar48BRhRtyMmS1TXEK_DXFnd23B1n8zvUnRT_9hDq4-PHCmE33vrSdHVrdUyjgw" --itv.impa.br
}

path = {
        itvision = "$itvhome",
}

language = "pt_BR"
EOF
chown -R $user.$user $itvhome/orb/config.lua


cd /home/$user
ln -s $itvhome itv
ln -s $itvhome/bin
chown -R $user.$user itv
chown -R $user.$user bin

cat << EOF > $itvhome/bin/dbconf
dbuser=$dbuser
dbpass=$dbpass
dbname=$dbname
EOF

mkdir $itvhome/html/gv
printf "html/gv\norb/config.lua\nbin/dbconf\nbin/lua_path\n" >> $itvhome/.git/info/exclude

sed -i -e 's/ErrorLog \/var\/log\/apache2\/error.log/ErrorLog \/var\/log\/itvision\/apache2\/error.log/g' \
	-e 's/CustomLog \/var\/log\/apache2\/other_vhosts_access.log/CustomLog \/var\/log\/itvision\/apache2\/other_vhosts_access.log/g' /etc/apache2/apache2.conf


echo "INSERT INTO itvision.itvision_apps set instance_id = 1, entities_id = 0, name = 'ROOT';" | mysql -u root --password=$dbpass
echo "INSERT INTO itvision.itvision_app_trees set instance_id = 1, app_id = (select id from itvision_apps where name = 'ROOT' and is_active = 0), lft = 1, rgt = 2;"  | mysql -u root --password=$dbpass $dbname
echo "INSERT INTO itvision.itvision_app_relat_types VALUES (1,'roda em','logical'),(2,'conectado a','physical'),(3,'usa','logical'),(4,'faz backup em','logical');" | mysql -u root --password=$dbpass $dbname





# --------------------------------------------------
# NAGIOS
# --------------------------------------------------
install_msg NAGIOS

htpasswd -cb /etc/nagios3/htpasswd.users $user $dbpass
sed -i.orig -e "s/nrpe_user=nagios/nrpe_user=$user/" \
	-e "s/nrpe_group=nagios/nrpe_group=$user/" \
	-e "s/allowed_hosts=127.0.0.1/#allowed_hosts=127.0.0.1/" /etc/nagios/nrpe.cfg
sed -i.orig -e "s/www-data/$user/g" /etc/apache2/envvars
sed -i.orig -e "s/nagiosadmin/$user/g" /etc/nagios3/cgi.cfg
sed -i 's/url_html_path=\/nagios3/url_html_path=\/monitor/' /etc/nagios3/cgi.cfg
sed -i.orig -e "s/nagios_user=nagios/nagios_user=$user/" \
	-e "s/nagios_group=nagios/nagios_group=$user/" \
	-e "s/check_external_commands=0/check_external_commands=1/" \
	-e "s/admin_email=root@localhost/admin_email=webmaster@itvision.com.br/" \
	-e "s/log_file=\/var\/log\/nagios3\/nagios.log/log_file=\/var\/log\/itvision\/nagios3\/nagios.log/" \
	-e "s/log_archive_path=\/var\/log\/nagios3\/archives/log_archive_path=\/var\/log\/itvision\/nagios3\/archives/" \
	-e "s/admin_pager=pageroot@localhost/#admin_pager=pageroot@localhost/" \
	-e "/conf.d/a \\
cfg_dir=/etc/nagios3/hosts \\
cfg_dir=/etc/nagios3/apps \\
cfg_dir=/etc/nagios3/services \\
cfg_dir=/etc/nagios3/contacts" /etc/nagios3/nagios.cfg
sed -i.orig -e "s/chown nagios:nagios/chown $user:root/" /etc/init.d/nagios3
sed -i.orig -e "s/chown nagios/chown $user/" /etc/init.d/nagios-nrpe-server
sed -i.orig -e "s/\/cgi-bin\/nagios3/\/cgi-bin\/monitor/" \
	-e "s/\/nagios3\/cgi-bin/\/monitor\/cgi-bin/" \
	-e "s/\/nagios3\/stylesheets/\/monitor\/stylesheets/"
	-e "s/\/nagios3/\/monitor/" /etc/nagios3/apache2.conf


mkdir -p /etc/nagios3/orig/conf.d /etc/nagios3/hosts /etc/nagios3/services /etc/nagios3/apps /etc/nagios3/contacts
mv /etc/nagios3/*.orig /etc/nagios3/orig
mv /etc/nagios3/conf.d/* /etc/nagios3/orig/conf.d
cp $itvhome/ks/files/conf.d/* /etc/nagios3/conf.d

# rename plugins
dir=/etc/nagios-plugins/config
cp -r $dir $dir".orig"

for f in $dir/*; do
sed -i -e 's/check-rpc/check_rpc/g' -e 's/check-nfs/check_nfs/g' \
	-e 's/traffic_average/\U&/' \
	-e 's/ssh_disk/\U&/' \
	-e 's/ check_.*/\U&/' -e 's/\tcheck_.*/\U&/' -e 's/CHECK_//g' \
	-e 's/ snmp_.*/\U&/' -e 's/\tsnmp_.*/\U&/' $f
done

sed -i.orig -e "s/check_pop -H/check_pop -p 100 -H/g" $dir/mail.cfg
sed -i.orig -e "s/check_imap -H/check_imap -p 143 -H/g" $dir/mail.cfg
cp $itvhome/ks/files/plugin.d/* $dir

ln -s /usr/lib/cgi-bin/nagios3 monitor; chown -R netadm.netadm /usr/lib/cgi-bin/monitor
ln -s /etc/nagios3 monitor ;chown -R netadm.netadm /etc/monitor
ln -s /usr/share/nagios3 monitor ; chown -R netadm.netadm /usr/share/monitor

data=`date +%d%m%Y`
read $1
user=$1

sed -i.bkp.$data 's/url_html_path=\/nagios3/url_html_path=\/monitor/' /etc/nagios3/cgi.cfg
cd /etc/apache2/conf.d
rm -f nagios3.conf
ln -s /etc/nagios3/apache2.conf monitor.conf
chown -R itvision.itvision monitor.conf
mv /etc/nagios3/apache2.conf /etc/nagios3/apache2.conf.bkp.$date
cat <<EOF > /etc/nagios3/apache2.conf
# apache configuration for nagios 3.x
# note to users of nagios 1.x and 2.x:
#       throughout this file are commented out sections which preserve
#       backwards compatibility with bookmarks/config for older nagios versios.
#       simply look for lines following "nagios 1.x:" and "nagios 2.x" comments.

ScriptAlias /cgi-bin/monitor /usr/lib/cgi-bin/nagios3
ScriptAlias /monitor/cgi-bin /usr/lib/cgi-bin/nagios3

# Where the stylesheets (config files) reside
Alias /monitor/stylesheets /etc/nagios3/stylesheets

# Where the HTML pages live
Alias /monitor /usr/share/nagios3/htdocs

<DirectoryMatch (/usr/share/nagios3/htdocs|/usr/lib/cgi-bin/monitor|/etc/nagios3/stylesheets)>
        Options FollowSymLinks

        DirectoryIndex index.php

        AllowOverride AuthConfig
        Order Allow,Deny
        Allow From All

        AuthName "Nagios Access"
        AuthType Basic
        AuthUserFile /etc/nagios3/htpasswd.users
        # nagios 1.x:
        #AuthUserFile /etc/nagios/htpasswd.users
        require valid-user
</DirectoryMatch>
EOF

sed -i.bkp.$data -e "s/\/cgi-bin\/nagios3/cgi-bin\/monitor/" /usr/share/nagios3/htdocs
sed -i.bkp.$data -e 's/nagios3/monitor/' /usr/share/nagios3/htdocs/graphs.html




# --------------------------------------------------
# NAGIOSGRAPHER
# --------------------------------------------------
install_msg NAGIOSGRAPHER

sed -i.orig2 -e "s/process_performance_data=0/process_performance_data=1/" \
    -e "s/^#service_perfdata_command=process-service-perfdata/service_perfdata_command=ngraph-process-service-perfdata-pipe/" /etc/nagios3/nagios.cfg


sed -i.orig -e "s/user                    nagios/user                    $user/" \
        -e "s/group                   nagios/group                   $user/" \
	-e "s/serviceextinfo          \/etc\/nagios3\/serviceextinfo.cfg/serviceextinfo          \/etc\/nagios3\/conf.d\/serviceextinfo.cfg/" \
	-e "s/serviceext_path         \/etc\/nagiosgrapher\/nagios3\/serviceext/serviceext_path         \/etc\/nagios3\/services/" \
	-e "s/\/var\/log\/nagiosgrapher\/ngraph.log/\/var\/log\/itvision\/nagiosgrapher\/ngraph.log/" \
        -e "s/nagiosadmin/$user/" /etc/nagiosgrapher/ngraph.ncfg


chown -R $user.$user /var/lib/nagiosgrapher /etc/nagiosgrapher /var/run/nagiosgrapher /var/log/itvision/nagiosgrapher /var/cache/nagiosgrapher /usr/share/perl5/NagiosGrapher /usr/lib/nagiosgrapher /usr/sbin/nagiosgrapher
cat /etc/nagiosgrapher/nagios3/commands.cfg >> /etc/nagios3/commands.cfg 
rm -f /etc/nagiosgrapher/nagios3/commands.cfg
echo '<HTML><HEAD><META http-equiv="REFRESH" content="0;url=/nagios3/cgi-bin/graphs.cgi"></HEAD></HTML>'  > /usr/share/nagios3/htdocs/graphs.html
mkdir -p /etc/nagiosgrapher/ngraph.d/itvision
cp /etc/nagiosgrapher/ngraph.d/standard/check_ping.ncfg /etc/nagiosgrapher/ngraph.d/standard/check_host_alive.ncfg
sed -i "s/PING/HOST_ALIVE/g" /etc/nagiosgrapher/ngraph.d/standard/check_host_alive.ncfg

echo << EOF > /usr/share/nagios3/htdocs/grapher.html
<html><head>
<meta http-equiv="REFRESH" content="0;url=/nagios3/cgi-bin/graphs.cgi">
</HEAD></HTML>
EOF

sed -i.orig -e "s/NagiosGrapher by NETWAYS GMBH/ITvision/g" /usr/lib/cgi-bin/nagiosgrapher/rrd2-system.cgi

# --------------------------------------------------
# NDO UTILS - Nagios
# --------------------------------------------------
install_msg NDOUTILS

chown -R $user.$user /etc/nagios3/ndomod.cfg /etc/nagios3/ndo2db.cfg /usr/lib/ndoutils /etc/init.d/ndoutils


sed -i.orig -e "s/ nagios / $user /g" /etc/init.d/ndoutils
sed -i.orig -e '/# LOG ROTATION METHOD/ i\
broker_module=/usr/lib/ndoutils/ndomod-mysql-3x.o config_file=/etc/nagios3/ndomod.cfg' /etc/nagios3/nagios.cfg
sed -i.orig -e "s/ndo2db_group=nagios/ndo2db_group=$user/" \
	-e "s/ndo2db_user=nagios/ndo2db_user=$user/" \
	-e "s/db_name=ndoutils/db_name=$dbname/" \
	-e "s/^db_user=ndoutils/db_user=$dbuser/" \
	-e "s/\/\//\//g" /etc/nagios3/ndo2db.cfg
sed -i.orig -e "s/\/\//\//g" -e "s/instance_name=.*/instance_name=$instance/g" /etc/nagios3/ndomod.cfg
sed -i.orig -e 's/ENABLE_NDOUTILS=0/ENABLE_NDOUTILS=1/' /etc/default/ndoutils

mysqldump -u root --password=$dbpass -v ndoutils > /tmp/ndoutils.sql
mysql -u root --password=$dbpass $dbname < /tmp/ndoutils.sql
echo "DROP DATABASE ndoutils;" | mysql -u root --password=$dbpass

chown -R $user.$user /var/log/itvision/nagios3 /etc/init.d/nagios-nrpe-server /etc/init.d/nagios3 /etc/nagios3 /etc/nagios /etc/nagios-plugins /var/run/nagios /var/run/nagios3 /usr/lib/nagios /usr/sbin/log2ndo /usr/lib/nagios3 /etc/apache2 /var/cache/nagios3 /var/lib/nagios /var/lib/nagios3 /usr/share/nagios3/ /usr/lib/cgi-bin/nagios3 
chown root.netadm /usr/lib/nagios/plugins/check_dhcp
chmod 4750 /usr/lib/nagios/plugins/check_dhcp



# --------------------------------------------------
# BUSINESS PROCESS
# --------------------------------------------------
install_msg NAGIOS BUSINESS PROCESS

bp=nagiosbp
tar zxf $itvhome/ks/files/nagiosbp-0.9.5.tgz -C /usr/local/src
cd /usr/local/src/nagios-business-process-addon-0.9.5
./configure --prefix=/usr/local/$bp --with-nagiosbp-user=$user --with-nagiosbp-group=$user --with-nagetc=/etc/nagios3 --with-naghtmurl=/nagios3 --with-nagcgiurl=/cgi-bin/nagios3 --with-htmurl=/$bp --with-apache-user=$user
make install
cat << EOF > /usr/local/$bp/etc/ndo.cfg
# Nagios Business Process
# backend
ndo=db
ndodb_host=localhost
ndodb_port=3306
ndodb_database=$dbname
ndodb_username=$dbuser
ndodb_password=$dbpass
ndodb_prefix=nagios_
# common settings
cache_time=0
cache_file=/usr/local/$bp/var/cache/ndo_backend_cache
# unused but must be here with dummy values
ndofs_basedir=/usr/local/ndo2fs/var
ndofs_instance_name=default
ndo_livestatus_socket=/usr/local/nagios/var/rw/live
EOF
mkdir /usr/local/$bp/etc/sample
sed -i.orig -e "s/generic-bp-service/BUSPROC_SERVICE/g" -e "s/generic-bp-detail-service/BUSPROC_SERVICE_DESABLED/g" -e "s/check_bp_status/BUSPROC_STATUS/g" /usr/local/nagiosbp/bin/bp_cfg2service_cfg.pl
cat << EOF > $itvhome/bin/bp2cfg
#!/bin/bash
/usr/local/$bp/bin/bp_cfg2service_cfg.pl -o /etc/nagios3/apps/apps.cfg
EOF
chmod 755 $itvhome/bin/bp2cfg
chown $user.$user /usr/local/$bp/etc/ndo.cfg $itvhome/bin/bp2cfg

sed -i.orig -e "139a \\
  <tr> \\
    <td width=13><img src=\"images/greendot.gif\" width=\"13\" height=\"14\" name=\"statuswrl-dot\"></td> \\
    <td nowrap><a href=\"/nagiosbp/cgi-bin/nagios-bp.cgi\" target=\"main\" onMouseOver=\"switchdot('statuswrl-dot',1)\" onMouseOut=\"switchdot('statuswrl-dot',0)\" class=\"NavBarItem\">Business Process View</a></td> \\
  </tr> \\
  <tr> \\
    <td width=13><img src=\"images/greendot.gif\" width=\"13\" height=\"14\" name=\"statuswrl-dot\"></td> \\
    <td nowrap><a href=\"/nagiosbp/cgi-bin/nagios-bp.cgi?mode=bi\" target=\"main\" onMouseOver=\"switchdot('statuswrl-dot',1)\" onMouseOut=\"switchdot('statuswrl-dot',0)\" class=\"NavBarItem\">Business Impact</a></td> \\
  </tr>" /usr/share/nagios3/htdocs/side.php



# --------------------------------------------------
# GLPI
# --------------------------------------------------
install_msg GLPI

wget -P /tmp https://forge.indepnet.net/attachments/download/656/glpi-0.78.tar.gz
tar zxf /tmp/glpi-0.78.tar.gz -C /usr/local
mv /usr/local/glpi /usr/local/servdesk
tar zxf /tmp/glpi-0.78.tar.gz -C /usr/local
chown -R $user.$user /usr/local/glpi /usr/local/servdesk

echo "<?php
 class DB extends DBmysql {
 var \$dbhost    = 'localhost';
 var \$dbuser    = '$dbuser';
 var \$dbpassword= '$dbpass';
 var \$dbdefault = '$dbname';
 }
?>" > /usr/local/servdesk/config/config_db.php
chmod 600 /usr/local/servdesk/config/config_db.php
chown $user.$user /usr/local/servdesk/config/config_db.php

echo "Alias /servdesk "/usr/local/servdesk"
<Directory "/usr/local/servdesk">
    Options None
    AllowOverride None
    Order allow,deny
    Allow from all
</Directory>"  >> /etc/apache2/conf.d/servdesk.conf

echo "Alias /glpi "/usr/local/glpi"
<Directory "/usr/local/glpi">
    Options None
    AllowOverride None
    Order allow,deny
    Allow from all
</Directory>"  >> /etc/apache2/conf.d/glpi.conf

if [ -z "$migra_glpi" ]; then
    cp -a /usr/local/servdesk/config/config_db.php /usr/local/glpi/config/config_db.php
    cp $itvhome/ks/db/glpi.sql.gz /tmp
    gunzip /tmp/glpi.sql.gz
    mysql -u $dbuser --password=$dbpass $dbname < /tmp/glpi.sql
fi     

cd $itvhome/ks/servdesk
tar cf - * | ( cd /usr/local/servdesk; tar xfp -)


echo "ALTER TABLE itvision.glpi_computers ADD COLUMN geotag VARCHAR(40) NULL DEFAULT NULL AFTER ticket_tco ;" | mysql -u root --password=$dbpass
echo "ALTER TABLE itvision.glpi_computers ADD COLUMN alias VARCHAR(30) NULL DEFAULT NULL AFTER ticket_tco ;" | mysql -u root --password=$dbpass
echo "ALTER TABLE itvision.glpi_computers ADD COLUMN itv_key VARCHAR(30) NULL DEFAULT NULL AFTER ticket_tco ;" | mysql -u root --password=$dbpass
echo "ALTER TABLE itvision.glpi_networkequipments ADD COLUMN geotag VARCHAR(40) NULL DEFAULT NULL AFTER ticket_tco ;" | mysql -u root --password=$dbpass
echo "ALTER TABLE itvision.glpi_networkequipments ADD COLUMN alias VARCHAR(30) NULL DEFAULT NULL AFTER ticket_tco ;" | mysql -u root --password=$dbpass
echo "ALTER TABLE itvision.glpi_networkequipments ADD COLUMN itv_key VARCHAR(30) NULL DEFAULT NULL AFTER ticket_tco ;" | mysql -u root --password=$dbpass
echo "ALTER TABLE itvision.glpi_profiles ADD COLUMN app_relat_type CHAR(1) NULL DEFAULT NULL AFTER create_validation ;" | mysql -u root --password=$dbpass
echo "ALTER TABLE itvision.glpi_profiles ADD COLUMN checkcmds      CHAR(1) NULL DEFAULT NULL AFTER create_validation ;" | mysql -u root --password=$dbpass
echo "ALTER TABLE itvision.glpi_profiles ADD COLUMN application    CHAR(1) NULL DEFAULT NULL AFTER create_validation ;" | mysql -u root --password=$dbpass

 
# --------------------------------------------------
# OCS INVENTORY v1.3.2
# --------------------------------------------------
install_msg OCS INVENTORY

wget -P /tmp http://launchpad.net/ocsinventory-server/stable-1.3/1.3.2/+download/OCSNG_UNIX_SERVER-1.3.2.tar.gz
tar -xzf /tmp/OCSNG_UNIX_SERVER-1.3.2.tar.gz -C /usr/local
cd /usr/local/OCSNG_UNIX_SERVER-1.3.2

sed -i.orig -e "s/DB_SERVER_USER=\"ocs\"/DB_SERVER_USER=\"$user\"/" \
        -e "s/DB_SERVER_PWD=\"ocs\"/DB_SERVER_PWD=\"$dbpass\"/" /usr/local/OCSNG_UNIX_SERVER-1.3.2/setup.sh

#perl -MCPAN -e 'install XML::Entities'
cpan -i XML::Entities
cpan -i YAML 
\rm -f /tmp/ans; for i in `seq 16`; do echo >> /tmp/ans; done
/usr/local/OCSNG_UNIX_SERVER-1.3.2/setup.sh < /tmp/ans

sed -i -e "s/Alias \/ocsreports/Alias \/ocs/g" /etc/apache2/conf.d/ocsinventory-reports.conf



# --------------------------------------------------
# NEDI
# --------------------------------------------------
install_msg NEDI

cd /tmp
wget http://nedi.ch/_media/files:nedi-1.0.5.tgz
mv files:nedi-1.0.5.tgz nedi-1.0.5.tgz
tar -xzf nedi-1.0.5.tgz
mv nedi /usr/local
chown -R $user.$user /usr/local/nedi
chmod 775 /usr/local/nedi/html/log/

echo "Alias /nedi "/usr/local/nedi"
<Directory "/usr/local/nedi/html/">
    Options None
    AllowOverride None
    Order allow,deny
    Allow from all
</Directory>"  >> /etc/apache2/conf.d/nedi.conf

ln -s /usr/local/nedi/nedi.conf /etc/nedi.conf





# --------------------------------------------------
# SMTP GMAIL APPS
# --------------------------------------------------
install_msg SMTP

cd /tmp
cp $itvhome/ks/files/mail/openssl.cnf /usr/lib/ssl

/usr/lib/ssl/misc/CA.pl -newca
openssl req -new -nodes -subj '/CN=ITvision/O=ITvision/C=BR/ST=Rio de Janeiro/L=Rio de Janeiro/emailAddress=alert@itvision.com.br' -keyout SERVER-key.pem -out SERVER-req.pem -days 3650
openssl ca -out SERVER-cert.pem -infiles SERVER-req.pem
cp /tmp/demoCA/cacert.pem /tmp/SERVER-key.pem /tmp/SERVER-cert.pem /etc/postfix
chmod 644 /etc/postfix/SERVER-cert.pem /etc/postfix/cacert.pem
chmod 400 /etc/postfix/SERVER-key.pem
wget -P /tmp https://www.geotrust.com/resources/root_certificates/certificates/Equifax_Secure_Certificate_Authority.cer
cat /tmp/Equifax_Secure_Certificate_Authority.cer >> /etc/postfix/cacert.pem

cat << EOF > /etc/postfix/transport
#
* smtp:[smtp.gmail.com]:587
#
EOF
mv /etc/postfix/main.cf /etc/postfix/main.cf.orig
cp -a $itvhome/ks/files/mail/main.cf /etc/postfix/
cat << EOF > /etc/postfix/sasl_passwd
[smtp.gmail.com]:587 alert@itvision.com.br:0qs+l+sd
EOF

touch /etc/postfix/generic
postmap /etc/postfix/sasl_passwd
postmap /etc/postfix/transport
rm -f ~/SERVER* && rm -rf ~/demoCA* 




# --------------------------------------------------
# LOGROTATE
# --------------------------------------------------
mkdir -p /var/log/itvision/mysql
chown -R mysql.adm /var/log/itvision/mysql
sed -i -e 's/\/var\/log\/mysql\/error.log/\/var\/log\/itvision\/mysql\/error.log/' /etc/mysql/my.cnf 
	-e 's/weekly/daily/g' /etc/logrotate.d/apache2

sed -i -e 's/weekly/daily/g' /etc/logrotate.d/nagiosgrapher

sed -i -e '/compress/ i\
notifempty' /etc/logrotate.d/mysql-server

sed -i -e '/compress/ i\
notifempty' /etc/logrotate.d/ocsinventory-server

cat << EOF > /etc/cron.d/logdate 
00 03 * * * root /usr/sbin/logdate
EOF

# Gera perfil para apparmor ("SElinux do Ubuntu") habilitar o mysqld escrever em outro arquivo
aa-complain /usr/sbin/mysqld

# --------------------------------------------------
# GRAPHVIZ
# --------------------------------------------------
install_msq GRAPHVIZ

/usr/bin/wget -P /tmp http://www.graphviz.org/pub/graphviz/stable/ubuntu/ub9.04/i386/graphviz_2.26.3-1_i386.deb
/usr/bin/wget -P /tmp http://www.graphviz.org/pub/graphviz/stable/ubuntu/ub9.04/i386/graphviz-dev_2.26.3-1_all.deb
/usr/bin/wget -P /tmp http://www.graphviz.org/pub/graphviz/stable/ubuntu/ub9.04/i386/libgraphviz4_2.26.3-1_i386.deb
/usr/bin/wget -P /tmp http://www.graphviz.org/pub/graphviz/stable/ubuntu/ub9.04/i386/libgraphviz-dev_2.26.3-1_i386.deb
/usr/bin/wget -P /tmp http://www.graphviz.org/pub/graphviz/stable/ubuntu/ub9.04/i386/libgv-lua_2.26.3-1_i386.deb
/usr/bin/dpkg -i /tmp/*.deb 
/usr/bin/dot -c



# --------------------------------------------------
# LUA ROCKS
# --------------------------------------------------
install_msg LUA

luarocks install lpeg 0.9-1
luarocks install wsapi
luarocks install cgilua
luarocks install orbit
luarocks install dado
luarocks install luagraph
#
sed -i.orig '/^#/ a\
. '$itvhome'/bin/lua_path' /usr/local/bin/wsapi.cgi



# --------------------------------------------------
# FESTIVAL MBROLA 
# --------------------------------------------------
install_msg FESTIVAL MBROLA Synthesizing



# --------------------------------------------------
# CACTI 
# --------------------------------------------------
#install_msg CACTI
#
# wget -P /tmp http://www.cacti.net/downloads/cacti-0.8.7g.tar.gz
# tar zxf /tmp/cacti-0.8.7g.tar.gz -C /usr/share
#mysqldump -u root --password=$dbpass -v cacti > /tmp/cacti.sql
#mysql -u root --password=$dbpass itvision < /tmp/cacti.sql
#echo "DROP DATABASE cacti;" | mysql -u root --password=$dbpass
#chown -R $user.$user /etc/cacti/ /usr/bin/rrdtool /usr/bin/php /usr/bin/snmpwalk /usr/bin/snmpget /usr/bin/snmpbulkwalk /usr/bin/snmpgetnext /var/log/cacti /usr/share/cacti /var/lib/cacti /usr/share/lintian/overrides/cacti /usr/share/doc/cacti /usr/share/dbconfig-common/data/cacti /usr/local/share/cacti /etc/cron.d/cacti /etc/logrotate.d/cacti
#
#sed -i.orig -e "s/\$database_username='cacti';/\$database_username='$dbuser';/" \
#	-e "s/\$basepath=''/\$basepath='/usr/share/php';/" \
#	-e "s/\$database_default='cacti';/\$database_default='$dbname';/" \
#	-e "s/\$database_hostname='';/\$database_hostname='localhost';/" \
#	-e "s/\$database_port='';/\$database_port='3306';/" /etc/cacti/debian.php
#sed -i.orig -e "s/\$database_default = \"cacti\";/\$database_default = \"$dbname\";/" \
#	-e "s/\$database_username = \"cactiuser\";/\$database_username = \"$dbuser\";/" \
#	-e "s/\$database_password = \"cactiuser\";/\$database_password = \"$dbpass\";/" /usr/share/cacti/site/include/global.php
#sed -i -e "s/www-data/$user/" /etc/cron.d/cacti
#
#



# --------------------------------------------------
# UTILILITARIOS
# --------------------------------------------------
install_msg UTILITARIOS

path="\n\nPATH=\$PATH:$itvhome/bin\n\n"
aliases="\nalias mv='mv -i'\nalias cp='cp -i'\nalias rm='rm -i'\nalias psa='ps -ef  |grep -v \" \\[\"'\n"
printf "$path"    >> /home/$user/.bashrc
printf "$aliases" >> /home/$user/.bashrc
printf "$aliases" >> /root/.bashrc
LUA_PATH="$itvhome/orb/?.lua;$itvhome/orb/inc/?.lua;$itvhome/scr/?.lua;$itvhome/orb/Model/?.lua;/usr/local/share/lua/5.1/?.lua"
printf "export LUA_PATH='$LUA_PATH'\n" >> /home/$user/.bashrc
printf "LUA_PATH='$LUA_PATH'\n" > $itvhome/bin/lua_path
export LUA_PATH=$LUA_PATH




# --------------------------------------------------
# ONLY FOR DEVELOPMENT
# --------------------------------------------------
#echo "GRANT ALL ON '$dbname'.* TO '$dbuser'@'%' IDENTIFIED BY '$dbpass';"
#sed -i.orig -e "s/^bind-address/#bind-address/g" /etc/mysql/my.cnf
#/usr/sbin/service mysql restart



# --------------------------------------------------
# CLEAN UP & RESTART ALL PROCESSES
# --------------------------------------------------
install_msg CLEAN UP

/usr/sbin/invoke-rc.d ndoutils stop
/usr/sbin/invoke-rc.d nagios3 stop
/usr/sbin/invoke-rc.d nagios-nrpe-server stop
/usr/sbin/invoke-rc.d apache2 stop
/usr/sbin/invoke-rc.d nagiosgrapher stop
/usr/sbin/invoke-rc.d postfix stop
/usr/sbin/invoke-rc.d mysql stop
/usr/sbin/invoke-rc.d mysql start
/usr/sbin/invoke-rc.d postfix start
/usr/sbin/invoke-rc.d apache2 start
/usr/sbin/invoke-rc.d nagios-nrpe-server start
/usr/sbin/invoke-rc.d nagios3 start
/usr/sbin/invoke-rc.d ndoutils start
/usr/sbin/invoke-rc.d nagiosgrapher start
cd
\rm -rf /tmp/*
rm -f ~/SERVER* && rm -rf ~/demoCA*
apt-get -y -f install
apt-get -y clean
apt-get -y autoremove



# --------------------------------------------------
# POS-CONFIGURACAO
# --------------------------------------------------
install_msg POS-CONFIGURACAO

# Só agora executa a inicializacao das tabelas de checkcmd
source /home/$user/.bashrc
/usr/bin/lua /usr/local/itvision/scr/update_checkcmds.lua

# Cron setup
sudo -u $user crontab -l > /tmp/crontab
sudo -u $user cat << EOF >> /tmp/crontab
LUA_PATH="$LUA_PATH"
* * * * * /usr/bin/lua $itvhome/scr/pendings.lua
EOF
sudo -u $user crontab /tmp/crontab
rm -f /tmp/crontab

# Algumas permissoes
#htpasswd -bc $itvhome/bin/htpasswd $user $dbpass; $itvhome/bin/htpasswd 
chown -R $user.$user $itvhome/html/gv $itvhome/bin/dbconf $itvhome/bin/lua_path




echo ""
echo "======================================================================================="
echo "# Sites instalados:                                                                   #"
echo "======================================================================================="
echo "# 			                                                            #"
echo "# http://localhost			ITvision	      		    	    #"
echo "# http://localhost/servdesk		Service Desk do ITvision	    	    #"
echo "# http://localhost/glpi			GLPI		      		    	    #"
echo "# http://localhost/ocs			OCS-Inventory (Reports)		    	    #"
echo "# http://localhost/nagios3		Nagios		      		    	    #"
echo "# http://localhost/nagios3/graphs.html	NagiosGrapher	      		    	    #"
echo "# 			                                                            #"
echo "======================================================================================="
echo
echo
echo
echo "======================================================================================="
echo "# Nagios, NDOutils, Nagios Business Process, GLPI, LUA e Cacti Installation Complete! #"
echo "======================================================================================="
echo "#			      ********* ATTENTION *********			    	    #"
echo "# Settings to firewall;							            #"
echo "# accept connections port 5666 to NRPE					            #"
echo "# accept connections port 161  to SNMP					            #"
echo "# accept connections port 80 and 443 HTTP					            #"
echo "======================================================================================="
echo ""

