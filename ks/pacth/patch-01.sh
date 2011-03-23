#!/bin/bash
data=`date +%d%m%Y`
user=`id |awk -F"(" '{print $2}' |awk -F")" '{print $1}'`
sed -i.bkp.$data 's/url_html_path=\/nagios3/url_html_path=\/monitor/' /etc/nagios3/cgi.cfg
cd /etc/apache2/conf.d
rm -f nagios3.conf
ln -s /etc/nagios3/apache2.conf monitor.conf
chown -R $user.$user monitor.conf
mv /etc/nagios3/apache2.conf /etc/nagios3/apache2.conf.bkp.$data
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

<DirectoryMatch (/usr/share/nagios3/htdocs|/usr/lib/cgi-bin/nagios3|/etc/nagios3/stylesheets)>
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

sed -i.bkp.$data -e "s/\/cgi-bin\/nagios3/\/cgi-bin\/monitor/" /usr/share/nagios3/htdocs/config.inc.php
sed -i.bkp.$data -e 's/nagios3/monitor/' /usr/share/nagios3/htdocs/graphs.html

/etc/init.d/nagios3 restart
sudo /etc/init.d/apache2 restart
