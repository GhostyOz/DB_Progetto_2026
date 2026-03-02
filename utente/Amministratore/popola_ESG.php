<?php 
session_start();
require_once "../../config_db/db_connection.php";
$username = $_SESSION['username'];
$tipologia = $_SESSION['tipologia'];
if ($_SERVER["REQUEST_METHOD"] == "POST") {
    try{
        $tipo_esg = $_POST["Ind_typ"];
        $nome_Indicatore = $_POST["ind_nome"];
        $rilevanza = $_POST["rilevanza"];
        $immagine = $_FILES["img"]["name"];
        if($tipo_esg == "Ambientale" ){
            $codice_normativo = $_POST["cod_norm"];
            $stmt = $db->prepare("CALL Inserire_Indicatore_Ambientale(:username, :ind_nome,:rilevanza, :img,:codice, @successo)");
            $stmt->bindParam(':username', $username);
            $stmt->bindParam(':ind_nome', $nome_Indicatore);
            $stmt->bindParam(':rilevanza', $rilevanza);
            $stmt->bindParam(':img', $immagine);
            $stmt->bindParam(':codice', $codice_normativo);
            $stmt->execute();
            $result = $db->query("SELECT @successo AS successo")->fetch();
            $successo = $result['successo'];
        }
        else if($tipo_esg == "Sociale" ){
            $ambito_sociale = $_POST["ambito_soc"];
            $frequenza = $_POST["freq"];
            $stmt = $db->prepare("CALL Inserire_Indicatore_Sociale(:username, :ind_nome,:rilevanza, :img, :ambito_soc, :freq ,@successo)");
            $stmt->bindParam(':username', $username);
            $stmt->bindParam(':ind_nome', $nome_Indicatore);
            $stmt->bindParam(':rilevanza', $rilevanza);
            $stmt->bindParam(':img', $immagine);
            $stmt->bindParam(':ambito_soc', $ambito_sociale);
            $stmt->bindParam(':freq', $frequenza);
            $stmt->execute();
            $result = $db->query("SELECT @successo AS successo")->fetch();
            $successo = $result['successo'];
        }
        else{
            $stmt = $db->prepare("CALL Inserire_Indicatore_ESG(:username, :ind_nome,:rilevanza, :img, @successo)");
            $stmt->bindParam(':username', $username);
            $stmt->bindParam(':ind_nome', $nome_Indicatore);
            $stmt->bindParam(':rilevanza', $rilevanza);
            $stmt->bindParam(':img', $immagine);
            $stmt->execute();
            $result = $db->query("SELECT @successo AS successo")->fetch();
            $successo = $result['successo'];
        }

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
        <title>ESG Balance - Popola Indicatore ESG</title>
        <link href="amministratore.css" rel="stylesheet">
        <script src="popola_esg.js"></script>
    </head>
    <body>
        <div id="user_credentials">
            <p><?php echo $username; ?></p>
            <h6> <?php echo $tipologia; ?></h6>
        </div>
        <h2>Per popolare un indicatore ESG, per favore compilare il form (*obbligatorio)</h2>
        <form action="popola_ESG.php" method="post" enctype="multipart/form-data">
            <label>Scegliere la tipologia dell'indicatore da inserire*</label>
            <select name="Ind_typ" id="type_indicatore" > 
                <option value="Altro">Altro / ESG Normale</option>
                <option value="Ambientale">ESG Ambientale</option>
                <option value="Sociale">ESG Sociale</option>
            </select>
            
            <label>Nome dell'Indicatore*</label>
            <input type="text" name="ind_nome" required>
            <label>Rilevanza (tra 0-10)*</label>
            <input type="number" name="rilevanza" required>
            <label>Immagine*</label>
            <input type="file" name="img">

            <div id="ambientale" class="reserved">
                <label>Codice della normativa*</label>
                <input type="text" name="cod_norm" required>
            </div>

            <div id="sociale" class="reserved">
                <label>Ambito sociale che tratta*</label>
                <input type="text" name="ambito_soc" required>
                <label>Frequenza (Ogni quanti giorni)*</label>
                <input type="number" name="freq" required>
            </div>
            <input type="submit" value="Procedi">
        </form>
    </body>
</html>

