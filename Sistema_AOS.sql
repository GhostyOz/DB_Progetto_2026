DROP DATABASE IF EXISTS SISTEMA;
CREATE DATABASE SISTEMA;
USE SISTEMA;

CREATE TABLE UTENTE(
	Codice_Fiscale VARCHAR(11) PRIMARY KEY,
    Username VARCHAR(20) UNIQUE,
    Pwd VARCHAR(10),
    Data_Nascita DATE,
    Luogo_Nascita VARCHAR(30),
    Tipologia_Utente ENUM('Amministratore','Revisore','Responsabile') #Aggiunto per rendere piu' facile la web-side
) Engine=InnoDb;
CREATE TABLE UTENTE_Amministratore(
	Codice_Fiscale VARCHAR(11) PRIMARY KEY,
    Username VARCHAR(20)UNIQUE,
    Pwd VARCHAR(10),
    Data_Nascita DATE,
    Luogo_Nascita VARCHAR(30),
    FOREIGN KEY (Codice_Fiscale) REFERENCES UTENTE(Codice_Fiscale)
) Engine=InnoDb;
CREATE TABLE UTENTE_Revisore(
	Codice_Fiscale VARCHAR(11) PRIMARY KEY,
    Username VARCHAR(20)UNIQUE,
    Pwd VARCHAR(10),
    Data_Nascita DATE,
    Luogo_Nascita VARCHAR(30),
    No_Revisione SMALLINT DEFAULT 0,
    Indice_Affidabilita SMALLINT DEFAULT 0,
    FOREIGN KEY (Codice_Fiscale) REFERENCES UTENTE(Codice_Fiscale)
) Engine=InnoDb;
CREATE TABLE UTENTE_Responsabile(
	Codice_Fiscale VARCHAR(11) PRIMARY KEY,
    Username VARCHAR(20)UNIQUE,
    Pwd VARCHAR(10),
    Data_Nascita DATE,
    Luogo_Nascita VARCHAR(30),
    CV VARCHAR (255),
    FOREIGN KEY (Codice_Fiscale) REFERENCES UTENTE(Codice_Fiscale)
) Engine=InnoDb;
CREATE TABLE RECAPITI_Mail(
	CodFis VARCHAR(11),
    Mail VARCHAR (30),
    PRIMARY KEY (CodFis,Mail),
    FOREIGN KEY (CodFis) REFERENCES UTENTE(Codice_Fiscale)
)Engine=InnoDb;
CREATE TABLE COMPETENZE_Dichiarate(
	Nome_Competenza VARCHAR(30),
    CodFis_Revisore VARCHAR(11),
    Livello SMALLINT NOT NULL CHECK (Livello BETWEEN 0 AND 5),
    PRIMARY KEY (Nome_Competenza,CodFis_Revisore),
    FOREIGN KEY (CodFis_Revisore) REFERENCES UTENTE_Revisore(Codice_Fiscale)
) Engine=InnoDb;
CREATE TABLE AZIENDA(
	Ragione_Sociale VARCHAR(255)  PRIMARY KEY,
    Nome VARCHAR(30) NOT NULL,
    P_Iva VARCHAR (30) UNIQUE,
    Settore_Appartenenza VARCHAR(30),
    No_Dipendenti SMALLINT,
    Logo VARCHAR(255),
    No_Bilancio SMALLINT DEFAULT 0,
    CodFis_Responsabile VARCHAR(11),
    FOREIGN KEY (CodFis_Responsabile) REFERENCES UTENTE_Responsabile(Codice_Fiscale)
) Engine=InnoDb;
CREATE TABLE BILANCIO(
	Data_Creazione DATE,
    P_Iva_Azienda VARCHAR(30),
    Stato ENUM('bozza', 'in revisione', 'approvato', 'respinto') DEFAULT 'bozza',
    PRIMARY KEY (Data_Creazione,P_Iva_Azienda),
    FOREIGN KEY (P_Iva_Azienda) REFERENCES AZIENDA(P_Iva)
) Engine=InnoDb;
CREATE TABLE VALUTAZIONE_Bilancio(
	CodFis_Revisore VARCHAR(11),
    Data_Bilancio DATE,
    P_Iva_Azienda VARCHAR(30),
    Esito_Giudizio ENUM ('approvazione', 'approvazione con rilievi', 'respingimento')DEFAULT NULL, 
    Data_Giudizio DATE DEFAULT NULL,
    Campo_Extra_Giudizio TINYTEXT DEFAULT NULL,
    PRIMARY KEY (CodFis_Revisore,Data_Bilancio,P_Iva_Azienda),
    FOREIGN KEY (Data_Bilancio,P_Iva_Azienda) REFERENCES BILANCIO(Data_Creazione,P_Iva_Azienda),
    FOREIGN KEY (CodFis_Revisore) REFERENCES UTENTE_Revisore(Codice_Fiscale)
    
)Engine=InnoDb;
CREATE TABLE INDICATORE_ESG(
	Nome VARCHAR(30) PRIMARY KEY,
    Rilevanza SMALLINT CHECK (Rilevanza BETWEEN 1 AND 10) ,
    Img_Rappresentativa VARCHAR(255)
)Engine=InnoDb;
CREATE TABLE INDICATORE_ESG_Ambientale(
	Nome VARCHAR(30) PRIMARY KEY,
    Rilevanza SMALLINT CHECK (Rilevanza BETWEEN 1 AND 10),
    Img_Rappresentativa VARCHAR(255),
    Codice_Normativo_Rilevamento VARCHAR(30),
    FOREIGN KEY (Nome) REFERENCES INDICATORE_ESG(Nome)
)Engine=InnoDb;
CREATE TABLE INDICATORE_ESG_Sociale(
	Nome VARCHAR(30) PRIMARY KEY,
    Rilevanza SMALLINT CHECK (Rilevanza BETWEEN 1 AND 10),
    Img_Rappresentativa VARCHAR(255),
    Ambito_Sociale_Rilevamento VARCHAR(30),
    Frequenza_Rilevazione SMALLINT,
    FOREIGN KEY (Nome) REFERENCES INDICATORE_ESG(Nome)
)Engine=InnoDb;
CREATE TABLE VOCI(
	Nome VARCHAR(30) PRIMARY KEY,
    Descrizione TINYTEXT
) Engine=InnoDb;
CREATE TABLE ASSEGNO_Numero_Voci(
	Data_Bilancio DATE,
    P_Iva_Azienda VARCHAR(30),
    Nome_Voce VARCHAR(30),
    Valore_Numerico INT AUTO_INCREMENT UNIQUE,
    PRIMARY KEY(Data_Bilancio,P_Iva_Azienda,Nome_Voce),
    FOREIGN KEY (Data_Bilancio,P_Iva_Azienda) REFERENCES BILANCIO(Data_Creazione,P_Iva_Azienda),
    FOREIGN KEY (Nome_Voce) REFERENCES VOCI(Nome)
)Engine=InnoDb;
CREATE TABLE NOTA(
CodFis_Revisore VARCHAR(11),
    Data_Bilancio DATE,
    P_Iva_Azienda VARCHAR(30),
    Nome_Voce VARCHAR(30),
    Data_Nota DATE,
    Testo_Nota TINYTEXT,
    PRIMARY KEY (CodFis_Revisore,Data_Bilancio,P_Iva_Azienda,Nome_Voce),
    FOREIGN KEY (Data_Bilancio,P_Iva_Azienda) REFERENCES BILANCIO(Data_Creazione,P_Iva_Azienda),
    FOREIGN KEY (CodFis_Revisore) REFERENCES UTENTE_Revisore(Codice_Fiscale),
    FOREIGN KEY (Nome_Voce) REFERENCES VOCI(Nome)
)Engine=InnoDb;
CREATE TABLE INSERIMENTO_Bilancio(
	Nome_Indicatore VARCHAR(30),
    Data_Bilancio DATE,
    P_Iva_Azienda VARCHAR(30),
    Nome_Voce VARCHAR(30),
    Valore SMALLINT NOT NULL,
    Fonte VARCHAR(30),
    Data_Rilevazione DATE,
    PRIMARY KEY (Nome_Indicatore,Data_Bilancio,P_Iva_Azienda,Nome_Voce),
    FOREIGN KEY (Data_Bilancio,P_Iva_Azienda) REFERENCES BILANCIO(Data_Creazione,P_Iva_Azienda),
    FOREIGN KEY (Nome_Indicatore) REFERENCES INDICATORE_ESG(Nome),
    FOREIGN KEY (Nome_Voce) REFERENCES VOCI(Nome)
)Engine=InnoDb;

