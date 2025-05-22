<?php

use Dom\Text;

class Utente {
    // private String $utente_uuid;
    private String $username;
    private String $nome;
    private String $cognome;
    // private String $dataNascita;
    // private String $sesso;
    // private String $dataUltimoAccesso;
    private String $email;
    private String $password;
    // private String $ruolo;
    // private String $bio;
    // private String $URI_immagineProfilo;

    public function Utente($username, $nome, $cognome, $email, $password) {
        $this->username = $username;
        $this->nome = $nome;
        $this->cognome = $cognome;
        $this->email = $email;
        $this->password = $password;
    }

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

    public static function deleteUser($utente_uuid) {
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