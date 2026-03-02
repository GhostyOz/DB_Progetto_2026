<?php 
session_start();
require_once "../../config_db/db_connection.php";
$username = $_SESSION['username'];
$tipologia = $_SESSION['tipologia'];
if ($_SERVER["REQUEST_METHOD"] == "POST") {
    try{
        $P_Iva = $_POST["P_Iva_Azienda"];
        $stmt = $db->prepare("CALL Crea_Bilancio(:username, :P_Iva,@successo)");
        $stmt->bindParam(':username', $username);
        $stmt->bindParam(':P_Iva', $P_Iva);
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
        <title>ESG Balance - Crea bilancio</title>
        <link href="../Amministratore/amministratore.css" rel="stylesheet">
    </head>
    <body>
        <div id="user_credentials">
            <p><?php echo $username; ?></p>
            <h6> <?php echo $tipologia; ?></h6>
        </div>
        <h2>Per creare un nuovo bilancio, per favore compilare il form (*Obbligatorio)</h2>
        <form action="crea_bilancio.php" method="post">
            <label>P.Iva dell'azienda proprietaria del bilancio*</label>
            <input type="text" name="P_Iva_Azienda" required>
            <input type="submit" value="Procedi" id="Associa">
        </form>
    </body>
</html>