DROP ROLE IF EXISTS Amministratore, Revisore, Responsabile;
CREATE ROLE Amministratore, Revisore, Responsabile;
GRANT SELECT ON SISTEMA.UTENTE TO Amministratore, Revisore, Responsabile; #Il permesso per registrazione

#Statistiche visibile a tutti
CREATE VIEW COUNT_Aziende (No_Aziende) AS
	SELECT COUNT(*) AS No_Aziende
	FROM AZIENDA;

CREATE VIEW COUNT_Revisori (No_Revisori) AS
	SELECT COUNT(*) AS No_Revisori
	FROM UTENTE_Revisore;
    
#Una view solo successi un altro solo non successi e il terzo per calcolare la percentuale e quarto per tirare il nome dalla P_Iva    
CREATE VIEW Approvati (No_approvato,P_Iva) AS
	SELECT COUNT(Esito_Giudizio),P_Iva_Azienda
    FROM VALUTAZIONE_Bilancio
    WHERE (Esito_Giudizio = 'approvazione')
    GROUP BY P_Iva_Azienda;
    
CREATE VIEW Tutti (No_tutti,P_Iva) AS
	SELECT COUNT(*),P_Iva_Azienda #Mettendo * prendo anche i valori null
    FROM VALUTAZIONE_Bilancio
    GROUP BY P_Iva_Azienda;
    
