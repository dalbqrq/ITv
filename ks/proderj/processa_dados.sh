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
#CHAVE=(`cat $arq |awk -F ";" '{print $1}'`) # glpi_computers > name
#SERIAL_NUMBER=(`cat $arq |awk -F ";" '{print $2}'`) # glpi_computers > serial
#ALIAS=(`cat $arq |awk -F ";" '{print $3}'`) 
HOST_NAME=(`cat $arq |awk -F ";" '{print $4}'`) # glpi_computers > name
#MAC_ADDRESS=(`cat $arq |awk -F ";" '{print $5}'`) # glpi_networkports > mac
IP=(`cat $arq |awk -F ";" '{print $6}'`) # glpi_networkports > ip
#PATRIMONIO=(`cat $arq |awk -F ";" '{print $7}'`)
#FABRICANTE=(`cat $arq |awk -F ";" '{print $8}'`) # glpi_computers "id" dell=4
#COD_FABRICANTE=(`cat $arq |awk -F ";" '{print $9}'`)
#MOD_FABRINCATE=(`cat $arq |awk -F ";" '{print $10}'`) #glpi_computermodels "id" 2950=1
#VERSAO=(`cat $arq |awk -F ";" '{print $11}'`)
#FAMILIA=(`cat $arq |awk -F ";" '{print $12}'`)
#CLASSE=(`cat $arq |awk -F ";" '{print $13}'`)
#GARANTIA=(`cat $arq |awk -F ";" '{print $14}'`) ## VAZIO
#LOCALIZACAO=(`cat $arq |awk -F ";" '{print $15}'`)
#USUARIO_RESPONSAVEL=(`cat $arq |awk -F ";" '{print $16}'`)
#INI_RESPONSABILIDADE=(`cat $arq |awk -F ";" '{print $17}'`) ## VAZIO
#FORNECEDOR=(`cat $arq |awk -F ";" '{print $18}'`)
#LICENCA=(`cat $arq |awk -F ";" '{print $19}'`)
#DATA_COMPRA=(`cat $arq |awk -F ";" '{print $20}'`) ## VAZIO
#DATA_ENTRADA=(`cat $arq |awk -F ";" '{print $21}'`) ## VAZIO
STATUS=(`cat $arq |awk -F ";" '{print $22}'`) # glpi_computers > states_id ativo=1 spare=7
#STATUS_AGENDADO=(`cat $arq |awk -F ";" '{print $23}'`) ## VAZIO
#CUSTO=(`cat $arq |awk -F ";" '{print $24}'`) ## VAZIO
#STATUS_AGENDADO2=(`cat $arq |awk -F ";" '{print $25}'`) ## VAZIO
#CUSTO=(`cat $arq |awk -F ";" '{print $26}'`) ## VAZIO
#SERVICO=(`cat $arq |awk -F ";" '{print $27}'`)
#AMBIENTE=(`cat $arq |awk -F ";" '{print $28}'`) ## VAZIO
#IP_SECUNDARIO=(`cat $arq |awk -F ";" '{print $29}'`)
#IP_TECIARIO=(`cat $arq |awk -F ";" '{print $30}'`)
#SERVIDOR=(`cat $arq |awk -F ";" '{print $31}'`)
#NOME_SITE=(`cat $arq |awk -F ";" '{print $32}'`)
#CLIENTE=(`cat $arq |awk -F ";" '{print $33}'`)
#EMAIL=(`cat $arq |awk -F ";" '{print $34}'`)
#TELEFONE=(`cat $arq |awk -F ";" '{print $35}'`)
#CELULAR=(`cat $arq |awk -F ";" '{print $36}'`)
#RELEVANCIA=(`cat $arq |awk -F ";" '{print $37}'`)
#CIRCUITO=(`cat $arq |awk -F ";" '{print $38}'`)



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
	if [ "($hostip)" == "(${ch[1]})" ]
		if [ "($hostip)" == "(${ip[$n]})" ] &&  "$hostid" -gt ${id[$n]} ]
		then
			echo "INSERT INTO glpi_networkports (id, ip) VALUES ('${id[$n]}','${ip[$n]}');"
		else
			echo "Erro em inserir ${ip[$n]} no banco de dados"
		fi


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
