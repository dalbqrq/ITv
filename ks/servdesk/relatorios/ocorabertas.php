<?php  //              ****  INÍCIO OCORRÊNCIAS ABERTAS SEM ATENDIMENTO  ****
//$conexao=mysql_connect("nnm.verto.com.br","root","V#rt018!");
//$conexao=mysql_connect("localhost","root","");
//mysql_select_db("glpi"); 

include("includes/conexao.inc");

$query="SELECT t.ID, date, t.name as titulo, u.firstname as nome, u.realname as sobrenome, e.completename as entidade, FLOOR(hour(TIMEDIFF( NOW(), date))/24) as dia, hour(TIMEDIFF( NOW(), date)) - (FLOOR(hour(TIMEDIFF( NOW(), date))/24))*24 as hora, minute(TIMEDIFF( NOW(), date)) as minuto, priority, p.prioridade as prioridade, p.tempo as tempo, p.descricao as descricao from glpi_tickets t, glpi_entities e, prioridade p, glpi_users u where closedate is null and status='new' and t.entities_id = e.ID and priority = p.prioridade and u.ID = t.users_id order by e.completename, dia desc, hora desc, minuto desc";
$hoje=date("d/m/y H:i:s");
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

$abertas=mysql_query($query);

?>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<META http-equiv='refresh' content='15' target='main'>
<title>Ocor. sem Atendim.</title>
<link href="css/estilos.css" rel="stylesheet" type="text/css" />
</head>

<?php

