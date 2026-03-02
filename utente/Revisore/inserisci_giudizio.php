<?php 
session_start();
require_once "../../config_db/db_connection.php";
$username = $_SESSION['username'];
$tipologia = $_SESSION['tipologia'];
if ($_SERVER["REQUEST_METHOD"] == "POST") {
    try{
        $data_bilancio = $_POST["data_bilancio"];
        $P_Iva = $_POST["P_Iva_Azienda"];
        $esito = $_POST["Esito_giud"];
        $extra = $_POST["campo_extra"];
        if(empty($extra)){
            $extra = 'Non inserita';
        }
    
        $stmt = $db->prepare("CALL Inserire_Giudizio(:data_bilancio,:P_Iva,:username, :esito, :campo_extra,@successo)");
        $stmt->bindParam(':data_bilancio', $data_bilancio);
        $stmt->bindParam(':P_Iva', $P_Iva);
        $stmt->bindParam(':username', $username);
        $stmt->bindParam(':esito', $esito);
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
        <title>ESG Balance - Inserire Giudizio</title>
        <link href="../Amministratore/amministratore.css" rel="stylesheet">
    </head>
    <body>
        <div id="user_credentials">
            <p><?php echo $username; ?></p>
            <h6> <?php echo $tipologia; ?></h6>
        </div>
        <h2>Per inserire un giudizio, per favore compilare il form (*Obbligatorio)</h2>
        <form action="inserisci_giudizio.php" method="post">
            <label>Data del bilancio a cui viene inserito il giudizio*</label>
            <input type="date" name="data_bilancio" required>
            <label>P.Iva dell'azienda proprietaria del bilancio*</label>
            <input type="text" name="P_Iva_Azienda" required>
            <label>Scegliere l'esito*</label>
            <select name="Esito_giud" id="esito_giudizio" > 
                <option value="approvazione">approvazione</option>
                <option value="approvazione con rilievi">approvazione con rilievi</option>
                <option value="respingimento">respingimento</option>
            </select>
            <label>Testo aggiuntivo (facoltativo)</label>
            <input type="text" name="campo_extra">
            <input type="submit" value="Procedi" id="Associa">
        </form>
    </body>
</html>
