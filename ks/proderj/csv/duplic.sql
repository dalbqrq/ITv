

mysql> select * from (select count(*) as c, name from glpi_computers group by name) as duplic where c > 1;
+---+-------------------+
| c | name              |
+---+-------------------+
| 2 | Alcatraz          |
| 2 | Andorinha         |
| 2 | Azulona           |
| 2 | Barulhento        |
| 2 | CABURE            |
| 2 | Cotinga           |
| 2 | Foguinho          |
| 2 | Gaturamo          |
| 2 | See_Srv01         |
| 2 | Tiziu             |
| 2 | VIDEO_CONFERENCIA |
+---+-------------------+
11 rows in set (0.00 sec)

mysql> select * from (select count(*) as c, name from glpi_networkequipments group by name) as duplic where c > 1;
+---+-------------+
| c | name        |
+---+-------------+
| 2 | SEPLAG      |
| 2 | SWBLADEPROD |
+---+-------------+

