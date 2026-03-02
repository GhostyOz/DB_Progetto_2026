<?php 
session_start();
require_once "../../config_db/db_connection.php";
$username = $_SESSION['username'];
$tipologia = $_SESSION['tipologia'];
if ($_SERVER["REQUEST_METHOD"] == "POST") {
    try{
        $ind_nom = $_POST["ind_nom"];
        $P_Iva = $_POST["P_Iva_Azienda"];
        $bilancio_date = $_POST["data_bilancio"];
        $nome_voc = $_POST["nome_voce"];
        $val = $_POST["val_ind"];
        $fonte = $_POST["fonte_ind"];

        $stmt = $db->prepare("CALL Inserimento_Rilevazione(:username, :ind_nom, :data_bilancio, :P_Iva, :name_voce, :val, :src ,@successo)");
        $stmt->bindParam(':username', $username);
        $stmt->bindParam(':ind_nom', $ind_nom);
        $stmt->bindParam(':data_bilancio', $bilancio_date);
        $stmt->bindParam(':P_Iva', $P_Iva);
        $stmt->bindParam(':name_voce', $nome_voc);
        $stmt->bindParam(':val', $val);
        $stmt->bindParam(':src', $fonte);
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
        <title>ESG Balance - Inserimento voce al Bilancio</title>
        <link href="../Amministratore/amministratore.css" rel="stylesheet">
    </head>
    <body>
        <div id="user_credentials">
            <p><?php echo $username; ?></p>
            <h6> <?php echo $tipologia; ?></h6>
        </div>
        <h2>Per inserire un voce al bilancio, per favore compilare il form (*Obbligatorio)</h2>
        <form action="inserimento_valore_indicatore_bilancio.php" method="post">
            <label>Nome dell'indicatore*</label>
            <input type="text" name="ind_nom" required>
            <label>Data di Bilancio*</label>
            <input type="date" name="data_bilancio" required>
            <label>P.Iva dell'azienda proprietaria del bilancio*</label>
            <input type="text" name="P_Iva_Azienda" required>
            <label>Nome del voce*</label>
            <input type="text" name="nome_voce" required>
            <label>Valore dall'indicatore*</label>
            <input type="number" name="val_ind" required>
            <label>Fonte della rilevazione* </label>
            <input type="text" name="fonte_ind" required>
            <input type="submit" value="Procedi">
        </form>
    </body>
</html>
