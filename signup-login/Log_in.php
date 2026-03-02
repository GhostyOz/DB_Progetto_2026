<?php
require_once "../config_db/db_connection.php";
if ($_SERVER["REQUEST_METHOD"] == "POST") {
    try{
    $username = $_POST["username"];
    $password = $_POST["password"];
    $stmt = $db->prepare("CALL Login(:username, :password, @successo)");
    $stmt->bindParam(':username', $username);
    $stmt->bindParam(':password', $password);
    $stmt->execute();

    $result = $db->query("SELECT @successo AS successo")->fetch();
    $successo = $result['successo'];
    if($successo ==1){
        $stmt2 = $db->prepare("SELECT Tipologia_Utente FROM UTENTE WHERE Username = :username");
        $stmt2->bindParam(':username', $username);
        $stmt2->execute();
        $row = $stmt2->fetch();
        $type = $row['Tipologia_Utente'];
        $_SESSION['username'] = $username;
        $_SESSION['tipologia'] = $type;
        header("Location: ../Utente//dashboard.php");
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
        <title>ESG Balance - Log in</title>
        <link href="login_style.css" rel="stylesheet">
        <script src="login_script.js"></script>
    </head>
    <body>
        <h2>Ben tornato! Accedi al sistema inserendo le tue credenziali</h2>
        <form action="Log_in.php" method="post">
            <label>Username</label>
            <input type="text" name="username">
            <label>Password</label>
            <input type="password" name="password">
            <input type="submit" value="Log in" id="log">
        </form>
    </body>
</html>
