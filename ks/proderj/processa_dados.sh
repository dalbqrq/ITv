#!/bin/bash

#-----------------------------------------------------
#  Arquivo:	processadados.sh
#
#  Descricao:	Processa dados em arquivos .csv 
#		no formato hostname:ip:status e
#		insere na base de dados do GLPI
#		
#  Autor:	Ricardo Gomes
#  Versão:	1.0.1	02/09/2010
#----------------------------------------------------

dbuser=itv
dbpass=itv
dbname=itvision
arq=/tmp/dados.txt

host=(`cut -d: -f2 $arq`)
ip=(`cut -d: -f3 $arq`)
state=(`cut -d: -f4 $arq`) 

#for (( h = 1 ; h < ${#host[@]} ; h++ ))
#do
#	echo "INSERT INTO glpi_computers (name, states_id) VALUES ('${host[$h]}','${state[$h]}');" #| mysql -u $dbuser -p$dbpass $dbname
#done


id=(`mysql -u $dbuser -p$dbpass $dbname -e "SELECT id, name FROM glpi_computers;" | awk -F " " '{print $1}'`)

for (( n = 1 ; n < ${#ip[@]} ; n++ ))
do	
	hostip=(`grep ${host[$n]} $arq |cut -d: -f 3`)
	hostid=(`echo "SELECT id FROM glpi_computers WHERE name = '${host[$n]}';" |mysql -u $dbuser -p$dbpass $dbname`) 
		if [ test "$hostip" -gt ${ip[$n]} &&  "$hostid" -gt ${id[$n]} ]
		then
			echo "INSERT INTO glpi_networkports (id, ip) VALUES ('${id[$n]}','${ip[$n]}');"
		else
			echo "Erro em inserir ${ip[$n]} no banco de dados"
		fi
done


#while true ; do
#	if [ $n -ne $fim ]; then
#		for (( h = 0 ; h < ${#host[@]} ; h++ ))
#		do
#			echo "INSERT INTO glpi_networkports (id, ip) VALUES ('${id[$h]}','${ip[$h]}');"
#		done
#	break
#	exit 1
#fi
#done
#
#
#for (( h = 0 ; h < ${#host[@]} ; h++ )) (( n = 0 ; n < ${#id[@]} ; n++ ))
#do
#	echo "${host[$h]}"
#        echo "${id[$n]}"
#	#egrep ${host[@]}
#	#echo "INSERT INTO glpi_networkports (id, ip) VALUES ('${id[$h]}','${ip[$h]}');" |mysql -u $dbuser -p$dbpass $dbname
#done

##mysql -u $dbuser --password=$dbpass <<EOF
#use itvision;
#SELECT id, name FROM glpi_computers INTO OUTFILE '/tmp/select_computers.csv' FIELDS TERMINATED BY ':' LINES TERMINATED BY '\n';
#EOF
#
#id=`awk -F":" '{print $1}' /tmp/select_computers.csv` 
#count=0
#while [ $count != ${host[@]} ]
#nomes=( "Bit" "Nibble" "Byte" "Word" "Double Word")
#valores=( 1 4 8 16 32)
#x=0;
#echo "########################################"
#while [ $x != ${#nomes[@]} ]
#do
#   if [ $x == 0 ]
#   then
#      echo "A menor \"unidade\" de dados binários "
#      echo "tem o nome de "${nomes[$x]}"."
#      echo "Ele representa "${valores[$x]}" único digito"
#      echo ""
#   else
#      echo "1 "${nomes[$x]}" é o conjunto de "${valores[$x]}" bits."
#   fi
#   let "x = x +1"
#done 
#   echo "("${nomes[@]:2}")"
#   echo "são os conjuntos de bits"
#   echo "("${nomes[@]:1:3}")"
#   echo "são os conjuntos menores que 32 bits"
#echo "########################################"
