<?php
define('ROOT', __DIR__);
require_once ROOT . '/Database.php';
require_once ROOT . '/Response.php';

define('MODEL_DIR', dirname(__DIR__));
require MODEL_DIR . '/models/Utente.php';
class Auth {
    private $conn;

    public function __construct() {
         $this->conn = Database::getConnection();
    }

    public function register($username, $nome, $cognome, $email, $password) {
        require_once ROOT . '/AppuntiMailer.php';
        $utente = new Utente($username, $nome, $cognome, $email, $password);
        $token = $utente->createTempUser($username, $nome, $cognome, $email, $password);

        // $utente = new Utente();
        // $utente->createTempUser($username, $nome, $cognome, $dataNascita, $sesso, $email, $password);
        $mailer = new AppuntiMailer();
        $mailResult = $mailer->sendConfirmationEmail($email, $nome, $token);
        if (!$mailResult) {
            $response = new Response(500, "Errore durante l'invio dell'email di conferma.");
            $response->send();
            return;
        }
        $response = new Response(200, "Registrazione avvenuta con successo. Controlla la tua email per confermare l'account.");
        $response->setData([
            'username' => $username,
            'nome' => $nome,
            'cognome' => $cognome,
            'email' => $email
        ]);
        $response->send();
    }

    public function login($username, $password, $type, string $token = null) {
        // controllo se l'utente è già loggato in sessione
         if ($token !== null) {
             $query = "SELECT * FROM sessioni_login WHERE token = ? AND data_accesso > NOW() - INTERVAL 8 HOUR";
             $stmt = $this->conn->prepare($query);
             if ($stmt === false) {
                 $response = new Response(500, "Errore interno del server.");
                $response->send();
                die("Errore preparazione query: " . $this->conn->error);
            }
            $stmt->bind_param("s", $token);
            $stmt->execute();
            if ($stmt->error) {
                $response = new Response(500, "Errore interno del server.");
                $response->send();
                die("Errore esecuzione query: " . $stmt->error);
            }
            $result = $stmt->get_result();
            if ($result->num_rows > 0) {
                // Utente già loggato
                $response = new Response(200, "Utente già loggato.");
                $response->send();
            }
        }
        
            $query = "SELECT * FROM utenti WHERE email = ? OR username = ?";

        //$query.= " AND password_hash = ?";
        //$password = password_hash($password, PASSWORD_BCRYPT);
        $stmt = $this->conn->prepare($query);

        if ($stmt === false) {
            die("Errore preparazione query: " . $this->conn->error);
        }
        $stmt->bind_param("ss", $username, $username);
        $stmt->execute();
        if ($stmt->error) {
            die("Errore esecuzione query: " . $stmt->error);
        }

        $result = $stmt->get_result();
       
        if ($result->num_rows > 0) {
            $utente = $result->fetch_assoc();
             if(!password_verify($password, $utente['password_hash'])){
                die("coglione");
             }
            $token = bin2hex(random_bytes(16));
            $query = "INSERT INTO sessioni_login (uuid,utente_uuid, token) VALUES (uuid(),?, ?)";
            $stmt = $this->conn->prepare($query);
            if ($stmt === false) {
                $response = new Response(500, "Errore interno del server.");
                $response->send();
                die("Errore preparazione query: " . $this->conn->error);
            }
            $stmt->bind_param("ss", $utente['uuid'], $token);
            $stmt->execute();
            if ($stmt->error) {
                $response = new Response(500, "Errore interno del server.");
                $response->send();
                die("Errore esecuzione query: " . $stmt->error);
            }

            // Login avvenuto con successo
            $response = new Response(200, "Login avvenuto con successo.");
            $response->setData([
                'uuid' => $utente['uuid'],
                'token' => $token,
                ($type === 'username') ? 'username' : 'email' => $username
            ]);
            $response->setHeaders([
                'Authorization' => 'Bearer ' . $token,
                'Content-Type' => 'application/json'
            ]);
            $response->send();
        } else {
            // Credenziali non valide
            $response = new Response(401, $password);
            $response->send();
        }
        $stmt->close();
        $this->conn->close();
    }
    

    // CREATE TABLE sessioni_login (
    //     id INT AUTO_INCREMENT PRIMARY KEY,
    //     utente_id INT NOT NULL,
    //     token VARCHAR(255) NOT NULL,
    //     data_accesso TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    //     FOREIGN KEY (utente_id) REFERENCES utenti(id) ON DELETE CASCADE
    // );
    
    public function logout($uuid) {
        // $query = "DELETE FROM sessioni_login WHERE utente_id = ?";
        // $stmt = $this->conn->prepare($query);
        // if ($stmt === false) {
        //     $response = new Response(500, "Errore interno del server.");
        //     $response->send();
        //     die("Errore preparazione query: " . $this->conn->error);
        // }
        // $stmt->bind_param("s", $token);
        // $stmt->execute();
        // if ($stmt->error) {
        //     $response = new Response(500, "Errore interno del server.");
        //     $response->send();
        //     die("Errore esecuzione query: " . $stmt->error);
        // }
        // $stmt->close();
        // $this->conn->close();
        // $response = new Response(200, "Logout avvenuto con successo.");
        // $response->send();

        $response = new Response(200, "Logout avvenuto con successo.");
        $response->send();
        // $response = new Response(500, "Errore interno del server.");
        // $response->send();
    }
}

?>