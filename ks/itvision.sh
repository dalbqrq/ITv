#!/bin/bash

user=itv
dbpass=itv
dbuser=$user
dbname=itvision
itvhome=/usr/local/itvision

function install_pack() {
	apt-get -y install $1
}

# --------------------------------------------------
# INSTALL UBUNTU NATIVE PACKAGES VIA apt-get
# --------------------------------------------------
apt-get -y update
apt-get -y upgrade

#install_pack openssh-server
#install_pack sysutils
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
install_pack php5-mysql
install_pack libcgi-simple-perl
install_pack snmpd
install_pack cacti


# --------------------------------------------------
# STOP ALL PROCESSES
# --------------------------------------------------
/usr/sbin/invoke-rc.d ndoutils stop
/usr/sbin/invoke-rc.d nagios3 stop
/usr/sbin/invoke-rc.d nagios-nrpe-server stop
/usr/sbin/invoke-rc.d apache2 stop
rm -rf /var/cache/nagios3/ndo.sock


# --------------------------------------------------
# ITVISION
# --------------------------------------------------
echo "CREATE DATABASE $dbname;" | mysql -u root --password=$dbpass
echo "CREATE USER '$dbuser'@'localhost' IDENTIFIED BY '$dbpass';" | mysql -u root --password=$dbpass
echo "GRANT ALL PRIVILEGES ON *.* TO '$dbuser'@'localhost' WITH GRANT OPTION;" | mysql -u root --password=$dbpass
mysql -u root --password=$dbpass $dbname < $itvhome/ks/db/itvision.sql

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
        CustomLog /var/log/apache2/tivision_access.log combined

</VirtualHost>
EOF


sed -i -e 's|instance_name = ".*"|instance_name = "default"|g' \
	-e 's|dbname = ".*",|dbname = "'$dbname'",|g' \
	-e 's|dbuser = ".*",|dbuser = "'$dbuser'",|g' \
	-e 's|dbpass = ".*",|dbpass = "'$dbpass'",|g' \
	-e 's|dir        = ".*",|dir        = "/etc/nagios3",|g' \
	-e 's|bp_dir     = ".*",|bp_dir     = "/etc/nagios3/nagiosbp",|g' \
	-e 's|script     = ".*",|script     = "/etc/init.d/nagios3",|g' \
	-e 's|bp_script  = ".*",|bp_script  = "/etc/init.d/ndoutils",|g' $itvhome/orb/config.lua


ln -s $itvhome ~$user/itvision
chown -R $user.$user ~$user/itvision

# --------------------------------------------------
# NAGIOS
# --------------------------------------------------
htpasswd -cb /etc/nagios3/htpasswd.users $user $dbpass
sed -i.orig -e "s/nrpe_user=nagios/nrpe_user=$user/" \
	-e "s/nrpe_group=nagios/nrpe_group=$user/" \
	-e "s/allowed_hosts=127.0.0.1/#allowed_hosts=127.0.0.1/" /etc/nagios/nrpe.cfg
sed -i.orig -e "s/www-data/$user/g" /etc/apache2/envvars
sed -i.orig -e "s/nagiosadmin/$user/g" /etc/nagios3/cgi.cfg
sed -i.orig -e "s/nagios_user=nagios/nagios_user=$user/" \
	-e "s/nagios_group=nagios/nagios_group=$user/" \
	-e "s/admin_email=root@localhost/admin_email=webmaster@itvision.com.br/" \
	-e "s/admin_pager=pageroot@localhost/#admin_pager=pageroot@localhost/" /etc/nagios3/nagios.cfg
sed -i.orig -e "s/chown nagios:nagios/chown $user:root/" /etc/init.d/nagios3
sed -i.orig -e "s/chown nagios/chown $user/" /etc/init.d/nagios-nrpe-server
sed -i.orig -e "s/root/$user/" -e "s/Root/Admin/" \
	-e "s/root@localhost/webmaster@itvision.com.br/" /etc/nagios3/conf.d/contacts_nagios2.cfg


# --------------------------------------------------
# NDO UTILS - Nagios
# --------------------------------------------------
chown -R $user.$user /etc/nagios3/ndomod.cfg /etc/nagios3/ndo2db.cfg /usr/lib/ndoutils /etc/init.d/ndoutils

