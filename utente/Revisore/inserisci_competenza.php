<?php 
session_start();
require_once "../../config_db/db_connection.php";
$username = $_SESSION['username'];
$tipologia = $_SESSION['tipologia'];
if ($_SERVER["REQUEST_METHOD"] == "POST") {
    try{
        $nome_comp = $_POST["nome_comp"];
        $livello = $_POST["livello"];
    
        $stmt = $db->prepare("CALL Inserire_Competenze(:username, :competenza, :livello,@successo)");
        $stmt->bindParam(':username', $username);
        $stmt->bindParam(':competenza', $nome_comp);
        $stmt->bindParam(':livello', $livello);
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
        <title>ESG Balance - Inserire Competenza</title>
        <link href="../Amministratore/amministratore.css" rel="stylesheet">
        <script src="login_script.js"></script>
    </head>
    <body>
        <div id="user_credentials">
            <p><?php echo $username; ?></p>
            <h6> <?php echo $tipologia; ?></h6>
        </div>
        <h2>Per inserire competenza, per favore compilare il form (*Obbligatorio)</h2>
        <form action="inserisci_competenza.php" method="post">
            <label>Nome della competenza*</label>
            <input type="text" name="nome_comp" required>
            <label>Livello tra 0-5*</label>
            <input type="number" name="livello" required>
            <input type="submit" value="Procedi" id="Associa">
        </form>
    </body>
</html>
