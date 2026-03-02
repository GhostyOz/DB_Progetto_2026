<?php 
session_start();
require_once "../../config_db/db_connection.php";
$username = $_SESSION['username'];
$tipologia = $_SESSION['tipologia'];
if ($_SERVER["REQUEST_METHOD"] == "POST") {
    try{
        $revisore_name = $_POST["username_revisore"];
        $P_Iva = $_POST["P_Iva_Azienda"];
        $Bilancio_date = $_POST["Data_Bilancio"];

        $stmt = $db->prepare("CALL Inserire_Valutazione(:username, :revisore_name,:P_Iva, :Bilancio_date,@successo)");
        $stmt->bindParam(':username', $username);
        $stmt->bindParam(':revisore_name', $revisore_name);
        $stmt->bindParam(':P_Iva', $P_Iva);
        $stmt->bindParam(':Bilancio_date', $Bilancio_date);
        $stmt->execute();

        $result = $db->query("SELECT @successo AS successo")->fetch();
        $successo = $result['successo'];
        if($successo == 1){
            echo "<script>
            alert('Operazione eseguita con successo! Verrai reindirizzato alla dashboard.');
            window.location.href = 'dashboard.php';
            </script>";
        }
    }
    catch(PDOException $e){
        $parti = explode('1644 ', $e->getMessage());
        echo $parti[1];
    }
}

?>
<!DOCTYPE Html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>ESG Balance - Associazione Revisore</title>
        <link href="amministratore.css" rel="stylesheet">
    </head>
    <body>
        <div id="user_credentials">
            <p><?php echo $username; ?></p>
            <h6> <?php echo $tipologia; ?></h6>
        </div>
        <h2>Per associare una revisore, per favore compilare il form (*obligatorio)</h2>
        <form action="associa_revisore.php" method="post">
            <label>Username del Revisore*</label>
            <input type="text" name="username_revisore"required>
            <label>P.Iva dell'azienda proprietaria del bilancio*</label>
            <input type="text" name="P_Iva_Azienda"required>
            <label>Data del bilancio di associazione*</label>
            <input type="date" name="Data_Bilancio"required>
            <input type="submit" value="Procedi" id="Associa">
        </form>
    </body>
</html>