sed -i.orig -e "s/ nagios / $user /g" /etc/init.d/ndoutils
sed -i.orig -e '/# LOG ROTATION METHOD/ i\
broker_module=/usr/lib/ndoutils/ndomod-mysql-3x.o config_file=/etc/nagios3/ndomod.cfg' /etc/nagios3/nagios.cfg
sed -i.orig -e "s/ndo2db_group=nagios/ndo2db_group=$user/" \
	-e "s/ndo2db_user=nagios/ndo2db_user=$user/" \
	-e "s/db_name=ndoutils/db_name=$dbname/" \
	-e "s/^db_user=ndoutils/db_user=$dbuser/" \
	-e "s/\/\//\//g" /etc/nagios3/ndo2db.cfg
sed -i -e "s/\/\//\//g" /etc/nagios3/ndomod.cfg
sed -i -e 's/ENABLE_NDOUTILS=0/ENABLE_NDOUTILS=1/' /etc/default/ndoutils

mysqldump -u root --password=$dbpass -v ndoutils > /tmp/ndoutils.sql
mysql -u root --password=$dbpass $dbname < /tmp/ndoutils.sql
echo "DROP DATABASE ndoutils;" | mysql -u root --password=$dbpass

chown -R $user.$user /var/log/nagios3 /etc/init.d/nagios-nrpe-server /etc/init.d/nagios3 /etc/nagios3 /etc/nagios /etc/nagios-plugins /var/run/nagios /var/run/nagios3 /usr/lib/nagios /usr/sbin/log2ndo /usr/lib/nagios3 /etc/apache2 /var/cache/nagios3 /var/lib/nagios /var/lib/nagios3 /usr/share/nagios3/ /usr/lib/cgi-bin/nagios3



# --------------------------------------------------
# BUSINESS PROCESS
# --------------------------------------------------
bp=nagiosbp
tar zxf $itvhome/ks/files/nagiosbp-0.9.5.tgz -C /usr/local/src
cd /usr/local/src/nagios-business-process-addon-0.9.5
./configure --prefix=/etc/nagios3/$bp --with-nagiosbp-user=$user --with-nagiosbp-group=$user --with-nagetc=/etc/nagios3 --with-naghtmurl=/nagios3 --with-nagcgiurl=/cgi-bin/nagios3 --with-htmurl=/$bp --with-cgiurl=/$bp/cgi-bin/ --with-apache-user=$user
make install
sed -i -e 's/ScriptAlias \/nagiosbp\/cgi-bin\/ "\/etc\/nagios3\/nagiosbp\/sbin"/ScriptAlias \/nagiosbp\/cgi-bin\/ "\/etc\/nagios3\/nagiosbp\/sbin\/"/' /etc/apache2/conf.d/nagiosbp.conf
cp -a /etc/nagios3/nagiosbp/etc/nagios-bp.conf-sample /etc/nagios3/nagiosbp/etc/nagios-bp.conf
cp -a /etc/nagios3/nagiosbp/etc/ndo.cfg-sample /etc/nagios3/nagiosbp/etc/ndo.cfg
sed -i.orig -e "s/ndodb_database=nagios/ndodb_database=$user/" \
        -e "s/ndodb_username=nagiosro/ndodb_username=$user/" \
        -e "s/ndodb_password=dummy/ndodb_password=$dbpass/" /etc/nagios3/nagiosbp/etc/ndo.cfg

# TODO: INCLUDE THE FOLLOWING IN side.php
#sed -i.orig -e "139a \\
#  <tr> \\
#    <td width=13><img src=\"images/greendot.gif\" width=\"13\" height=\"14\" name=\"statuswrl-dot\"></td> \\
#    <td nowrap><a href=\"/nagiosbp/cgi-bin/nagios-bp.cgi\" target=\"main\" onMouseOver=\"switchdot('statuswrl-dot',1)\" onMouseOut=\"switchdot('statuswrl-dot',0)\" class=\"NavBarItem\">Business Process View</a></td> \\
#  </tr> \\
#  <tr> \\
#    <td width=13><img src=\"images/greendot.gif\" width=\"13\" height=\"14\" name=\"statuswrl-dot\"></td> \\
#    <td nowrap><a href=\"/nagiosbp/cgi-bin/nagios-bp.cgi?mode=bi\" target=\"main\" onMouseOver=\"switchdot('statuswrl-dot',1)\" onMouseOut=\"switchdot('statuswrl-dot',0)\" class=\"NavBarItem\">Business Impact</a></td> \\
#  </tr>" /usr/share/nagios3/htdocs/side.php


# --------------------------------------------------
# GLPI
# --------------------------------------------------
wget -P /tmp https://forge.indepnet.net/attachments/download/656/glpi-0.78.tar.gz
tar zxf /tmp/glpi-0.78.tar.gz -C /usr/local
mv /usr/local/glpi /usr/local/servdesk
chown -R $user.$user /usr/local/servdesk

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

