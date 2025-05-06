
CREATE TABLE utenti (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    nome VARCHAR(50) NOT NULL,
    cognome VARCHAR(50) NOT NULL,
    data_nascita DATE NOT NULL,
    sesso ENUM('maschio', 'femmina', 'altro'),
    data_ultimo_accesso TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    email VARCHAR(100) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    ruolo ENUM('utente', 'revisore', 'admin', 'docente') DEFAULT 'utente',
    bio TEXT,
    immagine_profilo VARCHAR(255)
);

CREATE TABLE utenti_temporanei (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL,
    nome VARCHAR(50) NOT NULL,
    cognome VARCHAR(50) NOT NULL,
    data_nascita DATE NOT NULL,
    sesso ENUM('maschio', 'femmina', 'altro'),
    email VARCHAR(100) NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    token_verifica VARCHAR(64) NOT NULL,
    data_creazione TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE amici (
    id INT AUTO_INCREMENT PRIMARY KEY,
    utente_id INT NOT NULL,
    amico_id INT NOT NULL,
    stato ENUM('inviata', 'accettato', 'rifiutato') DEFAULT 'inviata',
    data_richiesta TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (utente_id) REFERENCES utenti(id) ON DELETE CASCADE,
    FOREIGN KEY (amico_id) REFERENCES utenti(id) ON DELETE CASCADE
);

CREATE TABLE materie (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL UNIQUE,
    descrizione TEXT,
    classe ENUM('1', '2', '3', '4', '5') NOT NULL,
);

CREATE TABLE tag (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(50) UNIQUE NOT NULL,
    descrizione TEXT
);

CREATE TABLE appunti (
    id INT AUTO_INCREMENT PRIMARY KEY,
    titolo VARCHAR(255) NOT NULL,
    contenuto TEXT NOT NULL,
    markdown BOOLEAN DEFAULT TRUE,
    visibilita ENUM('pubblico', 'privato') DEFAULT 'pubblico',
    autore_id INT NOT NULL,
    materia_id INT,
    data_creazione TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    data_ultima_modifica TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    stato ENUM('bozza', 'pubblicato', 'in_revisione') DEFAULT 'bozza',
    FOREIGN KEY (autore_id) REFERENCES utenti(id) ON DELETE SET NULL,
    FOREIGN KEY (materia_id) REFERENCES materie(id) ON DELETE SET NULL
);

CREATE TABLE appunti_condivisi (
    id INT AUTO_INCREMENT PRIMARY KEY,
    appunto_id INT NOT NULL,
    utente_id INT NOT NULL,
    data_condivisione TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (appunto_id) REFERENCES appunti(id) ON DELETE CASCADE,
    FOREIGN KEY (utente_id) REFERENCES utenti(id) ON DELETE CASCADE
);

CREATE TABLE revisioni (
    id INT AUTO_INCREMENT PRIMARY KEY,
    appunto_id INT NOT NULL,
    revisore_id INT NOT NULL,
    commento TEXT,
    data_revisionamento TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (appunto_id) REFERENCES appunti(id) ON DELETE CASCADE,
    FOREIGN KEY (revisore_id) REFERENCES utenti(id) ON DELETE SET NULL
);

CREATE TABLE commenti (
    id INT AUTO_INCREMENT PRIMARY KEY,
    appunto_id INT NOT NULL,
    autore_id INT NOT NULL,
    testo TEXT NOT NULL,
    data_commento TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (appunto_id) REFERENCES appunti(id) ON DELETE CASCADE,
    FOREIGN KEY (autore_id) REFERENCES utenti(id) ON DELETE CASCADE
);

CREATE TABLE appunti_tag (
    appunto_id INT NOT NULL,
    tag_id INT NOT NULL,
    PRIMARY KEY (appunto_id, tag_id),
    FOREIGN KEY (appunto_id) REFERENCES appunti(id) ON DELETE CASCADE,
    FOREIGN KEY (tag_id) REFERENCES tag(id) ON DELETE CASCADE
);

CREATE TABLE notifiche (
    id INT AUTO_INCREMENT PRIMARY KEY,
    utente_id INT NOT NULL,
    messaggio TEXT NOT NULL,
    letta BOOLEAN DEFAULT FALSE,
    data_invio TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (utente_id) REFERENCES utenti(id) ON DELETE CASCADE
);

CREATE TABLE sessioni_login (
    id INT AUTO_INCREMENT PRIMARY KEY,
    utente_id INT NOT NULL,
    token VARCHAR(255) NOT NULL,
    data_accesso TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (utente_id) REFERENCES utenti(id) ON DELETE CASCADE
);
