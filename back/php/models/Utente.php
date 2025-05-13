<?php

use Dom\Text;

class Utente {
    private String $utente_uuid;
    private String $username;
    private String $nome;
    private String $cognome;
    private String $dataNascita;
    private String $sesso;
    private String $dataUltimoAccesso;
    private String $email;
    private String $password;
    private String $ruolo;
    private String $bio;
    private String $URI_immagineProfilo;

    public function Utente(String $utente_uuid, String $username , String $nome, String $cognome, String $dataNascita, String $email, String $password, String $ruolo, String $bio): void{
        $this->utente_uuid = $utente_uuid;
        $this->username = $username;
        $this->nome = $nome;
        $this->cognome = $cognome;
        $this->dataNascita = $cognome;
        $this->email = $email;
        $this->password = $password;
        $this->ruolo = $ruolo;
        $this->bio = $bio;
    }
    public function createTempUser($username, $nome, $cognome, $email, $password) {
        $conn = Database::getConnection();
        $query = "INSERT INTO utenti_temporanei (username, nome, cognome, data_nascita, sesso, email, password, token_verifica) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        $stmt = $conn->prepare($query);
        if ($stmt === false) {
            die("Errore preparazione query: " . $conn->error);
        }
        $token = bin2hex(random_bytes(16));
        $stmt->bind_param("ssssssss", $username, $nome, $cognome, $email, $password, $token);
        $stmt->execute();
        if ($stmt->error) {
            die("Errore esecuzione query: " . $stmt->error);
        }
        $stmt->close();
        $conn->close();
        return $token;
    }

    public function createUser($username, $nome, $cognome, $dataNascita, $sesso, $email, $password) {
        $conn = Database::getConnection();
        $query = "INSERT INTO utenti (username, nome, cognome, data_nascita, sesso, email, password_hash) VALUES (?, ?, ?, ?, ?, ?, ?)";
        $stmt = $conn->prepare($query);
        if ($stmt === false) {
            die("Errore preparazione query: " . $conn->error);
        }
        $stmt->bind_param("sssssss", $username, $nome, $cognome, $dataNascita, $sesso, $email, $password);
        $stmt->execute();
        if ($stmt->error) {
            die("Errore esecuzione query: " . $stmt->error);
        }
        $stmt->close();
        $conn->close();
    }

    public function getUserById($utente_uuid) {
        $conn = Database::getConnection();
        $query = "SELECT * FROM utenti WHERE utente_uuid = ?";
        $stmt = $conn->prepare($query);
        if ($stmt === false) {
            die("Errore preparazione query: " . $conn->error);
        }
        $stmt->bind_param("i", $utente_uuid);
        $stmt->execute();
        if ($stmt->error) {
            die("Errore esecuzione query: " . $stmt->error);
        }
        $result = $stmt->get_result();
        if ($result->num_rows > 0) {
            return $result->fetch_assoc();
        } else {
            return null;
        }
    }
    public function getUserByEmail($email) {
        $conn = Database::getConnection();
        $query = "SELECT * FROM utenti WHERE email = ?";
        $stmt = $conn->prepare($query);
        if ($stmt === false) {
            die("Errore preparazione query: " . $conn->error);
        }
        $stmt->bind_param("s", $email);
        $stmt->execute();
        if ($stmt->error) {
            die("Errore esecuzione query: " . $stmt->error);
        }
        $result = $stmt->get_result();
        if ($result->num_rows > 0) {
            return $result->fetch_assoc();
        } else {
            return null;
        }
    }

    public function getUserByUsername($username) {
        $conn = Database::getConnection();
        $query = "SELECT * FROM utenti WHERE username = ?";
        $stmt = $conn->prepare($query);
        if ($stmt === false) {
            die("Errore preparazione query: " . $conn->error);
        }
        $stmt->bind_param("s", $username);
        $stmt->execute();
        if ($stmt->error) {
            die("Errore esecuzione query: " . $stmt->error);
        }
        $result = $stmt->get_result();
        if ($result->num_rows > 0) {
            return $result->fetch_assoc();
        } else {
            return null;
        }
    }

    public function deleteUser($utente_uuid) {
        $conn = Database::getConnection();
        $query = "DELETE FROM utenti WHERE utente_uuid = ?";
        $stmt = $conn->prepare($query);
        if ($stmt === false) {
            die("Errore preparazione query: " . $conn->error);
        }
        $stmt->bind_param("i", $utente_uuid);
        $stmt->execute();
        if ($stmt->error) {
            die("Errore esecuzione query: " . $stmt->error);
        }
        $stmt->close();
        $conn->close();
    }

    public function changeSingleField($utente_uuid, $field, $value) {
        $conn = Database::getConnection();
        $query = "UPDATE utenti SET " . $field . " = ? WHERE utente_uuid = ?";
        $stmt = $conn->prepare($query);
        if ($stmt === false) {
            die("Errore preparazione query: " . $conn->error);
        }
        $stmt->bind_param("si", $value, $utente_uuid);
        $stmt->execute();
        if ($stmt->error) {
            die("Errore esecuzione query: " . $stmt->error);
        }
        $stmt->close();
        $conn->close();
    }

    public function findFriends($utente_uuid) {
        $conn = Database::getConnection();
        $query = "SELECT * FROM amici WHERE utente_id = ? OR amico_id = ?";
        $stmt = $conn->prepare($query);
        if ($stmt === false) {
            die("Errore preparazione query: " . $conn->error);
        }
        $stmt->bind_param("ii", $utente_uuid, $utente_uuid);
        $stmt->execute();
        if ($stmt->error) {
            die("Errore esecuzione query: " . $stmt->error);
        }
        $result = $stmt->get_result();
        return $result->fetch_all(MYSQLI_ASSOC);
    }
    
}

?>