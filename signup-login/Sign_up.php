<?php 
require_once "../config_db/db_connection.php";
if ($_SERVER["REQUEST_METHOD"] == "POST") {
    try{
        $tipologia = $_POST["Tipologia"];
        $codfis = $_POST["codice_fiscale"];
        $username = $_POST["username"];
        $password = $_POST["password"];
        $luogonasc = $_POST["luogo_nasc"];
        $datanasc = $_POST["data_nasc"];
        if($tipologia =="Amministratore"){
            $stmt = $db->prepare("CALL Signup_Amministratore(:codicefis, :username, :password,:datanasc, :luogonasc, @successo)");
            $stmt->bindParam(':codicefis', $codfis);
            $stmt->bindParam(':username', $username);
            $stmt->bindParam(':password', $password);
            $stmt->bindParam(':datanasc', $datanasc);
            $stmt->bindParam(':luogonasc', $luogonasc);
            $stmt->execute();

            $result = $db->query("SELECT @successo AS successo")->fetch();
            $successo = $result['successo'];
        }
        elseif($tipologia =="Revisore"){
            $stmt = $db->prepare("CALL Signup_Revisore(:codicefis, :username, :password,:datanasc, :luogonasc, @successo)");
            $stmt->bindParam(':codicefis', $codfis);
            $stmt->bindParam(':username', $username);
            $stmt->bindParam(':password', $password);
            $stmt->bindParam(':datanasc', $datanasc);
            $stmt->bindParam(':luogonasc', $luogonasc);
            $stmt->execute();

            $result = $db->query("SELECT @successo AS successo")->fetch();
            $successo = $result['successo'];
        }
        else{
            $cv_file = $_FILES["cv"]["name"];
            $stmt = $db->prepare("CALL Signup_Responsabile(:codicefis, :username, :password,:datanasc, :luogonasc, :cvfile, @successo)");
            $stmt->bindParam(':codicefis', $codfis);
            $stmt->bindParam(':username', $username);
            $stmt->bindParam(':password', $password);
            $stmt->bindParam(':datanasc', $datanasc);
            $stmt->bindParam(':luogonasc', $luogonasc);
            $stmt->bindParam(':cvfile', $cv_file);
            $stmt->execute();

            $result = $db->query("SELECT @successo AS successo")->fetch();
            $successo1 = $result['successo'];
        }
        $recapiti = $_POST["mail"];
        foreach($recapiti as $mail){
            $stmt2 = $db->prepare("CALL Inserire_Recapito(:username, :email)");
            $stmt2->bindParam(':username', $username);
            $stmt2->bindParam(':email', $mail);
            $stmt2->execute();
        }
        if($successo == 1){
            echo "<script>
            alert('Registrazione eseguita con successo! Verrai reindirizzato alla pagina di login.');
            window.location.href = 'Log_in.php';
            </script>";
        }
    }
    catch(PDOException $e){
        echo($e->getMessage());
        /*$parti = explode('1644 ', $e->getMessage());
        echo $parti[1];*/
    }
}
?>
<!DOCTYPE Html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>ESG Balance - Sign up</title>
        <link href="signup_style.css" rel="stylesheet">
        <script src="signup_script.js" defer></script>
    </head>
    <body>
        <h2>Benvenuto al ESG Balance, scegli la tipologia dell'utente per favore</h2>
        <form action="Signup.php" method="post" id="sign_form" enctype="multipart/form-data">
            <select name="Tipologia" id="tipoutente" > 
            <option value="Amministratore">Amministratore</option>
            <option value="Revisore">Revisore ESG</option>
            <option value="Responsabile">Responsabile Aziendale</option>
            </select>
            <div id="personalized_signup" class="wait">
                <label>Codice Fiscale</label>
                <input type="text" name="codice_fiscale" required>
                <label>Username</label>
                <input type="text" name="username"required>
                <label>Password (deve essere 10 caratteri)</label>
                <input type="text" name="password"required>
                <label>Luogo Nascita</label>
                <input type="text" name="luogo_nasc"required>
                <label>Data Nascita</label>
                <input type="date" name="data_nasc"required>
                <label id="mail_label" >E-mail</label>
                <input type="email" name="mail[]" required>
                <button id="nuovo_mail"> Aggiungi un altro</button>
                <input type="submit" value="Sign up" id="sign">
            </div>
        </form>        
    </body>
</html>