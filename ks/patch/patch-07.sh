#!/bin/bash

#
#   Atualiza db e permissoes
#
itvhome=/usr/local/itvision

. $itvhome/bin/dbconf

mkdir /var/log/itvision
chown -R $user.$user /var/log/itvision


tar cf - * | ( cd /usr/local/servdesk; tar xfp -)

echo "Inclua manualmente entrada do path.log em config.lua!"