CREATE VIEW Tabella_Affidabilita (Nome,Affidabilita) AS
	SELECT Nome,No_approvato/No_tutti*100 AS Affidabilita
    FROM Approvati JOIN Tutti ON Approvati.P_Iva = Tutti.P_Iva JOIN AZIENDA ON Approvati.P_Iva = AZIENDA.P_Iva
    ORDER BY Affidabilita DESC;
    
CREATE VIEW Max_Affidabilita(Nome,Affidabilita) AS
	SELECT * FROM Tabella_Affidabilita LIMIT 1;
    

CREATE VIEW Classifica_Bilanci (No_Indicatori,Data_Bilancio,Nome_Azienda) AS
	SELECT COUNT(*) AS No_Indicatori,Data_Bilancio,
		(SELECT Nome FROM AZIENDA WHERE(P_Iva = P_Iva_Azienda)) 
    FROM INSERIMENTO_Bilancio JOIN AZIENDA ON INSERIMENTO_Bilancio.P_Iva_Azienda = AZIENDA.P_Iva
    GROUP BY Data_Bilancio, P_Iva_Azienda
    ORDER BY COUNT(Nome_Indicatore) DESC
    LIMIT 99999
    
	
# I trigger

#Dato che per la valutazione, serve almeno una revisore, per forza appena viene registrato al tabello revisione, lo stato sara' in revisione
DELIMITER $
CREATE TRIGGER Cambia_Stato_Bilancio
	AFTER INSERT ON VALUTAZIONE_Bilancio
    FOR EACH ROW
    BEGIN
		UPDATE BILANCIO
		SET Stato = 'in revisione' WHERE (P_Iva_Azienda = NEW.P_Iva_Azienda AND Data_Creazione = NEW.Data_Bilancio AND Stato = 'bozza') ;
	END$
DELIMITER ;

#Prendo identificatore_bilancio dell ultimo valutazione aggiunto, guardo se tutti giudizi sono apposto se si cambio
DELIMITER $
CREATE TRIGGER Cambia_Stato_Definito
	AFTER UPDATE ON VALUTAZIONE_Bilancio
    FOR EACH ROW
    BEGIN
		DECLARE valid BOOLEAN;
        DECLARE respinto BOOLEAN;
        DECLARE giudizio_status VARCHAR(30);
		DECLARE cur CURSOR FOR
        SELECT DISTINCT Esito_Giudizio FROM VALUTAZIONE_Bilancio WHERE (P_Iva_Azienda = NEW.P_Iva_Azienda AND Data_Bilancio = NEW.Data_Bilancio);
        DECLARE CONTINUE HANDLER FOR NOT FOUND SET valid = FALSE;
        SET valid = TRUE;
        SET respinto = FALSE;
        OPEN cur;
		WHILE Valid DO
			FETCH cur INTO giudizio_status;
            IF(giudizio_status IS NULL) THEN
				SET valid = FALSE;
                SET respinto = TRUE; #Fatto per bypassare l'operazione sotto
			ELSEIF (giudizio_status ='respingimento') THEN
				UPDATE BILANCIO
				SET Stato = 'respinto' 
                WHERE (P_Iva_Azienda = NEW.P_Iva_Azienda AND Data_Creazione = NEW.Data_Bilancio);
				SET valid = FALSE;
                SET respinto = TRUE;
			END IF;
		END WHILE;
        IF respinto = FALSE THEN
			UPDATE BILANCIO SET Stato = 'approvato' WHERE (P_Iva_Azienda = NEW.P_Iva_Azienda AND Data_Creazione = NEW.Data_Bilancio);
		END IF;
        
    END$
