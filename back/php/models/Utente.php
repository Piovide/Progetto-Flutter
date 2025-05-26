<?php

use Dom\Text;

/**
 * Modello per la gestione degli utenti nel database.
 */
class Utente {
    // Username dell'utente
    private String $username;
    // Nome dell'utente
    private String $nome;
    // Cognome dell'utente
    private String $cognome;
    // Email dell'utente
    private String $email;
    // Password hash dell'utente
    private String $password;

    /**
     * Costruttore della classe Utente
     */
    public function __construct($username, $nome, $cognome, $email, $password) {
        $this->username = $username;
        $this->nome = $nome;
        $this->cognome = $cognome;
        $this->email = $email;
        $this->password = $password;
    }

    /**
     * Crea un utente temporaneo per la verifica email
     */
    public function createTempUser($username, $nome, $cognome, $email, $password) {
        $conn = Database::getConnection();
        $token = bin2hex(random_bytes(16));

        $query = "INSERT INTO utenti_temporanei (uuid, username, nome, cognome, email, password_hash, token_verifica, data_creazione) 
                  VALUES (uuid(), ?, ?, ?, ?, ?, ?, NOW())";
        $stmt = $conn->prepare($query);
        if ($stmt === false) {
            http_response_code(500);
            echo json_encode(['status' => 500, 'error' => $conn->error]);
            $conn->close();
            exit;
        }
        $stmt->bind_param("ssssss", $username, $nome, $cognome, $email, $password, $token);
        $stmt->execute();
        if ($stmt->error) {
            http_response_code(500);
            echo json_encode(['status' => 500, 'error' => $stmt->error]);
            $stmt->close();
            $conn->close();
            exit;
        }
        $stmt->close();
        $conn->close();
        return $token;
    }

    /**
     * Crea un nuovo utente definitivo nel database
     */
    public  function createUser() {
        $conn = Database::getConnection();
        $query = "INSERT INTO utenti (uuid, username, nome, cognome, email, password_hash) VALUES (uuid(), ?, ?, ?, ?, ?)";
        $stmt = $conn->prepare($query);
        if ($stmt === false) {
            $conn->close();
            $response = new Response(500, "Errore lato server riprovare più tardi");
            $response->send();
            exit;
        }
        
        $stmt->bind_param("sssss", $this->username, $this->nome, $this->cognome, $this->email, $this->password);
        $stmt->execute();
        if ($stmt->error) {
            $stmt->close();
            $conn->close();
            $response = new Response(500, "Errore lato server riprovare più tardi");
            $response->send();
            exit;
        }
        $stmt->close();
        $conn->close();
    }

    /**
     * Recupera un utente tramite il suo UUID
     */
    public static function getUserById($utente_uuid) {
        $conn = Database::getConnection();
        $query = "SELECT * FROM utenti WHERE utente_uuid = ?";
        $stmt = $conn->prepare($query);
        if ($stmt === false) {
            http_response_code(500);
            echo json_encode(['status' => 500, 'error' => $conn->error]);
            exit;
        }
        $stmt->bind_param("s", $utente_uuid); // UUID è stringa!
        $stmt->execute();
        if ($stmt->error) {
            http_response_code(500);
            echo json_encode(['status' => 500, 'error' => $stmt->error]);
            exit;
        }
        $result = $stmt->get_result();
        if ($result->num_rows > 0) {
            return $result->fetch_assoc();
        } else {
            return null;
        }
    }

    /**
     * Recupera un utente tramite la sua email
     */
    public static function getUserByEmail($email) {
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

    /**
     * Recupera un utente tramite il suo username
     */
    public static function getUserByUsername($username) {
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

    /**
     * Elimina un utente tramite il suo UUID
     */
    public static function deleteUser($utente_uuid) {
        $conn = Database::getConnection();
        $query = "DELETE FROM utenti WHERE uuid = ?";
        $stmt = $conn->prepare($query);
        if ($stmt === false) {
            die("Errore preparazione query: " . $conn->error);
        }
        $stmt->bind_param("s", $utente_uuid);
        $stmt->execute();
        if ($stmt->error) {
            die("Errore esecuzione query: " . $stmt->error);
        }
        $stmt->close();
        $conn->close();
    }

    /**
     * Modifica un singolo campo di un utente
     */
    public static function changeSingleField($utente_uuid, $field, $value) {
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

    /**
     * Trova tutti gli amici di un utente
     */
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