cp $itvhome/ks/db/glpi.sql.gz /tmp
gunzip /tmp/glpi.sql.gz
mysql -u $dbuser --password=$dbpass $dbname < /tmp/glpi.sql

cd $itvhome/ks/servdesk
tar cf - * | ( cd /usr/local/servdesk; tar xfp -)


# --------------------------------------------------
# LUA ROCKS
# --------------------------------------------------
luarocks install wsapi
luarocks install cgilua
luarocks install orbit
# luarocks install luagraph - BROKEN! install and compile it manually!
cd /tmp
luarocks download luagraph
luarocks unpack luagraph
cd luagraph-1.0.4-1/luagraph-1.0.4/src
sed -i.orig -e "s/lt_symlist_t lt_preloaded_symbols\[\] = { { 0, 0 } };//g" gr_graph.c
cd ..
luarocks make
#
sed -i.orig '/^#/ a\
. '$itvhome'/bin/lua_path' /usr/local/bin/wsapi.cgi



# --------------------------------------------------
# CACTI 
# --------------------------------------------------
# wget -P /tmp http://www.cacti.net/downloads/cacti-0.8.7g.tar.gz
# tar zxf /tmp/cacti-0.8.7g.tar.gz -C /usr/share
mysqldump -u root --password=$dbpass -v cacti > /tmp/cacti.sql
mysql -u root --password=$dbpass itvision < /tmp/cacti.sql
echo "DROP DATABASE cacti;" | mysql -u root --password=$dbpass
chown -R $user.$user /etc/cacti/ /usr/bin/rrdtool /usr/bin/php /usr/bin/snmpwalk /usr/bin/snmpget /usr/bin/snmpbulkwalk /usr/bin/snmpgetnext /var/log/cacti /usr/share/cacti /var/lib/cacti /usr/share/lintian/overrides/cacti /usr/share/doc/cacti /usr/share/dbconfig-common/data/cacti /usr/local/share/cacti /etc/cron.d/cacti /etc/logrotate.d/cacti

sed -i.orig -e "s/\$database_username='cacti';/\$database_username='$dbuser';/" \
	-e "s/\$basepath=''/\$basepath='/usr/share/php';/" \
	-e "s/\$database_default='cacti';/\$database_default='$dbname';/" \
	-e "s/\$database_hostname='';/\$database_hostname='localhost';/" \
	-e "s/\$database_port='';/\$database_port='3306';/" /etc/cacti/debian.php
sed -i.orig -e "s/\$database_default = \"cacti\";/\$database_default = \"$dbname\";/" \
	-e "s/\$database_username = \"cactiuser\";/\$database_username = \"$dbuser\";/" \
	-e "s/\$database_password = \"cactiuser\";/\$database_password = \"$dbpass\";/" /usr/share/cacti/site/include/global.php
sed -i -e "s/www-data/$user/" /etc/cron.d/cacti


# --------------------------------------------------
# UTILILITARIOS
# --------------------------------------------------
aliases="\n\nalias mv='mv -i'\nalias cp='cp -i'\nalias rm='rm -i'\n"
printf "$aliases" >> /root/.bashrc
printf "$aliases" >> /home/$user/.bashrc

cat << EOF > /usr/local/bin/dumpdb
#!/bin/bash

dbuser=$dbuser
dbpass=$dbpass
dbname=$dbname

d=\`date "+%Y%m%d%H%M"\`
tmpfile=/tmp/tables

if [ \$# -eq 1 ]; then
   echo "show tables like '\$1_%'" | mysql -u \$dbuser --password=\$dbpass \$dbname | grep -v Tables_in_ > \$tmpfile
   ext="_\$1"
   tables=\`cat \$tmpfile\`
   opt="--add-drop-table"

   if [ \$# -eq 2 ]; then
      if [ \$2 == "no-data" ]; then
         opt="--add-drop-table --no-data"
      else
         echo usage: dumpdb [<sub-db-name>] [no-data]
      fi
   fi
fi

mysqldump -u \$dbuser --password=\$dbpass \$opt \$dbname \$tables > /tmp/dumpdb\$ext"_"\$d.sql

\rm -f \$tmpfile
EOF
chmod 755 /usr/local/bin/dumpdb


# --------------------------------------------------
# CLEAN UP & RESTART ALL PROCESSES
# --------------------------------------------------
/usr/sbin/invoke-rc.d apache2 start
/usr/sbin/invoke-rc.d nagios-nrpe-server start
/usr/sbin/invoke-rc.d nagios3 start
/usr/sbin/invoke-rc.d ndoutils start
cd
\rm -rf /tmp/*
apt-get clean
apt-get autoremove


echo ""
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