DELIMITER;
# Per il campo No_Revisione del revisore
DELIMITER $
CREATE TRIGGER Incrementa_No_Revisioni
	AFTER UPDATE ON VALUTAZIONE_Bilancio
    FOR EACH ROW
    BEGIN
		DECLARE No_Revisione_Attuale INT;
		SET No_Revisione_Attuale = (SELECT COUNT(*) FROM VALUTAZIONE_Bilancio WHERE (CodFis_Revisore = NEW.CodFis_Revisore AND Esito_Giudizio IS NOT NULL));
        UPDATE UTENTE_Revisore
			SET No_Revisione = No_Revisione_Attuale
            WHERE(Codice_Fiscale = NEW.CodFis_Revisore);
    END$
DELIMITER;

# Per campo di ridondanza dell'azienda
DELIMITER $
CREATE TRIGGER Aggiorna_No_Bilanci
	AFTER INSERT ON BILANCIO
    FOR EACH ROW
    BEGIN
		UPDATE AZIENDA
		SET No_Bilancio = (SELECT COUNT(*) FROM BILANCIO WHERE(P_Iva_Azienda = NEW.P_Iva_Azienda))
        WHERE (P_Iva = NEW.P_Iva_Azienda);
	END$
DELIMITER ;
    

    
DELIMITER $
CREATE PROCEDURE User_Info(IN Utente_Name VARCHAR(20), OUT CodFis VARCHAR(11))
proc: BEGIN
	IF (NOT EXISTS(SELECT * FROM UTENTE WHERE(Username = utente_name))) THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Utente non esistente, scrivere un username valido';
        LEAVE proc;
	ELSE
		SELECT Codice_Fiscale FROM UTENTE WHERE(Username = Utente_Name) INTO CodFis;
	END IF;
END$
DELIMITER ;



DELIMITER $
CREATE PROCEDURE Login (IN utente_name VARCHAR(20),IN passwd VARCHAR(10),OUT Successo BOOLEAN)
proc: BEGIN
	IF (EXISTS(SELECT * FROM UTENTE WHERE(Username = utente_name AND pwd = passwd))) THEN
		SET Successo = TRUE;
	ELSE
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Utente non trovato, assicurare che i dati siano corretti e se non ha registrato, prima registrarsi!';
        SET Successo = FALSE;
        LEAVE proc;
	END IF;
END$
DELIMITER ;


DELIMITER $
CREATE PROCEDURE Signup_Amministratore (IN CodFis VARCHAR(11),IN utente_name VARCHAR(20),IN passwd VARCHAR(10),IN DataNasc DATE, IN LuogoNasc VARCHAR(30),OUT Successo BOOLEAN)
proc: BEGIN
	IF (EXISTS(SELECT * FROM UTENTE WHERE(Username = utente_name))) THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Username gia esistente, riprovare';
        
	ELSE
		INSERT INTO UTENTE VALUES(CodFis,utente_name,passwd,DataNasc,LuogoNasc,'Amministratore');
        INSERT INTO UTENTE_Amministratore VALUES(CodFis,utente_name,passwd,DataNasc,LuogoNasc);
        SET ROLE 'Amministratore';
        
	END IF;
    SELECT EXISTS(SELECT * FROM UTENTE WHERE Codice_Fiscale = CodFis) INTO Successo;
END$
DELIMITER ;

DELIMITER $
CREATE PROCEDURE Signup_Revisore (IN CodFis VARCHAR(11),IN utente_name VARCHAR(20),IN passwd VARCHAR(10),IN DataNasc DATE, IN LuogoNasc VARCHAR(30),OUT Successo BOOLEAN)
proc: BEGIN
	IF (EXISTS(SELECT * FROM UTENTE WHERE(Username = utente_name))) THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Username gia esistente, riprovare'; 
        
	ELSE
		INSERT INTO UTENTE VALUES(CodFis,utente_name,passwd,DataNasc,LuogoNasc,'Revisore');
        INSERT INTO UTENTE_Revisore (Codice_Fiscale,Username,pwd,Data_Nascita,Luogo_Nascita) VALUES(CodFis,utente_name,passwd,DataNasc,LuogoNasc);
        SET ROLE 'Revisore';
	END IF;
    SELECT EXISTS(SELECT * FROM UTENTE WHERE Codice_Fiscale = CodFis) INTO Successo;
END$
DELIMITER ;

