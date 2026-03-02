<?php 
session_start();
require_once "../config_db/db_connection.php";
$username = $_SESSION['username'];
$tipologia = $_SESSION['tipologia'];
if ($_SERVER["REQUEST_METHOD"] == "POST") {
    try{
        $P_Iva = $_POST["P_Iva_Azienda"];
        $bilancio_date = $_POST["data_bilancio"];
        $nome_voc = $_POST["nome_voce"];
        
        $stmt = $db->prepare("CALL Popola_Bilancio(:username, :P_Iva, :data_bilancio, :name_voce, ,@successo)");
        $stmt->bindParam(':username', $username);
        $stmt->bindParam(':P_Iva', $P_Iva);
        $stmt->bindParam(':data_bilancio', $bilancio_date);
        $stmt->bindParam(':name_voce', $nome_voc);
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
        <title>ESG Balance - Popola Bilancio</title>
        <link href="../Amministratore/amministratore.css" rel="stylesheet">
    </head>
    <body>
        <div id="user_credentials">
            <p><?php echo $username; ?></p>
            <h6> <?php echo $tipologia; ?></h6>
        </div>
        <h2>Per aggiungere un voce al bilancio, per favore compilare il form (*Obbligatorio)</h2>
        <form action="popola_bilancio.php" method="post">
            <label>P.Iva dell'azienda proprietaria del bilancio*</label>
            <input type="text" name="P_Iva_Azienda" required>
            <label>Data del Bilancio*</label>
            <input type="date" name="data_bilancio" required>
            <label>Nome del voce*</label>
            <input type="text" name="nome_voce" required>
            <input type="submit" value="Procedi" id="Associa">
        </form>
    </body>
</html>
