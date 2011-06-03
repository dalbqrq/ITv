<?php
if (isset($_POST["cadastrar"])) {
	include "includes/conexao.inc";
	$descricao=$_POST["descricao"];
	$tempo=$_POST["tempo"];
	$insere_sql="INSERT INTO prioridade (descricao, tempo) VALUES ('$descricao', '$tempo')";
	if (mysql_query($insere_sql)) {
		echo "Prioridade incluida com sucesso!";
	} else {
		echo $insere_sql;
	}
	mysql_close($conexao);
}
?>
<html>
<head><title></title></head>
<body>
<h1>Cadastramento de Prioridades</h1>
<form name="cad" action="incluir_prioridades.php" method="post">
<label>Descrição</label><br>
<input type="text" name="descricao" size="25" maxlength="25">
<p>
<label>Tempo</label><br>
<input type="text" name="tempo" size="15" maxlength="15">
<p><input type="submit" name="cadastrar" value="Cadastrar">
</form>
<html>