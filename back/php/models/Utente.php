<?php

class Utente {
    private $id;
    private $username;
    private $nome;
    private $cognome;
    private $dataNascita;
    private $sesso;
    private $dataUltimoAccesso;
    private $email;
    private $password;
    private $ruolo;
    private $bio;
    private $URI_immagineProfilo;

    public function createTempUser($username, $nome, $cognome, $dataNascita, $sesso, $email, $password) {
        $conn = Database::getConnection();
        $query = "INSERT INTO utenti_temporanei (username, nome, cognome, data_nascita, sesso, email, password, token_verifica) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        $stmt = $conn->prepare($query);
        if ($stmt === false) {
            die("Errore preparazione query: " . $conn->error);
        }
        $token = bin2hex(random_bytes(16));
        $stmt->bind_param("ssssssss", $username, $nome, $cognome, $dataNascita, $sesso, $email, $password, $token);
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

    public function getUserById($id) {
        $conn = Database::getConnection();
        $query = "SELECT * FROM utenti WHERE id = ?";
        $stmt = $conn->prepare($query);
        if ($stmt === false) {
            die("Errore preparazione query: " . $conn->error);
        }
        $stmt->bind_param("i", $id);
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

    public function deleteUser($id) {
        $conn = Database::getConnection();
        $query = "DELETE FROM utenti WHERE id = ?";
        $stmt = $conn->prepare($query);
        if ($stmt === false) {
            die("Errore preparazione query: " . $conn->error);
        }
        $stmt->bind_param("i", $id);
        $stmt->execute();
        if ($stmt->error) {
            die("Errore esecuzione query: " . $stmt->error);
        }
        $stmt->close();
        $conn->close();
    }

    public function changeSingleField($id, $field, $value) {
        $conn = Database::getConnection();
        $query = "UPDATE utenti SET " . $field . " = ? WHERE id = ?";
        $stmt = $conn->prepare($query);
        if ($stmt === false) {
            die("Errore preparazione query: " . $conn->error);
        }
        $stmt->bind_param("si", $value, $id);
        $stmt->execute();
        if ($stmt->error) {
            die("Errore esecuzione query: " . $stmt->error);
        }
        $stmt->close();
        $conn->close();
    }

    public function findFriends($id) {
        $conn = Database::getConnection();
        $query = "SELECT * FROM amici WHERE utente_id = ? OR amico_id = ?";
        $stmt = $conn->prepare($query);
        if ($stmt === false) {
            die("Errore preparazione query: " . $conn->error);
        }
        $stmt->bind_param("ii", $id, $id);
        $stmt->execute();
        if ($stmt->error) {
            die("Errore esecuzione query: " . $stmt->error);
        }
        $result = $stmt->get_result();
        return $result->fetch_all(MYSQLI_ASSOC);
    }
    
}

?>