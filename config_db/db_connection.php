<?php 
    try{
        $db = new PDO('mysql:host=127.0.0.1;port=3306;dbname=SISTEMA','root','SQLOZAn5!.');
        //var_dump($db); // Verifica che il server e' connesso con database e funziona tramite richiesta dal web
    }
    catch(PDOException $e){
        die("Errore di connessione: " . $e->getMessage()); // Se non riesce. aconnettersi, muore
    }
    
?>