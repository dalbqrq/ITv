#!/bin/bash
PATHTEMPLATE=/etc/nagiosgrapher/ngraph.d/standard
PATHPLUGIN=/etc/nagios-plugins/config
ITVTEMPLATE=/etc/nagiosgrapher/ngraph.d/itvision

COMMAND=(`cat $PATHPLUGIN/ping.cfg |egrep command_name |awk -F " " '{print $2}'`)
for (( h = 0 ; h < ${#COMMAND[@]} ; h++ )); do cp $PATHTEMPLATE/check_ping.ncfg $ITVTEMPLATE/${COMMAND[$h]}.ncfg ; sed -i -e "s/PING/${COMMAND[$h]}/g" $ITVTEMPLATE/${COMMAND[$h]}.ncfg; done
COMMAND=(`cat $PATHPLUGIN/disk.cfg |egrep command_name |awk -F " " '{print $2}'`)
for (( h = 0 ; h < ${#COMMAND[@]} ; h++ )); do cp $PATHTEMPLATE/check_disk.ncfg $ITVTEMPLATE/${COMMAND[$h]}.ncfg ; sed -i -e "s/disk/${COMMAND[$h]}/g" $ITVTEMPLATE/${COMMAND[$h]}.ncfg; done
COMMAND=(`cat $PATHPLUGIN/dns.cfg |egrep command_name |awk -F " " '{print $2}'`)
for (( h = 0 ; h < ${#COMMAND[@]} ; h++ )); do cp $PATHTEMPLATE/check_dns.ncfg $ITVTEMPLATE/${COMMAND[$h]}.ncfg ; sed -i -e "s/DNS/${COMMAND[$h]}/g" $ITVTEMPLATE/${COMMAND[$h]}.ncfg; done
COMMAND=(`cat $PATHPLUGIN/load.cfg |egrep command_name |awk -F " " '{print $2}'`)
for (( h = 0 ; h < ${#COMMAND[@]} ; h++ )); do cp $PATHTEMPLATE/check_load.ncfg $ITVTEMPLATE/${COMMAND[$h]}.ncfg ; sed -i -e "s/LOAD/${COMMAND[$h]}/g" $ITVTEMPLATE/${COMMAND[$h]}.ncfg; done
COMMAND=(`cat $PATHPLUGIN/ftp.cfg |egrep command_name |awk -F " " '{print $2}'`)
for (( h = 0 ; h < ${#COMMAND[@]} ; h++ )); do cp $PATHTEMPLATE/check_ftp.ncfg $ITVTEMPLATE/${COMMAND[$h]}.ncfg ; sed -i -e "s/FTP/${COMMAND[$h]}/g" $ITVTEMPLATE/${COMMAND[$h]}.ncfg; done
COMMAND=(`cat $PATHPLUGIN/http.cfg |egrep command_name |awk -F " " '{print $2}'`)
for (( h = 0 ; h < ${#COMMAND[@]} ; h++ )); do cp $PATHTEMPLATE/check_http.ncfg $ITVTEMPLATE/${COMMAND[$h]}.ncfg ; sed -i -e "s/HTTP/${COMMAND[$h]}/g" $ITVTEMPLATE/${COMMAND[$h]}.ncfg; done
COMMAND=(`cat $PATHPLUGIN/ldap.cfg |egrep command_name |awk -F " " '{print $2}'`)
for (( h = 0 ; h < ${#COMMAND[@]} ; h++ )); do cp $PATHTEMPLATE/check_ldap.ncfg $ITVTEMPLATE/${COMMAND[$h]}.ncfg ; sed -i -e "s/LDAP/${COMMAND[$h]}/g" $ITVTEMPLATE/${COMMAND[$h]}.ncfg; done
COMMAND=(`cat $PATHPLUGIN/procs.cfg |egrep command_name |awk -F " " '{print $2}'`)
for (( h = 0 ; h < ${#COMMAND[@]} ; h++ )); do cp $PATHTEMPLATE/check_procs.ncfg $ITVTEMPLATE/${COMMAND[$h]}.ncfg ; sed -i -e "s/PROCS/${COMMAND[$h]}/g" $ITVTEMPLATE/${COMMAND[$h]}.ncfg; done
COMMAND=(`cat $PATHPLUGIN/ntp.cfg |egrep command_name |awk -F " " '{print $2}'`)
for (( h = 0 ; h < ${#COMMAND[@]} ; h++ )); do cp $PATHTEMPLATE/check_ntp.ncfg $ITVTEMPLATE/${COMMAND[$h]}.ncfg ; sed -i -e "s/NTP/${COMMAND[$h]}/g" $ITVTEMPLATE/${COMMAND[$h]}.ncfg; done
COMMAND=(`cat $PATHPLUGIN/mysql.cfg |egrep command_name |awk -F " " '{print $2}'`)
for (( h = 0 ; h < ${#COMMAND[@]} ; h++ )); do cp $PATHTEMPLATE/check_mysql.ncfg $ITVTEMPLATE/${COMMAND[$h]}.ncfg ; sed -i -e "s/mysql-info/${COMMAND[$h]}/g" $ITVTEMPLATE/${COMMAND[$h]}.ncfg; done

