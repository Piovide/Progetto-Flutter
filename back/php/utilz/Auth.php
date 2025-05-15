<?php
define('ROOT', __DIR__);
require_once ROOT . '/Database.php';
require_once ROOT . '/Response.php';
require_once ROOT . '/AppuntiMailer.php';

class Auth {
    private $conn;

    public function __construct() {
        // $this->conn = Database::getConnection();
    }

    public function register($username, $nome, $cognome, $email, $password) {
        // $utente = new Utente();
        // $utente->createTempUser($username, $nome, $cognome, $dataNascita, $sesso, $email, $password);
        $mailer = new AppuntiMailer();
        $token = bin2hex(random_bytes(16));
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
        // if ($token !== null) {
        //     $query = "SELECT * FROM sessioni_login WHERE token = ? AND data_accesso > NOW() - INTERVAL 8 HOUR";
        //     $stmt = $this->conn->prepare($query);
        //     if ($stmt === false) {
        //         $response = new Response(500, "Errore interno del server.");
        //         $response->send();
        //         die("Errore preparazione query: " . $this->conn->error);
        //     }
        //     $stmt->bind_param("s", $token);
        //     $stmt->execute();
        //     if ($stmt->error) {
        //         $response = new Response(500, "Errore interno del server.");
        //         $response->send();
        //         die("Errore esecuzione query: " . $stmt->error);
        //     }
        //     $result = $stmt->get_result();
        //     if ($result->num_rows > 0) {
        //         // Utente già loggato
        //         $response = new Response(200, "Utente già loggato.");
        //         $response->send();
        //     }
        // }
        
        // if($type == 'email'){
        //     $query = "SELECT * FROM utenti WHERE email = ?";
        
        // }else if($type == 'username'){
        //     $query = "SELECT * FROM utenti WHERE username = ?";
        // }else{
        //     $response = new Response(400, "Tipo di login non valido.");
        //     $response->send();
        //     return;
        // }
        // $stmt = $this->conn->prepare($query);
        // if ($stmt === false) {
        //     die("Errore preparazione query: " . $this->conn->error);
        // }
        // $stmt->bind_param("ss", $username, $password);
        // $stmt->execute();
        // if ($stmt->error) {
        //     die("Errore esecuzione query: " . $stmt->error);
        // }
        // $result = $stmt->get_result();
        // if ($result->num_rows > 0) {
        //     $utente = $result->fetch_assoc();
        //     $token = bin2hex(random_bytes(16));
        //     $query = "INSERT INTO sessioni_login (utente_id, token) VALUES (?, ?)";
        //     $stmt = $this->conn->prepare($query);
        //     if ($stmt === false) {
        //         $response = new Response(500, "Errore interno del server.");
        //         $response->send();
        //         die("Errore preparazione query: " . $this->conn->error);
        //     }
        //     $stmt->bind_param("is", $utente['id'], $token);
        //     $stmt->execute();
        //     if ($stmt->error) {
        //         $response = new Response(500, "Errore interno del server.");
        //         $response->send();
        //         die("Errore esecuzione query: " . $stmt->error);
        //     }
            // Login avvenuto con successo
            $response = new Response(200, "Login avvenuto con successo.");
            $response->setData([
                // 'uuid' => $utente['id'],
                'token' => $token,
                ($type === 'username') ? 'username' : 'email' => $username
            ]);
            $response->setHeaders([
                'Authorization' => 'Bearer ' . $token,
                'Content-Type' => 'application/json'
            ]);
            $response->send();
        // } else {
        //     // Credenziali non valide
        //     $response = new Response(401, "Credenziali non valide.");
        //     $response->send();
        // }
        // $stmt->close();
        // $this->conn->close();
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