DELIMITER $
CREATE PROCEDURE Signup_Responsabile (IN CodFis VARCHAR(11),IN utente_name VARCHAR(20),IN passwd VARCHAR(10),IN DataNasc DATE, IN LuogoNasc VARCHAR(30),IN cv VARCHAR (255),OUT Successo BOOLEAN)
proc: BEGIN
	IF (EXISTS(SELECT * FROM UTENTE WHERE(Username = utente_name))) THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Username gia esistente, riprovare';
	ELSE
		INSERT INTO UTENTE VALUES(CodFis,utente_name,passwd,DataNasc,LuogoNasc,'Responsabile');
        INSERT INTO UTENTE_Responsabile  VALUES(CodFis,utente_name,passwd,DataNasc,LuogoNasc,cv);
        SET ROLE 'Responsabile';
	END IF;
    SELECT EXISTS(SELECT * FROM UTENTE WHERE Codice_Fiscale = CodFis) INTO Successo;
END$
DELIMITER ;

DELIMITER $
CREATE PROCEDURE Inserire_Recapito (IN Utente_name VARCHAR(20),IN mail_input VARCHAR(30))
proc: BEGIN
	CALL User_Info(Utente_Name,@CodFis);
    INSERT INTO RECAPITI_Mail VALUES(@CodFis,mail_input);
END$
DELIMITER ;

#Procedure dei Amministratori
DELIMITER $
CREATE PROCEDURE Inserire_Indicatore_ESG(IN Utente_Name VARCHAR(20),IN Indicatore_Name VARCHAR(30),IN Rilevanza SMALLINT,IN Img VARCHAR(255),OUT Successo BOOLEAN)
proc: BEGIN
	CALL User_Info(Utente_Name,@CodFis);
    IF (NOT EXISTS(SELECT * FROM UTENTE_Amministratore WHERE Codice_Fiscale = @CodFis)) THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Accesso negato, solo gli amministratori possono eseguire questa operazione';
    SET Successo = FALSE;
    LEAVE proc;
	END IF;
    IF (EXISTS(SELECT * FROM INDICATORE_ESG WHERE(Nome = Indicatore_Name))) THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Un indicatore con lo stesso nome trovato. Riprovare.';
        SET Successo = FALSE;
	ELSE
		INSERT INTO INDICATORE_ESG VALUES(Indicatore_Name,Rilevanza,Img); 
        SET Successo = TRUE;
	END IF;
END$
DELIMITER ;

DELIMITER $
CREATE PROCEDURE Inserire_Indicatore_Ambientale(IN Utente_Name VARCHAR(20),IN Indicatore_Name VARCHAR(30),IN Rilevanza SMALLINT,IN Img VARCHAR(255),IN Codice VARCHAR(30),OUT Successo BOOLEAN)
proc: BEGIN
	CALL User_Info(Utente_Name,@CodFis);
    IF (NOT EXISTS(SELECT * FROM UTENTE_Amministratore WHERE Codice_Fiscale = @CodFis)) THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Accesso negato, solo gli amministratori possono eseguire questa operazione';
    SET Successo = FALSE;
    LEAVE proc;
	END IF;
    CALL Inserire_Indicatore_ESG(Utente_Name,Indicatore_Name,Rilevanza,Img,@Risultato);
    IF (@Risultato = TRUE) THEN
		INSERT INTO INDICATORE_ESG_Ambientale VALUES(Indicatore_Name,Rilevanza,Img,Codice); 
        SET Successo = TRUE;
	ELSE
		#Utilizzo del signal dell'indicatore main
		SET Successo = FALSE;
	END IF;
END$
DELIMITER ;

DELIMITER $
CREATE PROCEDURE Inserire_Indicatore_Sociale(IN Utente_Name VARCHAR(20),IN Indicatore_Name VARCHAR(30),IN Rilevanza SMALLINT,IN Img VARCHAR(255),IN Ambito_Sociale VARCHAR(30),IN Freq SMALLINT,OUT Successo BOOLEAN)
proc: BEGIN
	CALL User_Info(Utente_Name,@CodFis);
    IF (NOT EXISTS(SELECT * FROM UTENTE_Amministratore WHERE Codice_Fiscale = @CodFis)) THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Accesso negato, solo gli amministratori possono eseguire questa operazione';
    SET Successo = FALSE;
    LEAVE proc;
	END IF;
    CALL Inserire_Indicatore_ESG(Utente_Name, Indicatore_Name,Rilevanza,Img,@Risultato);
    IF (@Risultato = TRUE) THEN
		INSERT INTO INDICATORE_ESG_Sociale VALUES(Indicatore_Name,Rilevanza,Img,Ambito_Sociale,Freq); 
        SET Successo = TRUE;
	ELSE
		#Utilizzo del signal dell'indicatore main
		SET Successo = FALSE;
	END IF;
