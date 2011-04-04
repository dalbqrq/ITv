#!/bin/bash

#
#   Atualiza db e permissoes
#
itvhome=/usr/local/itvision

. $itvhome/bin/dbconf
mysql -u $user --password=$dbpass $dbname < $itvhome/ks/db/itvision_update8.sql

cd $itvhome/ks/servdesk
tar cf - * | ( cd /usr/local/servdesk; tar xfp -)


