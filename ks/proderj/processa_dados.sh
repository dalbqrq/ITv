#!/bin/bash
#
# Script para migração de dados em arquivos "csv" para base de dados GLPI
# 

echo -n "Entre com caminho completo do arquivo e pressione [ENTER]: " 
read arq

CHAVE=`cat $arq |awk -F ";" '{print $1}'`
SERIAL_NUMBER=`cat $arq |awk -F ";" '{print $2}'`
ALIAS=`cat $arq |awk -F ";" '{print $3}'`
HOST_NAME=`cat $arq |awk -F ";" '{print $4}'`
MAC_ADDRESS=`cat $arq |awk -F ";" '{print $5}'`
IP=`cat $arq |awk -F ";" '{print $6}'`
PATRIMONIO=`cat $arq |awk -F ";" '{print $7}'`
FABRICANTE=`cat $arq |awk -F ";" '{print $8}'`
COD_FABRICANTE=`cat $arq |awk -F ";" '{print $9}'`
MOD_FABRINCATE=`cat $arq |awk -F ";" '{print $10}'`
VERSAO=`cat $arq |awk -F ";" '{print $11}'`
FAMILIA=`cat $arq |awk -F ";" '{print $12}'`
CLASSE=`cat $arq |awk -F ";" '{print $13}'`
#GARANTIA=`cat $arq |awk -F ";" '{print $14}'` ## VAZIO
LOCALIZACAO=`cat $arq |awk -F ";" '{print $15}'`
USUARIO_RESPONSAVEL=`cat $arq |awk -F ";" '{print $16}'`
#INI_RESPONSABILIDADE=`cat $arq |awk -F ";" '{print $17}'` ## VAZIO
FORNECEDOR=`cat $arq |awk -F ";" '{print $18}'`
LICENCA=`cat $arq |awk -F ";" '{print $19}'`
#DATA_COMPRA=`cat $arq |awk -F ";" '{print $20}'` ## VAZIO
#DATA_ENTRADA=`cat $arq |awk -F ";" '{print $21}'` ## VAZIO
STATUS=`cat $arq |awk -F ";" '{print $22}'`
#STATUS_AGENDADO=`cat $arq |awk -F ";" '{print $23}'` ## VAZIO
#CUSTO=`cat $arq |awk -F ";" '{print $24}'` ## VAZIO
#STATUS_AGENDADO2=`cat $arq |awk -F ";" '{print $25}'` ## VAZIO
#CUSTO=`cat $arq |awk -F ";" '{print $26}'` ## VAZIO
SERVICO=`cat $arq |awk -F ";" '{print $27}'`
#AMBIENTE=`cat $arq |awk -F ";" '{print $28}'` ## VAZIO
IP_SECUNDARIO=`cat $arq |awk -F ";" '{print $29}'`
IP_TECIARIO=`cat $arq |awk -F ";" '{print $30}'`
SERVIDOR=`cat $arq |awk -F ";" '{print $31}'`
NOME_SITE=`cat $arq |awk -F ";" '{print $32}'`
CLIENTE=`cat $arq |awk -F ";" '{print $33}'`
EMAIL=`cat $arq |awk -F ";" '{print $34}'`
TELEFONE=`cat $arq |awk -F ";" '{print $35}'`
CELULAR=`cat $arq |awk -F ";" '{print $36}'`
RELEVANCIA=`cat $arq |awk -F ";" '{print $37}'`
CIRCUITO=`cat $arq |awk -F ";" '{print $38}'`

echo $SERVIDOR