END$
DELIMITER ;

#Creare il template inserendo i voci
DELIMITER $
CREATE PROCEDURE Inserire_Voci(IN Utente_Name VARCHAR(20),IN Voce_Name VARCHAR(30),IN Descrizione TINYTEXT,OUT Successo BOOLEAN)
proc: BEGIN
	CALL User_Info(Utente_Name,@CodFis);
    IF (NOT EXISTS(SELECT * FROM UTENTE_Amministratore WHERE Codice_Fiscale = @CodFis)) THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Accesso negato, solo gli amministratori possono eseguire questa operazione';
    SET Successo = FALSE;
    LEAVE proc;
	END IF;
    IF (EXISTS(SELECT * FROM VOCI WHERE(Nome = Voce_Name ))) THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Un voce con lo stesso nome gia esiste.';
        SET Successo = FALSE;
        
	ELSE
		INSERT INTO VOCI VALUES(Voce_Name,Descrizione);
		SET Successo = TRUE;
	END IF;
    END$
DELIMITER ;


DELIMITER $
CREATE PROCEDURE Inserire_Valutazione(IN Utente_Name VARCHAR(20),IN Revisore_Name VARCHAR(20),IN P_Iva_Az VARCHAR(30),IN Bilancio_Date DATE,OUT Successo BOOLEAN)
proc: BEGIN
	CALL User_Info(Utente_Name,@CodFis);
    IF (NOT EXISTS(SELECT * FROM UTENTE_Amministratore WHERE Codice_Fiscale = @CodFis)) THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Accesso negato, solo gli amministratori possono eseguire questa operazione';
    SET Successo = FALSE;
    LEAVE proc;
	END IF;
    IF (EXISTS(SELECT * FROM UTENTE_Revisore WHERE (UserName = Revisore_Name)) AND EXISTS(SELECT * FROM BILANCIO WHERE(Data_Creazione = Bilancio_Date AND P_Iva_Azienda = P_Iva_Az))) THEN #Controllo che esistono il revisore da associare e bilancio da valutare
		CALL User_Info(Revisore_Name,@CodFisRevisore);
		INSERT INTO VALUTAZIONE_Bilancio (CodFis_Revisore,Data_Bilancio,P_Iva_Azienda) VALUES(@CodFisRevisore,Bilancio_Date,P_Iva_Az);
	ELSE
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Avvenuto un errore, controllare esistenza del bilancio e del revisore! ';
	END IF;
    SELECT EXISTS(SELECT * FROM VALUTAZIONE_Bilancio WHERE(CodFis_Revisore = @CodFisRevisore AND Data_Bilancio = Bilancio_Date AND P_Iva_Azienda = P_Iva_Az)) INTO Successo;
END$
DELIMITER ;
		

#Procedure dei Revisori
DELIMITER $
CREATE PROCEDURE Inserire_Competenze (IN Utente_Name VARCHAR(20),IN competenza_name VARCHAR(30),IN Liv SMALLINT,OUT Successo BOOLEAN)
proc: BEGIN
	CALL User_Info(Utente_Name,@CodFis);
    IF (NOT EXISTS(SELECT * FROM UTENTE_Revisore WHERE Codice_Fiscale = @CodFis)) THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Accesso negato, solo i revisori possono eseguire questa operazione';
    SET Successo = FALSE;
    LEAVE proc;
	END IF;
    INSERT INTO COMPETENZE_Dichiarate VALUES(competenza_name,@CodFis,Liv);
    SELECT EXISTS(SELECT * FROM COMPETENZE_Dichiarate WHERE ( Nome_Competenza = competenza_name AND CodFis_Revisore = @CodFis )) INTO Successo;
END$
DELIMITER ;

DELIMITER $
CREATE PROCEDURE Inserire_Nota (IN Utente_Name VARCHAR(20),IN Data_Bil DATE,IN P_Iva_Az VARCHAR(30),IN Name_Voce VARCHAR(30),IN Testo_Nota TINYTEXT,OUT Successo BOOLEAN)
proc: BEGIN
	CALL User_Info(Utente_Name,@CodFis);
    IF (NOT EXISTS(SELECT * FROM UTENTE_Revisore WHERE Codice_Fiscale = @CodFis)) THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Accesso negato, solo i revisori possono eseguire questa operazione';
    SET Successo = FALSE;
    LEAVE proc;
	END IF;
    INSERT INTO NOTA VALUES(@CodFis,Data_Bil,P_Iva_Az,Name_Voce,NOW(),Testo_Nota);
    SELECT EXISTS(SELECT * FROM NOTA WHERE (CodFis_Revisore = @CodFis AND Data_Bilancio = Data_Bil AND P_Iva_Azienda = P_Iva_Az AND Nome_Voce = Name_Voce)) INTO Successo;
