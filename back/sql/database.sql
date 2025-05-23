-- utenti: contiene le informazioni principali dell’account. Relazionata con appunti, commenti, revisioni, notifiche, sessioni_login e amici.
-- utenti_temporanei: gestisce gli utenti non ancora verificati. Dopo la conferma via mail, i dati vengono trasferiti su utenti.
-- appunti: ogni appunto è associato a un utente e a una materia. Può avere revisioni e commenti.
-- appunti_condivisi: permette di condividere appunti con altri utenti, mantenendo la tracciabilità.
-- storico_modifiche: memorizza le versioni precedenti degli appunti, utile per il ripristino o la revisione.
-- appunti_tag: tabella ponte per associare più tag agli appunti, permettendo una ricerca più flessibile.
-- revisioni: contiene le revisioni effettuate da revisori su appunti, collegate sia a utenti (revisore) che a appunti.
-- commenti: legati a utenti e appunti, permettono di discutere pubblicamente sotto gli appunti, oppure lasciare una valutazione agli appunti.
-- materie: contiene l’elenco delle materie disponibili, collegate agli appunti.
-- tag: sistema flessibile per associare più tag agli appunti tramite una tabella ponte (es. appunti_tag).
-- notifiche: inviate agli utenti in seguito a revisioni, commenti, richieste amicizia, ecc.
-- sessioni_login: memorizza i token attivi per login persistente e tracciamento.
-- amici: sistema base per le relazioni sociali tra utenti (richieste, accettazioni, ecc).

CREATE DATABASE IF NOT EXISTS wiki_db;
USE wiki_db;

CREATE TABLE utenti (
    uuid CHAR(36) PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    nome VARCHAR(50) NOT NULL,
    cognome VARCHAR(50) NOT NULL,
    data_nascita DATE,
    sesso ENUM('maschio', 'femmina', 'altro'),
    data_ultimo_accesso TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    email VARCHAR(100) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    ruolo ENUM('utente', 'revisore', 'admin', 'docente') DEFAULT 'utente',
    bio TEXT,
    immagine_profilo VARCHAR(255)
);

CREATE TABLE utenti_temporanei (
    uuid CHAR(36) PRIMARY KEY,
    username VARCHAR(50) NOT NULL,
    nome VARCHAR(50) NOT NULL,
    cognome VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    token_verifica VARCHAR(64) NOT NULL,
    data_creazione TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE amici (
    uuid CHAR(36) PRIMARY KEY,
    utente_uuid CHAR(36) NOT NULL,
    amico_uuid CHAR(36) NOT NULL,
    stato ENUM('inviata', 'accettato', 'rifiutato') DEFAULT 'inviata',
    data_richiesta TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (utente_uuid) REFERENCES utenti(uuid) ON DELETE CASCADE,
    FOREIGN KEY (amico_uuid) REFERENCES utenti(uuid) ON DELETE CASCADE
);

CREATE TABLE materie (
    uuid CHAR(36) PRIMARY KEY,
    nome VARCHAR(100) NOT NULL UNIQUE,
    descrizione TEXT,
    classe ENUM('1', '2', '3', '4', '5') NOT NULL
);

CREATE TABLE tag (
    uuid CHAR(36) PRIMARY KEY,
    nome VARCHAR(50) UNIQUE NOT NULL,
    descrizione TEXT
);

CREATE TABLE appunti (
    uuid CHAR(36) PRIMARY KEY,
    titolo VARCHAR(255) NOT NULL,
    contenuto TEXT NOT NULL,
    markdown BOOLEAN DEFAULT TRUE,
    visibilita ENUM('pubblico', 'privato') DEFAULT 'pubblico',
    autore_uuid CHAR(36),
    materia_uuid CHAR(36),
    data_creazione TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    data_ultima_modifica TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    stato ENUM('bozza', 'pubblicato', 'in_revisione') DEFAULT 'bozza',
    FOREIGN KEY (autore_uuid) REFERENCES utenti(uuid) ON DELETE SET NULL,
    FOREIGN KEY (materia_uuid) REFERENCES materie(uuid) ON DELETE SET NULL
);

CREATE TABLE storico_modifiche (
    uuid CHAR(36) PRIMARY KEY,
    titolo VARCHAR(255) NOT NULL,
    contenuto TEXT NOT NULL,
    markdown BOOLEAN DEFAULT TRUE,
    visibilita ENUM('pubblico', 'privato'),
    stato ENUM('bozza', 'pubblicato', 'in_revisione'),
    data_modifica TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE appunti_condivisi (
    uuid CHAR(36) PRIMARY KEY,
    appunto_uuid CHAR(36) NOT NULL,
    utente_uuid CHAR(36) NOT NULL,
    data_condivisione TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (appunto_uuid) REFERENCES appunti(uuid) ON DELETE CASCADE,
    FOREIGN KEY (utente_uuid) REFERENCES utenti(uuid) ON DELETE CASCADE
);

CREATE TABLE revisioni (
    uuid CHAR(36) PRIMARY KEY,
    appunto_uuid CHAR(36) NOT NULL,
    revisore_uuid CHAR(36),
    commento TEXT,
    data_revisionamento TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (appunto_uuid) REFERENCES appunti(uuid) ON DELETE CASCADE,
    FOREIGN KEY (revisore_uuid) REFERENCES utenti(uuid) ON DELETE SET NULL
);

CREATE TABLE commenti (
    uuid CHAR(36) PRIMARY KEY,
    appunto_uuid CHAR(36) NOT NULL,
    autore_uuid CHAR(36) NOT NULL,
    testo TEXT NOT NULL,
    data_commento TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (appunto_uuid) REFERENCES appunti(uuid) ON DELETE CASCADE,
    FOREIGN KEY (autore_uuid) REFERENCES utenti(uuid) ON DELETE CASCADE
);

CREATE TABLE appunti_tag (
    appunto_uuid CHAR(36) NOT NULL,
    tag_uuid CHAR(36) NOT NULL,
    PRIMARY KEY (appunto_uuid, tag_uuid),
    FOREIGN KEY (appunto_uuid) REFERENCES appunti(uuid) ON DELETE CASCADE,
    FOREIGN KEY (tag_uuid) REFERENCES tag(uuid) ON DELETE CASCADE
);

CREATE TABLE notifiche (
    uuid CHAR(36) PRIMARY KEY,
    utente_uuid CHAR(36) NOT NULL,
    messaggio TEXT NOT NULL,
    tipo ENUM('commento', 'revisione', 'richiesta_amicizia', 'condivisione_appunto', 'aggiornamento', 'miscellanea') NOT NULL,
    data_invio TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (utente_uuid) REFERENCES utenti(uuid) ON DELETE CASCADE
);

CREATE TABLE sessioni_login (
    uuid CHAR(36) PRIMARY KEY,
    utente_uuid CHAR(36) NOT NULL,
    token VARCHAR(255) NOT NULL,
    data_accesso TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (utente_uuid) REFERENCES utenti(uuid) ON DELETE CASCADE
);

CREATE TABLE invii_email (
    uuid CHAR(36) PRIMARY KEY,
    ip VARCHAR(45) NOT NULL,
    data TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX (data)
);

SET GLOBAL event_scheduler = ON;

CREATE EVENT IF NOT EXISTS delete_old_notifications
ON SCHEDULE EVERY 1 DAY
DO
BEGIN
    DELETE FROM notifiche WHERE data_invio < NOW() - INTERVAL 30 DAY;
    DELETE FROM utenti_temporanei WHERE data_creazione < (NOW() - INTERVAL 1 HOUR);
END;
