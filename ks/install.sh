#!/bin/bash
# --------------------------------------------------
# ITVISION
# --------------------------------------------------
itvhome=/usr/local/itv
user=$USER

mkdir $itvhome
chown $user.$user $itvhome
if [ "$1" == "clone-repo-with-ssh" ]; then # SSH-KEY NUST BE INCLUDED IN GITHUB
   ssh-keygen -t rsa -C "daniel@itvision.com.br" -N "" -f ~$user/.ssh/id_rsa > /dev/null
   sudo -u $user git clone git@github.com:dlins/ITv.git $itvhome
else
   sudo -u $user git clone git://github.com/dlins/ITv.git $itvhome
fi
sed -i -e "s,^user=.*,user=$user,g" $itvhome/ks/itvision.sh
sed -i -e "s,^itvhome=.*,itvhome=$itvhome,g" $itvhome/ks/itvision.sh
$itvhome/ks/itvision.sh