END$
DELIMITER ;

#La procedure per aggiungere un giudizio
DELIMITER $
CREATE PROCEDURE Inserire_Giudizio (IN p_Data DATE, IN p_Iva VARCHAR(30), IN Utente_Name VARCHAR(20),IN Esito ENUM ('approvazione', 'approvazione con rilievi', 'respingimento'),IN CampoExtra TINYTEXT,OUT Successo BOOLEAN)
proc: BEGIN
	CALL User_Info(Utente_Name,@CodFis);
    IF (NOT EXISTS(SELECT * FROM UTENTE_Revisore WHERE Codice_Fiscale = @CodFis)) THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Accesso negato, solo i revisori possono eseguire questa operazione';
    SET Successo = FALSE;
    LEAVE proc;
	END IF;
	#Verifica che l'utente ha fatto la valutazione prima
    IF(EXISTS(SELECT * FROM VALUTAZIONE_Bilancio WHERE(CodFis_Revisore = @CodFis AND Data_Bilancio = p_Data AND P_Iva_Azienda = p_Iva)))
	THEN 
		IF(CampoExtra = 'Non inserito') THEN
			UPDATE VALUTAZIONE_Bilancio
				SET Esito_Giudizio = Esito, Data_Giudizio = NOW()
				WHERE(CodFis_Revisore = @CodFis AND Data_Bilancio = p_Data AND P_Iva_Azienda = p_Iva);
		ELSE
			UPDATE VALUTAZIONE_Bilancio
					SET Esito_Giudizio = Esito, Campo_Extra_Giudizio = CampoExtra, Data_Giudizio = NOW()
					WHERE(CodFis_Revisore = @CodFis AND Data_Bilancio = p_Data AND P_Iva_Azienda = p_Iva);
		END IF;
	ELSE
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Prima devi fare la valutazione!';
	END IF;
    SELECT EXISTS(SELECT * FROM VALUTAZIONE_Bilancio WHERE (CodFis_Revisore = @CodFis AND Data_Bilancio = p_Data AND P_Iva_Azienda = p_Iva AND Esito_Giudizio = Esito)) INTO Successo;
END$
DELIMITER ;
# Procedure delle Responsabili Aziendali
DELIMITER $
CREATE PROCEDURE Inserire_Azienda (IN Utente_Name VARCHAR(20),IN Ragione VARCHAR(255),IN Nome_Azienda VARCHAR(30),IN P_Iva_Az VARCHAR(30),IN Settore VARCHAR(30),IN Numero_Dipendenti SMALLINT,In Img VARCHAR(255),OUT Successo BOOLEAN)
proc: BEGIN
	CALL User_Info(Utente_Name,@CodFis);
    IF (NOT EXISTS(SELECT * FROM UTENTE_Responsabile WHERE Codice_Fiscale = @CodFis)) THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Accesso negato, solo i responsabili aziendali possono eseguire questa operazione';
    SET Successo = FALSE;
    LEAVE proc;
    END IF;
	INSERT INTO AZIENDA (Ragione_Sociale, Nome, P_Iva, Settore_Appartenenza, No_Dipendenti, Logo, CodFis_Responsabile) VALUES(Ragione,Nome_Azienda,P_Iva_Az,Settore,Numero_Dipendenti,Img,@CodFis);
    SELECT EXISTS(SELECT * FROM AZIENDA WHERE (CodFis_Responsabile = @CodFis AND P_Iva = P_Iva_Az)) INTO Successo;
END$
DELIMITER ;

