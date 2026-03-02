<?php 
session_start();
require_once "../../config_db/db_connection.php";
$username = $_SESSION['username'];
$tipologia = $_SESSION['tipologia'];
if ($_SERVER["REQUEST_METHOD"] == "POST") {
    try{
        $voce_name = $_POST["voce_name"];
        $descrizione = $_POST["descr_voce"];

        $stmt = $db->prepare("CALL Inserire_Voci(:username, :voce_name, :Descrizione, @successo)");
        $stmt->bindParam(':username', $username);
        $stmt->bindParam(':voce_name', $voce_name);
        $stmt->bindParam(':Descrizione', $descrizione);
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
        <title>ESG Balance - Crea Voce</title>
        <link href="amministratore.css" rel="stylesheet">
    </head>
    <body>
        <div id="user_credentials">
            <p><?php echo $username; ?></p>
            <h6> <?php echo $tipologia; ?></h6>
        </div>
        <h2>Per creare un voce, per favore compilare il form (*obbligatorio)</h2>
        <form action="crea_template.php" method="post">
            <label>Nome del voce*</label>
            <input type="text" name="voce_name" required>
            <label>Descrizione del voce*</label>
            <input type="text" name="descr_voce" required>
            <input type="submit" value="Procedi">
        </form>
    </body>
</html>