echo "<head><META http-equiv='refresh' content='15' target='main'></head>";
echo "<table width=1200 border=3>";
echo "<tr><th>NOVAS OCORRÊNCIAS SEM INÍCIO DE ATENDIMENTO  -  às  $hoje h  -  $diasemana</th></tr>";
echo "<table width=1200 border=1>";
//echo "<th>ID</th><th>Entidade</th><th>Título</th><th>Solicitante</th><th>Data de Abertura</th><th><font size='2pix'>Dias</th><th><font size='2pix'>Horas</th><th><font size='2pix'>Min</th><th>Prior.</th><th>Vencimento SLA</th>";
echo "<th>ID</th><th>Entidade</th><th>Título</th><th>Solicitante</th><th>Data de Abertura</th><th>Prior.</th><th>Vencimento SLA</th>";
echo $listaabaertas["prioridade"];
while ($listaabertas=mysql_fetch_array($abertas))
{
    echo "<tr>";
	echo "<td><font size='2pix'>".$listaabertas["ID"]."</td>";
	echo "<td><font size='2pix'>".$listaabertas["entidade"]."</td>";
	echo "<td><font size='2pix'>".$listaabertas["titulo"]."</td>";
	$solicitante = $listaabertas["nome"]." ".$listaabertas["sobrenome"]; 
	echo "<td><font size='2pix'>".$solicitante."</td>";
    $novadata=explode("-",$listaabertas["date"]);
	$acerta=explode(":",$novadata[2]);
	$acerta1=explode(" ",$acerta[0]);
	$dia = $acerta1[0];
	$mes = $novadata[1];
	$ano = $novadata[0];			 
	$diasemanaabertura = date("w", mktime(0,0,0,$mes,$dia,$ano) );
	switch($diasemanaabertura) {
			case"0": $diasemanaabertura = "Domingo";       break;
			case"1": $diasemanaabertura = "Segunda-Feira"; break;
			case"2": $diasemanaabertura = "Terça-Feira";   break;
			case"3": $diasemanaabertura = "Quarta-Feira";  break;
			case"4": $diasemanaabertura = "Quinta-Feira";  break;
			case"5": $diasemanaabertura = "Sexta-Feira";   break;
			case"6": $diasemanaabertura = "Sábado";        break;}
	echo "<td><font size='2pix'>".$acerta1[0]."/".$novadata[1]."/".$novadata[0]."  às  ".$acerta1[1].":".$acerta[1]." h"." - ".$diasemanaabertura."</td>";

$processado = 0;	

/*
// total horas úteis decorridas em dias inteiros	
	$totalminutosuteis = 0;
	If ($listaabertas["dia"]> 0) {	
	 	$totalminutosuteis = ($listaabertas["dia"] - 1) * 9 * 60;
	 }	
	
// da data de abertura, horas decorridas
	$minutosuteisdiaabertura=(18*60)-($acerta1[1]*60+$acerta[1]); 

	$novadata=getdate();
	$horas=$novadata["hours"];
	$minutos=$novadata["minutes"];	
	
// do dia de consulta, horas decorridas	
	$minutosuteisdiaconsulta=($horas*60+$minutos)-(9*60);

	$sladecorrido = $totalminutosuteis + $minutosuteisdiaabertura + $minutosuteisdiaconsulta;

// dias, horas e minutos	
	$totalhorasdecorridas = $sladecorrido/60;
//	$minutosdecorridos = $horasdecorridas - intval($sladecorrido/60);
	if ($totalhorasdecorridas > 24) {
		$diasdecorridos = intval($totalhorasdecorridas/24);
		$horasdecorridas = (($totalhorasdecorridas/24) - $diasdecorridos)*24;
		$minutosdecorridos = intval((($horasdecorridas/24) - intval($horasdecorridas/24))*60);
		$horasdecorridas = intval($horasdecorridas);
	}


    if ($diasdecorridos== 0) {
	 echo "<td>"."-"."</td>"; 
	 }else {
	 echo "<td class='direita'>".$diasdecorridos."</td>";
	 }
	if ($horasdecorridas == 0) {
	 echo "<td>"."-"."</td>"; 
	 }else {
	 echo "<td class='direita'>".$horasdecorridas."</td>";
	 }
	if ($minutosdecorridos == 0) {
	 echo "<td>"."-"."</td>"; 
	 }else {
	 echo "<td class='direita'>".$minutosdecorridos."</td>";
	 }


	
	$hoje = getdate($listaabertas["date"]);	 
	if ($listaabertas["dia"]== 0) {
	 echo "<td>"."-"."</td>"; 
	 }else {
	 echo "<td class='direita'>".$listaabertas["dia"]."</td>";
	 }
	if ($listaabertas["hora"]== 0) {
	 echo "<td>"."-"."</td>"; 
	 }else {
	 echo "<td class='direita'>".$listaabertas["hora"]."</td>";
	 }
	if ($listaabertas["minuto"]== 0) {
	 echo "<td>"."-"."</td>"; 
	 }else {
	 echo "<td class='direita'>".$listaabertas["minuto"]."</td>";
	 }
*/	
	echo "<td><font size='2pix'>".$listaabertas["descricao"]."</td>";
	$tempo = strval($listaabertas["tempo"]);
	
	$novadata=explode("-",$listaabertas["date"]);
	$acerta=explode(":",$novadata[2]);
	$acerta1=explode(" ",$acerta[0]);
	$dia = $acerta1[0];
	$mes = $novadata[1];
	$ano = $novadata[0];			 
	$diasemanaabertura = date("w", mktime(0,0,0,$mes,$dia,$ano) ); 
	switch($diasemanaabertura) {
			case"0": $diasemanaabertura = "Domingo" and $processado == 0; 
			    $sla = "+"."1"."day";
				$datavenc = date("d/m/y H:i", strtotime($sla, strtotime( $listaabertas["date"] ) ) ); 
				$horavenc = 9 + $tempo;
				if ($horavenc <= 18 )  {	
				 	$hora = $horavenc.":"."00";
				 	$datavenc1 = explode(" ",$datavenc);
					$diasemanavenc = explode("/",$datavenc1[0]);					
		 			$dia = $diasemanavenc[0];
					$mes = $diasemanavenc[1];
					$ano = $diasemanavenc[2];			 
					$diasemana = date("w", mktime(0,0,0,$mes,$dia,$ano) );
					switch($diasemana) {
							case"0": $diasemana = "Domingo";       break;
							case"1": $diasemana = "Segunda-Feira"; break;
							case"2": $diasemana = "Terça-Feira";   break;
							case"3": $diasemana = "Quarta-Feira";  break;
							case"4": $diasemana = "Quinta-Feira";  break;
							case"5": $diasemana = "Sexta-Feira";   break;
							case"6": $diasemana = "Sábado";        break;}
					
		 			echo "<td><font size='2pix'>".$diasemanavenc[0]."/".$diasemanavenc[1]."/".$diasemanavenc[2]."  às  ".$hora." h"." - ".$diasemana."</td>";		
/*		 			$agora = strtotime(now);
					$slavenc = strtotime("$diasemana");	
					echo $listaabertas["ID"]." "."$diasemana"; 
		 			if ($agora > $slavenc){echo "<td><font size='2pix'><font color='red'>".$diasemanavenc[0]."/".$diasemanavenc[1]."/".$diasemanavenc[2]."  às  ".$hora." h"." - ".$diasemana."</td>";} else {echo "<td><font size='2pix'>".$diasemanavenc[0]."/".$diasemanavenc[1]."/".$diasemanavenc[2]."  às  ".$hora." h"." - ".$diasemana."</td>";} */
		 			$processado = 1;
				} 					
			break;
			case"5": $diasemanaabertura = "Sexta-Feira" and $processado == 0;  
// INICIO - OCORRENCIAS ABERTAS SEXTA-FEIRA ANTES DAS 9:00H		
			if ($acerta1[1] < 9 ){  
	 		$horavenc = 9 + $tempo;
	 		if ($horavenc > 18 and $horavenc < 24 ){ // VENCIMENTO APÓS 18:00H DE SEXTA-FEIRA - SLA > 10 H	 
			  	$sla = "+"." "."3"."day";
				$datavenc = date("d/m/y H:i", strtotime($sla, strtotime( $listaabertas["date"] ) ) ); 
				$venc=explode(" ",$datavenc);
				$tempo = $tempo + (9 - $acerta1[1]);
				$sla = "+"." ".$tempo."hour";
				$datahoravenc1 = date("d/m/y H:i", strtotime($sla, strtotime( $listaabertas["date"] ) ) );
				$venc1=explode(" ",$datahoravenc1);
				$horavenc1 = explode(":",$venc1[1]);
				if ($horavenc1[0] > 18 )  {	 // VENCIMENTO APÓS 18:00H DE SEGUNDA-FEIRA	 	
				 	$sla = "+"." "."3"."day";
					$datavenc = date("d/m/y H:i", strtotime($sla, strtotime( $listaabertas["date"] ) ) ); 
					$venc=explode(" ",$datavenc);
					$hora = $horavenc1[0] - 18;
					$hora = $hora + 9;
					$hora = $hora.":"."00";
					} else {
					$hora = 9 - $horavenc1[0];
					$hora = $hora.":"."00";}
				$diasemanavenc = explode("/",$venc[0]);					
	 			$dia = $diasemanavenc[0];
				$mes = $diasemanavenc[1];
				$ano = $diasemanavenc[2];			 
				$diasemana = date("w", mktime(0,0,0,$mes,$dia,$ano) );
				switch($diasemana) {
						case"0": $diasemana = "Domingo";       break;
						case"1": $diasemana = "Segunda-Feira"; break;
						case"2": $diasemana = "Terça-Feira";   break;
						case"3": $diasemana = "Quarta-Feira";  break;
						case"4": $diasemana = "Quinta-Feira";  break;
						case"5": $diasemana = "Sexta-Feira";   break;
						case"6": $diasemana = "Sábado";        break;}
			
	/*		$slavenc = strtotime("$diasemanavenc");	
			$agora = strtotime(now);
			if ($datavenc < $agora){echo "<td><font size='2pix'><font color='red'>".$venc[0]."  às  ".$hora." h"." - ".$diasemana."</td>";} else {echo "<td><font size='2pix'>".$venc[0]."  às  ".$hora." h"." - ".$diasemana."</td>";}	 */		
	 			echo "<td><font size='2pix'>".$venc[0]."  às  ".$hora." h"." - ".$diasemana."</td>";
	 			$processado = 1;
			}elseif ($horavenc <= 18 and $horavenc >= 9 and $processado == 0)
// VENCIMENTO DENTRO DO HORÁRIO COMERCIAL DE SEXTA-FEIRA - SLA ATÉ 9 HORAS
				{
			 $dia = $acerta1[0];
			 $mes = $novadata[1];
			 $ano = $novadata[0];			 
			 $diasemana = date("w", mktime(0,0,0,$mes,$dia,$ano) );
			 switch($diasemana) {
					case"0": $diasemana = "Domingo";       break;
					case"1": $diasemana = "Segunda-Feira"; break;
					case"2": $diasemana = "Terça-Feira";   break;
					case"3": $diasemana = "Quarta-Feira";  break;
					case"4": $diasemana = "Quinta-Feira";  break;
					case"5": $diasemana = "Sexta-Feira";   break;
					case"6": $diasemana = "Sábado";        break; }					
			
			$slavenc = strtotime("$diasemanavenc");	
/*			$agora = strtotime(now);
			if ($datavenc < $agora){echo "<td><font size='2pix'><font color='red'>".$venc[0]."  às  ".$hora." h"." - ".$diasemana."</td>";} else {echo "<td><font size='2pix'>".$venc[0]."  às  ".$hora." h"." - ".$diasemana."</td>";}			
		   echo "<td><font size='2pix'>".$acerta1[0]."/".$novadata[1]."/"."10"."  às  ".$horavenc.":"."00"." h"." - ".$diasemana."</td>"; */
		   $processado = 1;
		   	 }elseif ($horavenc >= 24 and $processado == 0){
					$sla = "+"." "."4"."day";
					$datavenc = date("d/m/y H:i", strtotime($sla, strtotime( $listaabertas["date"] ) ) );
					$datavenc1 = explode(" ",$datavenc);
					$horavenc = $horavenc - 18;
					$horavenc = 9 + $horavenc;
					$hora = $horavenc.":"."00";
					$diasemanavenc = explode("/",$datavenc1[0]);					
		 			$dia = $diasemanavenc[0];
					$mes = $diasemanavenc[1];
					$ano = $diasemanavenc[2];			 
					$diasemana = date("w", mktime(0,0,0,$mes,$dia,$ano) );
					switch($diasemana) {
							case"0": $diasemana = "Domingo";       break;
							case"1": $diasemana = "Segunda-Feira"; break;
							case"2": $diasemana = "Terça-Feira";   break;
							case"3": $diasemana = "Quarta-Feira";  break;
							case"4": $diasemana = "Quinta-Feira";  break;
							case"5": $diasemana = "Sexta-Feira";   break;
							case"6": $diasemana = "Sábado";        break;}
		 			echo "<td><font size='2pix'>".$diasemanavenc[0]."/".$diasemanavenc[1]."/".$diasemanavenc[2]."  às  ".$hora." h"." - ".$diasemana."</td>";
		 			$processado = 1; }
					 }
		
// FIM - OCORRENCIAS ABERTAS SEXTA-FEIRA ANTES DAS 9:00H
			
			if ($acerta1[1] >= 18) {
			 		$sla = "+"."3"."day";
					$datavenc = date("d/m/y H:i", strtotime($sla, strtotime( $listaabertas["date"] ) ) ); 
					$horavenc = 9 + $tempo;
			 	if ($horavenc <= 18 )  {				 	
					$hora = $horavenc.":"."00";
				 	$datavenc1 = explode(" ",$datavenc);
					$diasemanavenc = explode("/",$datavenc1[0]);					
		 			$dia = $diasemanavenc[0];
					$mes = $diasemanavenc[1];
					$ano = $diasemanavenc[2];			 
					$diasemana = date("w", mktime(0,0,0,$mes,$dia,$ano) );
					switch($diasemana) {
							case"0": $diasemana = "Domingo";       break;
							case"1": $diasemana = "Segunda-Feira"; break;
							case"2": $diasemana = "Terça-Feira";   break;
							case"3": $diasemana = "Quarta-Feira";  break;
							case"4": $diasemana = "Quinta-Feira";  break;
							case"5": $diasemana = "Sexta-Feira";   break;
							case"6": $diasemana = "Sábado";        break;}
					
/*					$slavenc = strtotime("$datavenc");
					$agora = strtotime(now);
					if ($datavenc < $agora){echo "<td><font size='2pix'><font color='red'>".$diasemanavenc[0]."/".$diasemanavenc[1]."/".$diasemanavenc[2]."  às  ".$hora." h"." - ".$diasemana."</td>";} else {echo "<td><font size='2pix'>".$diasemanavenc[0]."/".$diasemanavenc[1]."/".$diasemanavenc[2]."  às  ".$hora." h"." - ".$diasemana."</td>";}
//		 			echo "<td><font size='2pix'>".$diasemanavenc[0]."/".$diasemanavenc[1]."/".$diasemanavenc[2]."  às  ".$hora." h"." - ".$diasemana."</td>"; */
		 			$processado = 1; 
		 		}else {
					$sla = "+"."4"."day";
					$datavenc = date("d/m/y H:i", strtotime($sla, strtotime( $listaabertas["date"] ) ) ); 
					$datavenc1 = explode(" ",$datavenc);
					$horavenc = $horavenc - 18;
					$horavenc = 9 + $horavenc;
					$hora = $horavenc.":"."00";
					$diasemanavenc = explode("/",$datavenc1[0]);					
		 			$dia = $diasemanavenc[0];
					$mes = $diasemanavenc[1];
					$ano = $diasemanavenc[2];			 
					$diasemana = date("w", mktime(0,0,0,$mes,$dia,$ano) );
					switch($diasemana) {
							case"0": $diasemana = "Domingo";       break;
							case"1": $diasemana = "Segunda-Feira"; break;
							case"2": $diasemana = "Terça-Feira";   break;
							case"3": $diasemana = "Quarta-Feira";  break;
							case"4": $diasemana = "Quinta-Feira";  break;
							case"5": $diasemana = "Sexta-Feira";   break;
							case"6": $diasemana = "Sábado";        break;}
		 			echo "<td><font size='2pix'>".$diasemanavenc[0]."/".$diasemanavenc[1]."/".$diasemanavenc[2]."  às  ".$hora." h"." - ".$diasemana."</td>";
		 			$processado = 1; }
				}else {
				if ($acerta1[1] < 18 and $acerta1[1] >= 9 and $processado == 0){
						$sla = "+"." ".$tempo."hour";
						$datahoravenc = date("d/m/y H:i", strtotime($sla, strtotime( $listaabertas["date"] ) ) ); 
					    $venc=explode(" ",$datahoravenc);
						$horavenc = explode(":",$venc[1]);
						if ($horavenc[0] >= 18 or $horavenc[0] < 9 ){	 		
							$sla = "+"." "."3"."day";
							$datahoravenc = date("d/m/y", strtotime($sla, strtotime( $listaabertas["date"] ) ) ); 
							$venc=explode(" ",$datahoravenc);
							$sla = "+"." ".$tempo."hour";
							$datahoravenc1 = date("d/m/y H:i", strtotime($sla, strtotime( $listaabertas["date"] ) ) );
							$venc1=explode(" ",$datahoravenc1);
							$horavenc1 = explode(":",$venc1[1]);
							if ($horavenc1[0] >= 18 )  {			
							 	$hora = $horavenc1[0] - 18;
								$hora = $hora + 9;
								$hora = $hora.":".$horavenc1[1];
								} elseif ($horavenc1[0] >= 0 and $horavenc1[0] <= 9 ) {
								$complemento = 18 - $acerta1[1];
								$complemento1 = $tempo - $complemento;
								$hora = 9 + $complemento1;
								$hora = $hora.":".$horavenc1[1];
							}
							if ($hora >= 18){
								$sla = "+"." "."4"."day";
								$datahoravenc = date("d/m/y", strtotime($sla, strtotime( $listaabertas["date"] ) ) ); 
								$venc=explode(" ",$datahoravenc);
								$hora = $hora - 18;
								$hora = 9 + $hora ;
								$hora = $hora.":".$horavenc1[1];				
							}	
							$diasemanavenc = explode("/",$venc[0]);					
				 		    $dia = $diasemanavenc[0];
							$mes = $diasemanavenc[1];
							$ano = $diasemanavenc[2];			 
							 $diasemana = date("w", mktime(0,0,0,$mes,$dia,$ano) );
							 switch($diasemana) {
									case"0": $diasemana = "Domingo";       break;
									case"1": $diasemana = "Segunda-Feira"; break;
									case"2": $diasemana = "Terça-Feira";   break;
									case"3": $diasemana = "Quarta-Feira";  break;
									case"4": $diasemana = "Quinta-Feira";  break;
									case"5": $diasemana = "Sexta-Feira";   break;
									case"6": $diasemana = "Sábado";        break;}
							echo "<td><font size='2pix'>".$venc[0]." às ".$hora." h"." - ".$diasemana."</td>";
							$processado = 1;	 		
						}else {
						 $diasemanavenc = explode("/",$venc[0]);					
					 			$dia = $diasemanavenc[0];
								$mes = $diasemanavenc[1];
								$ano = $diasemanavenc[2];				 
						 $diasemana = date("w", mktime(0,0,0,$mes,$dia,$ano) );
						 switch($diasemana) {
								case"0": $diasemana = "Domingo";       break;
								case"1": $diasemana = "Segunda-Feira"; break;
								case"2": $diasemana = "Terça-Feira";   break;
								case"3": $diasemana = "Quarta-Feira";  break;
								case"4": $diasemana = "Quinta-Feira";  break;
								case"5": $diasemana = "Sexta-Feira";   break;
								case"6": $diasemana = "Sábado";        break;}		 
							echo "<td><font size='2pix'>".$venc[0]." às ".$venc[1]." h"." - ".$diasemana."</td>";
							$processado = 1;
						} 
					} 	
				}	
			break;
			case"6": $diasemanaabertura = "Sábado" and $processado == 0;   
				$sla = "+"."2"."day";
				$datavenc = date("d/m/y H:i", strtotime($sla, strtotime( $listaabertas["date"] ) ) ); 
				$horavenc = 9 + $tempo;
				if ($horavenc <= 18 )  {	
				 	$hora = $horavenc.":"."00";
				 	$datavenc1 = explode(" ",$datavenc);
					$diasemanavenc = explode("/",$datavenc1[0]);					
		 			$dia = $diasemanavenc[0];
					$mes = $diasemanavenc[1];
					$ano = $diasemanavenc[2];			 
					$diasemana = date("w", mktime(0,0,0,$mes,$dia,$ano) );
					switch($diasemana) {
							case"0": $diasemana = "Domingo";       break;
							case"1": $diasemana = "Segunda-Feira"; break;
							case"2": $diasemana = "Terça-Feira";   break;
							case"3": $diasemana = "Quarta-Feira";  break;
							case"4": $diasemana = "Quinta-Feira";  break;
							case"5": $diasemana = "Sexta-Feira";   break;
							case"6": $diasemana = "Sábado";        break;}
		 			echo "<td><font size='2pix'>".$diasemanavenc[0]."/".$diasemanavenc[1]."/".$diasemanavenc[2]."  às  ".$hora." h"." - ".$diasemana."</td>";
		 			$processado = 1; 
		 		}elseif ($horavenc > 18 )  {
					$sla = "+"."3"."day";
					$datavenc = date("d/m/y H:i", strtotime($sla, strtotime( $listaabertas["date"] ) ) ); 
					$datavenc1 = explode(" ",$datavenc);
					$horavenc = $horavenc - 18;
					$horavenc = 9 + $horavenc;
					$hora = $horavenc.":"."00";
					$diasemanavenc = explode("/",$datavenc1[0]);					
		 			$dia = $diasemanavenc[0];
					$mes = $diasemanavenc[1];
					$ano = $diasemanavenc[2];			 
					$diasemana = date("w", mktime(0,0,0,$mes,$dia,$ano) );
					switch($diasemana) {
							case"0": $diasemana = "Domingo";       break;
							case"1": $diasemana = "Segunda-Feira"; break;
							case"2": $diasemana = "Terça-Feira";   break;
							case"3": $diasemana = "Quarta-Feira";  break;
							case"4": $diasemana = "Quinta-Feira";  break;
							case"5": $diasemana = "Sexta-Feira";   break;
							case"6": $diasemana = "Sábado";        break;}
		 			echo "<td><font size='2pix'>".$diasemanavenc[0]."/".$diasemanavenc[1]."/".$diasemanavenc[2]."  às  ".$hora." h"." - ".$diasemana."</td>";
		 			$processado = 1; }
			break;
			default:
				$processado = 0;
				break;
	}
// *** DE SEGUNDA A QUINTA ***
	if ($acerta1[1] < 9 and $processado == 0){
	 		$horavenc = 9 + $tempo;
	 		if ($horavenc > 18 or $horavenc < 9 ){ 
			  	$sla = "+"." "."1"."day";
				$datavenc = date("d/m/y H:i", strtotime($sla, strtotime( $listaabertas["date"] ) ) ); 
				$venc=explode(" ",$datavenc);
				$tempo = $tempo + (9 - $acerta1[1]);
				$sla = "+"." ".$tempo."hour";
				$datahoravenc1 = date("d/m/y H:i", strtotime($sla, strtotime( $listaabertas["date"] ) ) );
				$venc1=explode(" ",$datahoravenc1);
				$horavenc1 = explode(":",$venc1[1]);
				if ($horavenc1[0] > 18 )  {			
				 	$hora = $horavenc1[0] - 18;
					$hora = $hora + 9;
					$hora = $hora.":"."00";
					} else {
					$hora = 9 - $horavenc1[0];
					$hora = $hora.":"."00";}
				$diasemanavenc = explode("/",$venc[0]);					
	 			$dia = $diasemanavenc[0];
				$mes = $diasemanavenc[1];
				$ano = $diasemanavenc[2];			 
				$diasemana = date("w", mktime(0,0,0,$mes,$dia,$ano) );
				switch($diasemana) {
						case"0": $diasemana = "Domingo";       break;
						case"1": $diasemana = "Segunda-Feira"; break;
						case"2": $diasemana = "Terça-Feira";   break;
						case"3": $diasemana = "Quarta-Feira";  break;
						case"4": $diasemana = "Quinta-Feira";  break;
						case"5": $diasemana = "Sexta-Feira";   break;
						case"6": $diasemana = "Sábado";        break;}
/*			$agora = strtotime(now);
			$slavenc = strtotime("$diasemanavenc");			
			if ($slavenc < $datavenc){echo "<td><font size='2pix'><font color='red'>".$venc[0]."  às  ".$hora." h"." - ".$diasemana."</td>";} else {echo "<td><font size='2pix'>".$venc[0]."  às  ".$hora." h"." - ".$diasemana."</td>";}	*/		
	 			echo "<td><font size='2pix'>".$venc[0]."  às  ".$hora." h"." - ".$diasemana."</td>";
	 			$processado = 1;
			}else 
/*			{
			 if ($somadia != 0){
				$sla = "+"." "."1"."day";
				$datahoravenc = date("d/m/y", strtotime($sla, strtotime( $listaabertas["date"] ) ) ); 
				$venc=explode(" ",$datahoravenc);
				$sla = "+"." ".$tempo."hour";
				$datahoravenc1 = date("d/m/y H:i", strtotime($sla, strtotime( $listaabertas["date"] ) ) );
				$venc1=explode(" ",$datahoravenc1);
				$horavenc1 = explode(":",$venc1[1]);
				if ($horavenc1[0] > 18 )  {			
				 	$hora = $horavenc1[0] - 18;
					$hora = $hora + 9;
					$hora = $hora.":".$horavenc1[1];
					} else {
					$hora = 9 - $horavenc1[0];
					$hora = $hora.":".$horavenc1[1];
				}
				 $diasemanavenc = explode("/",$venc[0]);					
		 			$dia = $diasemanavenc[0];
					$mes = $diasemanavenc[1];
					$ano = $diasemanavenc[2];			 
				 $diasemana = date("w", mktime(0,0,0,$mes,$dia,$ano) );
				 switch($diasemana) {
						case"0": $diasemana = "Domingo";       break;
						case"1": $diasemana = "Segunda-Feira"; break;
						case"2": $diasemana = "Terça-Feira";   break;
						case"3": $diasemana = "Quarta-Feira";  break;
						case"4": $diasemana = "Quinta-Feira";  break;
						case"5": $diasemana = "Sexta-Feira";   break;
						case"6": $diasemana = "Sábado";        break;}
				echo "<td><font size='2pix'>".$venc[0]." às ".$hora." h"." - ".$diasemana."</td>";
				} else */
				{		 
			 $dia = $acerta1[0];
			 $mes = $novadata[1];
			 $ano = $novadata[0];			 
			 $diasemana = date("w", mktime(0,0,0,$mes,$dia,$ano) );
			 switch($diasemana) {
					case"0": $diasemana = "Domingo";       break;
					case"1": $diasemana = "Segunda-Feira"; break;
					case"2": $diasemana = "Terça-Feira";   break;
					case"3": $diasemana = "Quarta-Feira";  break;
					case"4": $diasemana = "Quinta-Feira";  break;
					case"5": $diasemana = "Sexta-Feira";   break;
					case"6": $diasemana = "Sábado";        break; }
/*			$agora = strtotime(now);
			$slavenc = strtotime("$diasemanavenc");			
			if ($datavenc  < $agora){echo "<td><font size='2pix'><font color='red'>".$venc[0]."  às  ".$hora." h"." - ".$diasemana."</td>";} else {echo "<td><font size='2pix'>".$venc[0]."  às  ".$hora." h"." - ".$diasemana."</td>";} */			
		   echo "<td><font size='2pix'>".$acerta1[0]."/".$novadata[1]."/"."10"."  às  ".$horavenc.":"."00"." h"." - ".$diasemana."</td>";
		   $processado = 1;
		   }
			}
//	}
	if ($acerta1[1] >= 18 and $processado == 0){
			$sla = "+"." "."1"."day";
			$datahoravenc = date("d/m/y H:i", strtotime($sla, strtotime( $listaabertas["date"] ) ) ); 
			$venc=explode(" ",$datahoravenc);
			$hora = explode(":",$venc[1]);
			$hora[0] = 9 + $tempo;
			$hora[1] = "00";
			if ($hora [0]> 18){
				$sla = "+"." "."2"."day";
				$datahoravenc = date("d/m/y H:i", strtotime($sla, strtotime( $listaabertas["date"] ) ) ); 
				$venc=explode(" ",$datahoravenc);
				$hora[0] = $hora[0] - 18;
				$hora[0] = $hora[0] + 9;				
			}
			$diasemanavenc = explode("/",$venc[0]);					
	 		$dia = $diasemanavenc[0];
			$mes = $diasemanavenc[1];
			$ano = $diasemanavenc[2];	
			$diasemana = date("w", mktime(0,0,0,$mes,$dia,$ano) );
				switch($diasemana) {
						case"0": $diasemana = "Domingo";       break;
						case"1": $diasemana = "Segunda-Feira"; break;
						case"2": $diasemana = "Terça-Feira";   break;
						case"3": $diasemana = "Quarta-Feira";  break;
						case"4": $diasemana = "Quinta-Feira";  break;
						case"5": $diasemana = "Sexta-Feira";   break;
						case"6": $diasemana = "Sábado";        break;}
//			$agora = strtotime(now);
//			$slavenc = strtotime("$diasemanavenc");			
//			if ($slavenc < $agora){echo "<td><font size='2pix'><font color='red'>".$venc[0]."  às  ".$hora." h"." - ".$diasemana."</td>";} else {echo "<td><font size='2pix'>".$venc[0]."  às  ".$hora." h"." - ".$diasemana."</td>";}					
			echo "<td><font size='2pix'>".$venc[0]." às ".$hora[0].":".$hora[1]." h"." - ".$diasemana."</td>";
			$processado = 1;
		}
	if ($acerta1[1] < 18 and $acerta1[1] >= 9 and $processado == 0){
		$sla = "+"." ".$tempo."hour";
		$datahoravenc = date("d/m/y H:i", strtotime($sla, strtotime( $listaabertas["date"] ) ) ); 
	    $venc=explode(" ",$datahoravenc);
		$horavenc = explode(":",$venc[1]);
		if ($horavenc[0] >= 18 or $horavenc[0] < 9 ){	 		
			$sla = "+"." "."1"."day";
			$datahoravenc = date("d/m/y", strtotime($sla, strtotime( $listaabertas["date"] ) ) ); 
			$venc=explode(" ",$datahoravenc);
			$sla = "+"." ".$tempo."hour";
			$datahoravenc1 = date("d/m/y H:i", strtotime($sla, strtotime( $listaabertas["date"] ) ) );
			$venc1=explode(" ",$datahoravenc1);
			$horavenc1 = explode(":",$venc1[1]);
			if ($horavenc1[0] >= 18 )  {			
			 	$hora = $horavenc1[0] - 18;
				$hora = $hora + 9;
				$hora = $hora.":".$horavenc1[1];
				} elseif ($horavenc1[0] >= 0 and $horavenc1[0] <= 9 ) {
				$complemento = 18 - $acerta1[1];
				$complemento1 = $tempo - $complemento;
				$hora = 9 + $complemento1;
				$hora = $hora.":".$horavenc1[1];
			}
			if ($hora >= 18){
				$sla = "+"." "."2"."day";
				$datahoravenc = date("d/m/y", strtotime($sla, strtotime( $listaabertas["date"] ) ) ); 
				$venc=explode(" ",$datahoravenc);
				$hora = $hora - 18;
				$hora = 9 + $hora ;
				$hora = $hora.":".$horavenc1[1];				
			}	
			$diasemanavenc = explode("/",$venc[0]);					
 		    $dia = $diasemanavenc[0];
			$mes = $diasemanavenc[1];
			$ano = $diasemanavenc[2];			 
			 $diasemana = date("w", mktime(0,0,0,$mes,$dia,$ano) );
			 switch($diasemana) {
					case"0": $diasemana = "Domingo";       break;
					case"1": $diasemana = "Segunda-Feira"; break;
					case"2": $diasemana = "Terça-Feira";   break;
					case"3": $diasemana = "Quarta-Feira";  break;
					case"4": $diasemana = "Quinta-Feira";  break;
					case"5": $diasemana = "Sexta-Feira";   break;
					case"6": $diasemana = "Sábado";        break;}
			echo "<td><font size='2pix'>".$venc[0]." às ".$hora." h"." - ".$diasemana."</td>";
			$processado = 1;	 		
		}else {
		 $diasemanavenc = explode("/",$venc[0]);					
	 			$dia = $diasemanavenc[0];
				$mes = $diasemanavenc[1];
				$ano = $diasemanavenc[2];				 
		 $diasemana = date("w", mktime(0,0,0,$mes,$dia,$ano) );
		 switch($diasemana) {
				case"0": $diasemana = "Domingo";       break;
				case"1": $diasemana = "Segunda-Feira"; break;
				case"2": $diasemana = "Terça-Feira";   break;
				case"3": $diasemana = "Quarta-Feira";  break;
				case"4": $diasemana = "Quinta-Feira";  break;
				case"5": $diasemana = "Sexta-Feira";   break;
				case"6": $diasemana = "Sábado";        break;}		 
			echo "<td><font size='2pix'>".$venc[0]." às ".$venc[1]." h"." - ".$diasemana."</td>";
			$processado = 1;
		} 
	} 
		
	echo "</tr>";
	
}

$query1="select prioridade, descricao, tempo from prioridade order by prioridade";
$prioridades = mysql_query($query1, $conexao);

echo "<tr>";
echo "</table>";

echo "<table width=400 border=3>";
echo "<tr><th><font size='2pix'>Tempo de Fechamento por Prioridade</th></tr>";
echo "<table width=400 border=1>";
echo "<th><font size='2pix'>Prioridade</th><th><font size='2pix'>Fechamento em</th>";

while ($listasla=mysql_fetch_array($prioridades))
{

	echo "<tr>";
	echo "<td><font size='2pix'>".$listasla["descricao"]."</td>";
	echo "<td class='centralizatabela'><font size='2pix'>".$listasla["tempo"]." horas"."</td>";
	echo "<tr>";
		
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