DELIMITER $
CREATE PROCEDURE Crea_Bilancio (IN Utente_Name VARCHAR(20),IN P_Iva_Az VARCHAR(30),OUT Successo BOOLEAN)
proc: BEGIN
	CALL User_Info(Utente_Name,@CodFis);
    IF (NOT EXISTS(SELECT * FROM UTENTE_Responsabile WHERE Codice_Fiscale = @CodFis)) THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Accesso negato, solo i responsabili aziendali possono eseguire questa operazione';
    SET Successo = FALSE;
    LEAVE proc;
    END IF;
	#Verifica se l'utente che fa l'operazione e' la responsabile dell'azienda per cui viene fatto l'operazione
    IF (NOT EXISTS(SELECT * FROM AZIENDA WHERE Codice_FisResponsabile = @CodFis)) THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Accesso negato, puoi solo associare un revisore ai bilanci delle aziende per cui sei responsabile';
    SET Successo = FALSE;
    LEAVE proc;
	END IF;
	INSERT INTO BILANCIO (Data_Creazione, P_Iva_Azienda) VALUES(NOW(),P_Iva_Az);
    SELECT EXISTS(SELECT * FROM BILANCIO WHERE ( P_Iva_Azienda = P_Iva_Az)) INTO Successo;
END$
DELIMITER ;

DELIMITER $
CREATE PROCEDURE Popola_Bilancio (IN Utente_Name VARCHAR(20),IN P_Iva_Az VARCHAR(30),IN Bilancio_Date DATE,IN Voce_Name VARCHAR(30),OUT Successo BOOLEAN)
proc: BEGIN
	CALL User_Info(Utente_Name,@CodFis);
    IF (NOT EXISTS(SELECT * FROM UTENTE_Responsabile WHERE Codice_Fiscale = @CodFis)) THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Accesso negato, solo i responsabili aziendali possono eseguire questa operazione';
    SET Successo = FALSE;
    LEAVE proc;
    END IF;
	#Verifica se l'utente che fa l'operazione e' la responsabile dell'azienda per cui viene fatto l'operazione
    IF (NOT EXISTS(SELECT * FROM AZIENDA WHERE Codice_FisResponsabile = @CodFis)) THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Accesso negato, puoi solo associare un revisore ai bilanci delle aziende per cui sei responsabile';
    SET Successo = FALSE;
    LEAVE proc;
	END IF;
	INSERT INTO ASSEGNO_Numero_Voci (Data_Bilancio,P_Iva_Azienda ,Nome_Voce) VALUES(Bilancio_Date,P_Iva_Az,Voce_Name);
    SELECT EXISTS(SELECT * FROM ASSEGNO_Numero_Voci WHERE ( Data_Bilancio = Bilancio_Date AND P_Iva_Azienda = P_Iva_Az AND Nome_Voce = Voce_Name)) INTO Successo;
END$
DELIMITER ;

DELIMITER $
CREATE PROCEDURE Inserimento_Rilevazione (IN Utente_Name VARCHAR(20),IN Indicatore_Nome VARCHAR(30),IN Bilancio_Data DATE,IN P_Iva_Az VARCHAR(30),IN Name_Voce VARCHAR(30),IN val SMALLINT,IN Src VARCHAR(30),OUT Successo BOOLEAN)
proc: BEGIN
	CALL User_Info(Utente_Name,@CodFis);
    IF (NOT EXISTS(SELECT * FROM UTENTE_Responsabile WHERE Codice_Fiscale = @CodFis)) THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Accesso negato, solo i responsabili aziendali possono eseguire questa operazione';
    SET Successo = FALSE;
    LEAVE proc;
    END IF;
	#Verifica se l'utente che fa l'operazione e' la responsabile dell'azienda per cui viene fatto l'operazione
    IF (NOT EXISTS(SELECT * FROM AZIENDA WHERE Codice_FisResponsabile = @CodFis)) THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Accesso negato, puoi solo associare un revisore ai bilanci delle aziende per cui sei responsabile';
    SET Successo = FALSE;
    LEAVE proc;
	END IF;
    #Verifica se esiste il bilancio
    IF (EXISTS(SELECT * FROM BILANCIO WHERE(Data_Creazione = Bilancio_Data AND P_Iva_Azienda = P_Iva_Az))) THEN
		#Verifica se esiste l'indicatore
        IF(EXISTS(SELECT * FROM INDICATORE_ESG WHERE(Nome = Indicatore_Nome))) THEN
			INSERT INTO INSERIMENTO_Bilancio VALUES(Indicatore_Nome,Bilancio_Data,P_Iva_Az,Name_Voce,val,src,NOW());
		END IF;
    END IF;
    SELECT EXISTS(SELECT * FROM INSERIMENTO_Bilancio WHERE (Nome_Indicatore =Indicatore_Nome AND Data_Bilancio = Bilancio_Data AND P_Iva_Azienda =P_Iva_Az AND Nome_Voce = Name_Voce )) INTO Successo;
END$
DELIMITER ;

