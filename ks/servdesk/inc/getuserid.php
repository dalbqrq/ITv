<?php

define('GLPI_ROOT', '/usr/local/servdesk');
include (GLPI_ROOT . "/inc/includes.php");

$userID = getLoginUserID();

if ($userID) {
   echo "$userID";
}
else {
   echo "none";
}

?>


