<?php
include "includes/conexao.inc";

if (isset($_POST["alterar"])) {
	$prd = $_POST["prioridade"];
	$tempo=$_POST["tempo"];
	$altera_sql="UPDATE prioridade SET tempo='$tempo' WHERE prioridade=$prd";
	if (mysql_query($altera_sql)) {
		header("Location:prioridades.php");
	} else {
		echo $altera_sql;
		exit;
	}
	
}
$idp = $_GET["idp"];
$sql = "select prioridade, descricao, tempo from prioridade where prioridade=$idp";
$prioridades = mysql_query($sql) or die($sql);
if (mysql_num_rows($prioridades)==0) {
   echo "Prioridade não localizada no banco de dados!";
   exit;
}
$prioridade = mysql_fetch_array($prioridades);
?>
<html>
<head><title></title></head>
<body>
<h1>Alteração de Prioridade</h1>
<form name="cad" action="edita_prioridade.php" method="post">
<input type="hidden" name="prioridade" value="<?php echo $prioridade["prioridade"]; ?>">
<label>Descrição</label><br>
<input type="text" name="descricao" size="25" maxlength="25" value="<?php echo $prioridade['descricao']; ?>" readonly>
<p>
<label>Tempo</label><br>
<input type="text" name="tempo" size="15" maxlength="15"  value="<?php echo $prioridade['tempo']; ?>" >
<p><input type="submit" name="alterar" value="Alterar">
</form>
<html>
<?php
mysql_close($conexao);
?>