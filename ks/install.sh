#!/bin/bash
# --------------------------------------------------
# ITVISION
# --------------------------------------------------
itvhome=/usr/local/itv
user=itv

mkdir $itvhome
chown $user.$user $itvhome
sudo -u $user git clone git://github.com/dlins/ITv.git $itvhome
sed -i -e "s,^user=.*,user=$user,g" $itvhome/ks/itvision.sh
sed -i -e "s,^itvhome=.*,itvhome=$itvhome,g" $itvhome/ks/itvision.sh
$itvhome/ks/itvision.sh
