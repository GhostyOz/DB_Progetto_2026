<?php 
session_start();
require_once "../../config_db/db_connection.php";
$username = $_SESSION['username'];
$tipologia = $_SESSION['tipologia'];
if ($_SERVER["REQUEST_METHOD"] == "POST") {
    try{
        $data_bilancio = $_POST["data_bilancio"];
        $P_Iva = $_POST["P_Iva_Azienda"];
        $nom_voc = $_POST["nome_voce"];
        $extra = $_POST["campo_testo"];
    
        $stmt = $db->prepare("CALL Inserire_Giudizio(:username, :data_bilancio, :P_Iva, :nome_voce, :campo_extra,@successo)");
        $stmt->bindParam(':username', $username);
        $stmt->bindParam(':data_bilancio', $data_bilancio);
        $stmt->bindParam(':P_Iva', $P_Iva);
        $stmt->bindParam(':nome_voce', $nom_voc);
        $stmt->bindParam(':campo_extra', $extra);
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
        <title>ESG Balance - Inserire Nota</title>
        <link href="../Amministratore/amministratore.css" rel="stylesheet">
        <script src="login_script.js"></script>
    </head>
    <body>
        <div id="user_credentials">
            <p><?php echo $username; ?></p>
            <h6> <?php echo $tipologia; ?></h6>
        </div>
        <h2>Per inserire una nota, per favore compilare il form (*Obbligatorio)</h2>
        <form action="inserisci_nota.php" method="post">
            <label>Data del bilancio a cui viene inserito la nota*</label>
            <input type="date" name="data_bilancio" required>
            <label>P.Iva dell'azienda proprietaria del bilancio*</label>
            <input type="text" name="P_Iva_Azienda" required>
            <label>Nome del voce*</label>
            <input type="text" name="nome_voce" required>
            <label>Testo aggiuntivo*</label>
            <input type="text" name="campo_testo" required>
            <input type="submit" value="Procedi" id="Associa">
        </form>
    </body>
</html>
