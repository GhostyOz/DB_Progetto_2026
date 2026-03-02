<?php 
session_start();
require_once "../config_db/db_connection.php";
$username = $_SESSION['username'];
$tipologia = $_SESSION['tipologia'];
$count_az = $db->query(" SELECT * FROM COUNT_Aziende") ->fetch();
$count_rev = $db->query(" SELECT * FROM COUNT_Revisori")->fetch();
$max_affidabile = $db->query(" SELECT * FROM Max_Affidabilita")->fetch();
?>
<!DOCTYPE Html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>ESG Balance - Associazione Revisore</title>
        <link href="viste.css" rel="stylesheet">
    </head>
    <body>
        <div id="user_credentials">
            <p><?php echo $username; ?></p>
            <h6> <?php echo $tipologia; ?></h6>
        </div>
        <h2>Qua, si puo' vedere vari dati ricavati dal sistema ESG Balance</h2>
        <p>Ci sono <span> <?php echo($count_az); ?> </span> aziende registrate nella nostra piattaforma</p>
        <p>Ci sono <span> <?php echo($count_rev); ?> </span> revisori ESG registrate nella nostra piattaforma</p>
        <p>Azienda piu' affidabile e' <span> <?php echo($max_affidabile["Nome"]); ?> </span> con un indice di affidabilita <span><?php echo($max_affidabile["Affidabilita"]); ?></span></p>
        <p> Primi 10 aziende con bilanci piu' revisati <br> </p>
        <?php foreach($db->query(" SELECT * FROM Classifica_Bilanci") as $row){
            echo("Nome dell'azienda: {$row['Nome_Azienda']}, Data di bilancio: {$row['Data_Bilancio']}, Numero dei indicatori presenti: {$row['No_Indicatori']} <br>");
        }
        ?>
    </body>
</html>