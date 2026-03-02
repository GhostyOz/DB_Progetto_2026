<?php 
session_start();
require_once "../../config_db/db_connection.php";
$username = $_SESSION['username'];
$tipologia = $_SESSION['tipologia'];
if ($_SERVER["REQUEST_METHOD"] == "POST") {
    try{
        $rag_soc = $_POST["ragione_sociale"];
        $azienda_nome = $_POST["nome_azienda"];
        $P_Iva = $_POST["P_Iva_Azienda"];
        $set_appar = $_POST["settore"];
        $dipendenti = $_POST["no_dip"];
        $logo = $immagine = $_FILES["logo"]["name"];
        

        $stmt = $db->prepare("CALL Inserire_Azienda(:username, :ragione_sociale, :azienda_name,:P_Iva, :settore, :no_dip,:logo ,@successo)");
        $stmt->bindParam(':username', $username);
        $stmt->bindParam(':ragione_sociale', $rag_soc);
        $stmt->bindParam(':azienda_name', $azienda_nome);
        $stmt->bindParam(':P_Iva', $P_Iva);
        $stmt->bindParam(':settore', $set_appar);
        $stmt->bindParam(':no_dip', $dipendenti);
        $stmt->bindParam(':logo', $logo);
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
        <title>ESG Balance - Registrare Azienda</title>
        <link href="../Amministratore/amministratore.css" rel="stylesheet">
    </head>
    <body>
        <div id="user_credentials">
            <p><?php echo $username; ?></p>
            <h6> <?php echo $tipologia; ?></h6>
        </div>
        <h2>Per registrare una nuova azienda, per favore compilare il form (*obbligatorio)</h2>
        <form action="crea_azienda.php" method="post" enctype="multipart/form-data">
            <label>Ragione Sociale*</label>
            <input type="text" name="ragione_sociale" required>
            <label>Nome dell'azienda*</label>
            <input type="text" name="nome_azienda" required>
            <label>P.Iva dell'azienda proprietaria del bilancio*</label>
            <input type="text" name="P_Iva_Azienda" required>
            <label>Settore di Appartenenza*</label>
            <input type="text" name="settore" required>
            <label>Numero dei dipendenti*</label>
            <input type="number" name="no_dip" required>
            <label>Logo*</label>
            <input type="file" name="logo" required>
            <input type="submit" value="Procedi" id="Associa">
        </form>
    </body>
</html>
