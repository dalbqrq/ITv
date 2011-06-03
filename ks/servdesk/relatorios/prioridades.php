<?php

/**
 * @author 
 * @copyright 2010
 */

include "includes/conexao.inc";

if (isset($_POST["excluir"])) {
	foreach ($_POST as $chave=>$valor) {
		if (substr($chave,0,2)=="id") {		    
			$sql="delete from prioridade where prioridade=$valor";
			mysql_query($sql);
		}
	}
}

$sql="select prioridade, descricao, tempo from prioridade order by prioridade";
$prioridades = mysql_query($sql, $conexao);
if (mysql_num_rows($prioridades)==0)
{
    echo "Não foi localizado nenhum registro!";
}
?>
<html>
<head>
<title>Prioridades</title>
<style type="text/css">
.tabela {
    width: 650px;    
}
.td0 {
    width: 20px;
    border-width: 1px;
    border-color: #0080FF;
    border-style:solid;
}
.td1 {
    width: 340px;
    border-width: 1px;
    border-color: #0080FF;
    border-style:solid;
}
.td2 {
    width: 290px;
    border-width: 1px;
    border-color: #0080FF;
    border-style:solid;
}
</style>
</head>
<body>
<form name="prioridades" action="prioridades.php" method="post">
<table class="tabela">
<tr><th class="td0">&nbsp;</th><th class="td1">Descrição</th><th class="td2">Tempo</th></tr>
<?php
$num=1;
while ($prioridade=mysql_fetch_array($prioridades))
{
?>
<tr>
<td class="td0"><input type="checkbox" name="id<?php echo $num; ?>" value="<?php echo $prioridade['prioridade']; ?>">
<td class="td1"><a href="edita_prioridade.php?idp=<?php echo $prioridade["prioridade"]; ?>"><?php echo $prioridade["descricao"];?></a></td><td class="td2"><?php echo $prioridade["tempo"];?></td></tr>  
<?php  
$num++;
}
?>
</table>
<input type="button" name="incluir" value="Incluir Prioridade" onclick="location.href='incluir_prioridades.php';">
<input type="submit" name="excluir" value="Excluir Selecionados">
<input type="button" name="incluir" value="Retornar" onclick="location.href='index.php';">
</form>
</body>
</html>
<?php mysql_close($conexao); ?>