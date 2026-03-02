<?php 
require_once "../config_db/db_connection.php";
session_start();
$username = $_SESSION['username'];
$tipologia = $_SESSION['tipologia'];
?>
<!DOCTYPE Html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>ESG Balance - Dashboard Amministratore</title>
        <link href="dash_style.css" rel="stylesheet">
        <script src="dash_script.js" defer></script>
    </head>
    <body>
        <div id="user_credentials">
            <p><?php echo $username; ?></p>
            <h6> <?php echo $tipologia; ?></h6>
        </div>
        <h4 id="salute">Benvenuto <?php echo $username; ?></h4>
        <p>Cosa vorresti fare oggi?</p>
        <div>
                <div id="operazioni_Amministratore" class="reserved">
                <button id="popola_ESG">Popolare un indicatore ESG</button>
                <button id="crea_template">Creare un nuovo voce template</button>
                <button id="associa_revisore">Associa un revisore ad un bilancio</button>
            </div>
            <div id="operazioni_Responsabile" class="reserved">
                <button id="crea_azienda">Registrare un'azienda</button>
                <button id="crea_bilancio">Creare un Bilancio</button>
                <button id="popola_bilancio">Popolare un Bilancio</button>
                <button id="inserimento_valore_indicatore_bilancio">Inserire dei valori degli indicatori ESG per singole voci di bilancio</button>
            </div>
            <div id="operazioni_Revisore" class="reserved">
                <button id="inserisci_competenza">Inserire una competenza</button>
                <button id="inserisci_nota">Inserire una nota</button>
                <button id="inserisci_giudizio">Inserire un giudizio</button>
            </div>
            <button id="viste">Vedere varie statistiche riguarda il sistema</button>
        </div>
    </body>
</html>
 