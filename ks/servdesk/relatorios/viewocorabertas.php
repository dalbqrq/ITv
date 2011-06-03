<?php               

include("includes/conexao.inc");

$query1="DELETE from ocorabertas";
$abertas1 = mysql_query($query1);


$query="SELECT t.ID, date, t.name as titulo, t.date_mod as datamod, u.firstname as nome, u.realname as sobrenome, e.completename as entidade, priority, p.prioridade as prioridade, p.tempo as tempo, p.descricao as descricao
from glpi_tracking t, glpi_entities e, prioridade p, glpi_users u 
where status<>'old_done' and status<>'old_notdone' and t.FK_entities = e.ID and priority = p.prioridade and u.ID = author"; 

/*
$query="SELECT t.ID, date, t.name as titulo, t.date_mod as datamod, u.firstname as nome, u.realname as sobrenome, e.completename as entidade, priority,p.prioridade as prioridade, p.tempo as tempo, p.descricao as descricao, date_add(date, interval tempo hour) as vencsla, FLOOR(hour(TIMEDIFF( NOW(), date_add(date, interval tempo hour)))/24) as dia, hour(TIMEDIFF( NOW(), date_add(date, interval tempo hour))) - (FLOOR(hour(TIMEDIFF( NOW(), date_add(date, interval tempo hour)))/24))*24 as hora, minute(TIMEDIFF( NOW(), date_add(date, interval tempo hour))) as minuto
from glpi_tracking t, glpi_entities e, prioridade p, glpi_users u
where status<>'old_done'and status<>'old_notdone' and t.FK_entities = e.ID and priority = p.prioridade and u.ID = author";
*/

 

$abertas=mysql_query($query);

while ($listaabertas=mysql_fetch_array($abertas))
{
 
	$ID =  $listaabertas["ID"];
	$entidade = $listaabertas["entidade"];
	$titulo = $listaabertas["titulo"];
	$solicitante = $listaabertas["nome"]." ".$listaabertas["sobrenome"];
	$dataabertura = $listaabertas["date"];
	$dataultatualiz = $listaabertas["datamod"];
//	$datavencsla = $listaabertas[""];
//	$temposeminterv = $listaabertas[""];
	
$insere_sql="INSERT INTO ocorabertas (ID,entidade,titulo,solicitante,dataabertura,dataultatualiz) VALUES ('$ID','$entidade','$titulo','$solicitante','$dataabertura','$dataultatualiz')";
	mysql_query($insere_sql);
	
/*	if (mysql_query($insere_sql)) {
		echo "Prioridade incluida com sucesso!";
	} else {
		echo $insere_sql;
	} */
}

$query3="SELECT ID, entidade, titulo, solicitante, dataabertura, dataultatualiz, timediff(now(),dataultatualiz) as diferenca
from ocorabertas
order by entidade, dataultatualiz"; 

$hoje = date("d/m/Y H:i:s",time());
$datadehoje = explode(" ",$hoje);
$diadehoje = explode("/",$datadehoje[0]);
$dia = $diadehoje[0];
$mes = $diadehoje[1];
$ano = $diadehoje[2];			 
$diasemana = date("w", mktime(0,0,0,$mes,$dia,$ano) );
switch($diasemana) {
		case"0": $diasemana = "Domingo";       break;
		case"1": $diasemana = "Segunda-Feira"; break;
		case"2": $diasemana = "Terça-Feira";   break;
		case"3": $diasemana = "Quarta-Feira";  break;
		case"4": $diasemana = "Quinta-Feira";  break;
		case"5": $diasemana = "Sexta-Feira";   break;
		case"6": $diasemana = "Sábado";        break;}

$abertas3=mysql_query($query3);

?>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<META http-equiv='refresh' content='15' target='main'>
<title>Contole do SLA</title>
<link href="css/estilos.css" rel="stylesheet" type="text/css" />
</head>

<?php

