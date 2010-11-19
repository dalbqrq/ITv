#!/bin/bash
# --------------------------------------------------
# ITVISION
# --------------------------------------------------
user=itv
pass=itv
itvhome=/usr/local/itvision

apt-get install -y git-core
mkdir $itvhome
chown $user.$user $itvhome
cd $itvhome
if [ "$1" == "clone-for-devel" ]; then # MUST USE PASSWORD OR SSH-KEY MUST BE INCLUDED IN GITHUB
   ssh-keygen -t rsa -C "devel@itvision.com.br" -N "" -f ~$user/.ssh/id_rsa > /dev/null
   sudo -u $user git clone git@github.com:dlins/ITv.git $itvhome
else
   sudo -u $user git clone git://github.com/dlins/ITv.git $itvhome
fi
sed -i -e "s,^user=.*,user=$user,g" \
	-e "s,^dbpass=.*,dbpass=$pass,g" \
	-e "s,^itvhome=.*,itvhome=$itvhome,g" $itvhome/ks/itvision.sh
$itvhome/ks/itvision.sh
