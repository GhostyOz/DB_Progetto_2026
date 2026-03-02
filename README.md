The project trace defined by th the professor (In Italian)
Corso di Basi di Dati
CdS Informatica per il Management TRACCIA di PROGETTO, A.A. 2025/2026
PREMESSA
La piattaforma ESG-BALANCE intende supportare le aziende nella gestione dei propri bilanci economico-finanziari integrandoli con i dati relativi alla sostenibilità, con particolare attenzione agli indicatori ESG (Environmental, Social and Governance) ambientali e sociali. L’obiettivo è fornire un sistema unico in cui registrare e monitorare non solo le voci di bilancio tradizionali, ma anche gli impatti ambientali e sociali associati alle attività aziendali, nonché supportare il lavoro dei revisori ESG durante il processo di verifica.
SPECIFICA DELLA PIATTAFORMA
La piattaforma supporta la registrazione degli utenti. Tutti gli utenti dispongono di username, password, Codice Fiscale, data e luogo di nascita, uno o più recapiti email. Ogni utente ricade in una ed una sola di queste categorie: amministratore, revisore ESG o responsabile aziendale. I revisori ESG dispongono di due campi aggiuntivi: il numero di revisioni effettuate e l’indice di affidabilità. Inoltre, i revisori ESG, e solo loro, possono dichiarare una lista di competenze possedute (es. “Risk Assessment” oppure “Sostenibilità ambientale”). Per ogni coppia <utente, competenza> viene memorizzato un livello (un numero compreso tra 0 e 5). I responsabili aziendali dispongono di un campo Curriculum Vitae, in formato PDF.
Le aziende registrate dispongono di: nome, ragione sociale (univoca), partita IVA, settore di appartenenza, numero dipendenti ed un logo (immagine). Per ciascuna azienda la piattaforma memorizza il numero totale di bilanci inseriti (#nr_bilanci, è una ridondanza concettuale). Ogni azienda è associata ad un solo utente di tipo responsabile aziendale: lo stesso utente di tipo responsabile aziendale può essere associato a più aziende.
La piattaforma supporta un “template” del bilancio, condiviso tra tutte le aziende della piattaforma. Il template è costituito da una lista di voci contabili: ogni voce è caratterizzata da un nome univoco (ad esempio “Ricavi vendite”, “Costo del personale”, “Ammortamenti”, “Debiti verso fornitori”) e da una descrizione testuale. Il template può essere inserito solo dagli utenti amministratori.
Ogni azienda dispone di zero, uno o più bilanci di esercizio. Ogni bilancio di esercizio contiene una data di creazione, uno stato (“bozza”, “in revisione”, “approvato”, “respinto”) ed associa un valore numerico ad ogni voce contabile del template. All’atto di creazione di un nuovo bilancio, lo stato è “bozza”.
Accanto ai dati puramente finanziari di un’azienda, la piattaforma consente di tenere traccia degli indicatori ESG. Ogni indicatore dispone di nome univoco, un’immagine rappresentativa ed una rilevanza (valore tra 0 e 10). Gli indicatori sono suddivisi in due categorie: ambientali (es. consumo annuale di energia elettrica in kWh o utilizzo annuale di acqua potabile in litri) e indicatori sociali (es. numero medio di ore di formazione dei dipendenti). Gli indicatori ESG ambientali dispongono di un campo “codice normativa di rilevamento”. Gli indicatori ESG sociali dispongono di campi aggiuntivi come l’ambito sociale di riferimento e la frequenza di rilevazione. Possono esistere indicatori che non ricadono in alcuna delle due categorie sovra- indicata. La lista degli indicatori ESG presenti in piattaforma è popolata solo dagli utenti amministratori.
In fase di inserimento di un bilancio di esercizio, è prevista la possibilità di collegare ogni singola voce contabile ad uno o più indicatori ESG. Per ciascuna coppia <voce, indicatore ESG>, vengono memorizzati il valore numerico dell’indicatore, la fonte, la data di rilevazione.

Il processo di revisione prevede che uno o più utenti revisori ESG valutino ciascun bilancio di esercizio presente nel sistema. Ogni revisore ESG può valutare più bilanci; un bilancio viene valutato sempre da uno o più revisori. Il revisore ESG può aggiungere una nota su ogni singola voce del bilancio: ogni nota dispone di data e di un campo testo. Inoltre, il revisore emette un giudizio complessivo associato a ciascun bilancio: il giudizio dispone di un esito (“approvazione”, “approvazione con rilievi” o “respingimento”), di una data e di un eventuale campo rilievi (campo testo).
Il sistema deve anche registrare su una collezione MongoDB tutti gli eventi significativi della piattaforma, come la creazione di bilanci, l’inserimento dei valori degli indicatori ambientali o sociali, l’inizio di una revisione, etc. Ogni evento deve essere salvato come testo accompagnato da un timestamp.
Operazioni sui dati1:
Operazioni che riguardano tutti gli utenti:
• Autenticazione/registrazione sulla piattaforma
Operazioni che riguardano SOLO gli utenti amministratori:
• Popolamento della lista degli indicatori ESG
• Creazione del “template” di bilancio di esercizio
• Associazione di revisore ESG ad un bilancio aziendale
Operazioni che riguardano SOLO i revisori ESG:
• Inserimento delle proprie competenze (nome competenza + livello)
• Inserimento delle note su voci di bilancio
• Inserimento del giudizio complessivo
Operazioni che riguardano SOLO i responsabili aziendali:
• Registrazione di un’azienda
• Creazione/popolamento di un nuovo bilancio di esercizio
• Inserimento dei valori degli indicatori ESG per singole voci di bilancio
Statistiche (visibili a tutti):
• Mostrare il Numero di aziende registrate in piattaforma
• Mostrare il Numero di revisori ESG registrati in piattaforma
• Mostrare l’azienda con il valore più alto di affidabilità. Quest’ultima è definita come la
percentuale di bilanci approvati dai revisori senza rilievi (esito: “approvazione”).
• Classifica dei bilanci aziendali, ordinati in base al numero totale di indicatori ESG connessi
alle singole voci contabili.
Popolamento della piattaforma:
Non richiesta, bastano i dati sufficienti per la demo in sede d’esame.
Vincoli sull’implementazione:
           1 La lista contiene le operazioni di base: può essere estesa/modificata a discrezione

- Implementare tutte le operazioni sui dati (ove possibile) attraverso stored procedure.
- Implementare le statistiche menzionate in precedenza mediante viste.
- Utilizzare un trigger per cambiare lo stato di un bilancio. Lo stato diventa “in revisione”
quando viene aggiunto un revisore ESG ad un bilancio.
- Utilizzare un trigger per cambiare lo stato di un bilancio. Il trigger viene attivato nel
momento in cui un revisore inserisce un giudizio su un bilancio. Se tutti i revisori ESG associati a quel bilancio hanno inserito i loro giudizi, e quest’ultimi sono tutti pari ad “approvazione”o “approvazione con rilievi”, lo stato diventa “approvato”. Se tutti i revisori ESG associati a quel bilancio hanno inserito i loro giudizi, ed almeno uno è pari a “respingimento”, lo stato diventa pari a “respinto”.
Tabelle dei volumi:
- Valutare se la seguente ridondanza:
campo #nr_bilanci relativo ad un’azienda
debba essere tenuta o eliminata, sulla base delle seguenti operazioni:
o Aggiungereunanuovaaziendainpiattaforma,edibilancidieserciziodegliultimi3anni
(1 volta/mese, interattiva)
o Contare il numero di bilanci di esercizio, per tutte le aziende presenti nel sistema
(3volta/mese, batch)
o Rimuovereun’aziendaetuttiibilancidiesercizioconnessiadessa(1volte/mese,batch)
- Coefficienti per l’analisi: wI = 1, wB = 0.5, a = 2
- Tabella dei volumi: 10 aziende, 5 bilanci di esercizio per ciascuna azienda.
Bonus:
Il punteggio massimo ottenibile è 30/30 se si implementano correttamente tutte le specifiche menzionate fin qui. E’ previsto il seguente bonus:
- (per la lode, solo se i punti precedenti sono stati sviluppati correttamente) Utilizzo di librerie CSS per la realizzazione del front-end Web (es. Bootstrap https://getbootstrap.com)