echo "<table width=1200 border=3>";
echo "<tr><th>ÚLTIMA INTERVENÇÃO NAS OCORRÊNCIAS  -  às $hoje h  -  $diasemana</th></tr>";
echo "<table width=1200 border=1>";
echo "<th>ID</th><th>Entidade</th><th>Título</th><th>Solicitante</th><th>Data de Abertura</th><th>Data da Última Intervenção</th><th>Sem Interv.</th>";

while ($listaabertas=mysql_fetch_array($abertas3))
{
    echo "<tr>";
	echo "<td><font size='2pix'>".$listaabertas["ID"]."</td>";
	echo "<td><font size='2pix'>".$listaabertas["entidade"]."</td>";
	echo "<td><font size='2pix'>".$listaabertas["titulo"]."</td>";
	echo "<td><font size='2pix'>".$listaabertas["solicitante"]."</td>";
	$abertura1 = explode(" ",$listaabertas["dataabertura"]);
	$abertura = explode("-",$abertura1[0]);
	$hora = explode(":",$abertura1[1]);
	$dia = $abertura[2];
	$mes = $abertura[1];
	$ano = $abertura[0];			 
	$diasemana = date("w", mktime(0,0,0,$mes,$dia,$ano) );
	switch($diasemana) {
		case"0": $diasemana = "Domingo";       break;
		case"1": $diasemana = "Segunda-Feira"; break;
		case"2": $diasemana = "Terça-Feira";   break;
		case"3": $diasemana = "Quarta-Feira";  break;
		case"4": $diasemana = "Quinta-Feira";  break;
		case"5": $diasemana = "Sexta-Feira";   break;
		case"6": $diasemana = "Sábado";        break;}
    echo "<td><font size='2pix'>".$dia."/".$mes."/".$ano." às ".$hora[0].":".$hora[1]." h"." - ".$diasemana."</td>";
    $abertura1 = explode(" ",$listaabertas["dataultatualiz"]);
	$abertura = explode("-",$abertura1[0]);
	$hora = explode(":",$abertura1[1]);
	$dia = $abertura[2];
	$mes = $abertura[1];
	$ano = $abertura[0];			 
	$diasemana = date("w", mktime(0,0,0,$mes,$dia,$ano) );
	switch($diasemana) {
		case"0": $diasemana = "Domingo";       break;
		case"1": $diasemana = "Segunda-Feira"; break;
		case"2": $diasemana = "Terça-Feira";   break;
		case"3": $diasemana = "Quarta-Feira";  break;
		case"4": $diasemana = "Quinta-Feira";  break;
		case"5": $diasemana = "Sexta-Feira";   break;
		case"6": $diasemana = "Sábado";        break;}
    echo "<td><font size='2pix'>".$dia."/".$mes."/".$ano." às ".$hora[0].":".$hora[1]." h"." - ".$diasemana."</td>";
    if ($listaabertas["diferenca"] < 24){
		$hora = explode(":",$listaabertas["diferenca"]);
		echo "<td class='centralizac'><font size='2pix'>".$hora[0]." h ".$hora[1]." m"."</td>";
	} else {
		$semintervenc = intval($listaabertas["diferenca"]/24);
		if ($semintervenc == 1)
		{
			echo "<td class='centralizac'><font size='2pix'>".$semintervenc." dia "."</td>";	
		}else {		
		echo "<td class='centralizac'><font size='2pix'>".$semintervenc." dias "."</td>";}
	} 
    
    echo "</tr>";
	
}
echo "</table>";
?>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<link href="css/estilos.css" rel="stylesheet" type="text/css" />
</head>

<body>
<table width="600" border="0" align="center">
  <tr>
    <td>&nbsp;</td>
    <td class="centraliza"><label>
      <input name="botao1" type="button" class="botaoretorna" id="botao1" value="Retornar" onclick="location.href='index.php';"/>
    </label></td>
    <td>&nbsp;</td>
  </tr>
</body>

</html>

<?php
mysql_close($conexao);
?>

