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

echo -n "Entre com caminho completo do arquivo e pressione [ENTER]: " 
read ARQ

#CHAVE=(`cat $ARQ |awk -F ";" '{print $1}'`) # glpi_computers > name
#SERIAL_NUMBER=(`cat $ARQ |awk -F ";" '{print $2}'`) # glpi_computers > serial
#ALIAS=(`cat $ARQ |awk -F ";" '{print $3}'`) 
HOST_NAME=(`cat $ARQ |awk -F ";" '{print $2}'`) # glpi_computers > name
#MAC_ADDRESS=(`cat $ARQ |awk -F ";" '{print $5}'`) # glpi_networkports > mac
IP=(`cat $ARQ |awk -F ";" '{print $3}'`) # glpi_networkports > ip
#PATRIMONIO=(`cat $ARQ |awk -F ";" '{print $7}'`)
#FABRICANTE=(`cat $ARQ |awk -F ";" '{print $8}'`) # glpi_computers "id" dell=4
#COD_FABRICANTE=(`cat $ARQ |awk -F ";" '{print $9}'`)
#MOD_FABRINCATE=(`cat $ARQ |awk -F ";" '{print $10}'`) #glpi_computermodels "id" 2950=1
#VERSAO=(`cat $ARQ |awk -F ";" '{print $11}'`)
#FAMILIA=(`cat $ARQ |awk -F ";" '{print $12}'`)
#CLASSE=(`cat $ARQ |awk -F ";" '{print $13}'`)
#GARANTIA=(`cat $ARQ |awk -F ";" '{print $14}'`) ## VAZIO
#LOCALIZACAO=(`cat $ARQ |awk -F ";" '{print $15}'`)
#USUARIO_RESPONSAVEL=(`cat $ARQ |awk -F ";" '{print $16}'`)
#INI_RESPONSABILIDADE=(`cat $ARQ |awk -F ";" '{print $17}'`) ## VAZIO
#FORNECEDOR=(`cat $ARQ |awk -F ";" '{print $18}'`)
#LICENCA=(`cat $ARQ |awk -F ";" '{print $19}'`)
#DATA_COMPRA=(`cat $ARQ |awk -F ";" '{print $20}'`) ## VAZIO
#DATA_ENTRADA=(`cat $ARQ |awk -F ";" '{print $21}'`) ## VAZIO
STATUS=(`cat $ARQ |awk -F ";" '{print $4}'`) # glpi_computers > states_id ativo=1 spare=7
#STATUS_AGENDADO=(`cat $ARQ |awk -F ";" '{print $23}'`) ## VAZIO
#CUSTO=(`cat $ARQ |awk -F ";" '{print $24}'`) ## VAZIO
#STATUS_AGENDADO2=(`cat $ARQ |awk -F ";" '{print $25}'`) ## VAZIO
#CUSTO=(`cat $ARQ |awk -F ";" '{print $26}'`) ## VAZIO
#SERVICO=(`cat $ARQ |awk -F ";" '{print $27}'`)
#AMBIENTE=(`cat $ARQ |awk -F ";" '{print $28}'`) ## VAZIO
#IP_SECUNDARIO=(`cat $ARQ |awk -F ";" '{print $29}'`)
#IP_TECIARIO=(`cat $ARQ |awk -F ";" '{print $30}'`)
#SERVIDOR=(`cat $ARQ |awk -F ";" '{print $31}'`)
#NOME_SITE=(`cat $ARQ |awk -F ";" '{print $32}'`)
#CLIENTE=(`cat $ARQ |awk -F ";" '{print $33}'`)
#EMAIL=(`cat $ARQ |awk -F ";" '{print $34}'`)
#TELEFONE=(`cat $ARQ |awk -F ";" '{print $35}'`)
#CELULAR=(`cat $ARQ |awk -F ";" '{print $36}'`)
#RELEVANCIA=(`cat $ARQ |awk -F ";" '{print $37}'`)
#CIRCUITO=(`cat $ARQ |awk -F ";" '{print $38}'`)

for (( h = 1 ; h < ${#HOST_NAME[@]} ; h++ ))
do
       echo "INSERT INTO glpi_computers (name, states_id) VALUES ('${HOST_NAME[$h]}','${STATUS[$h]}');" | mysql -u $dbuser -p$dbpass $dbname
done

for (( n = 1 ; n < ${#HOST_NAME[@]} ; n++ ))
do
        HOSTIP=(`cat $ARQ |grep ${HOST_NAME[$n]} |awk -F";" '{print $3}'`)
        HOSTID=(`mysql -u $dbuser -p$dbpass $dbname -e "SELECT id FROM glpi_computers WHERE name = '${HOST_NAME[$n]}';" |sed -e 's/\|//g'`)
        echo "INSERT INTO glpi_networkports (items_id, ip) VALUES ('${HOSTID[1]}','${HOSTIP[0]}');" |mysql -u $dbuser -p$dbpass $dbname
done

