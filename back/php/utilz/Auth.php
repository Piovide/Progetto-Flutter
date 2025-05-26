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
                $response = new Response(401, "Password non valida.");
                $response->send();
                return;
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
                'username' => $utente['username'],
                'nome' => $utente['nome'],
                'cognome' => $utente['cognome'],
                'email' => $utente['email'],
                'data_nascita' => isset($utente['data_nascita']) ? $utente['data_nascita'] : null,
                'sesso' => isset($utente['sesso']) ? $utente['sesso'] : null,
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
    

    public function logout($uuid) {
        $query = "DELETE FROM sessioni_login WHERE utente_uuid = ?";
        $stmt = $this->conn->prepare($query);
        if ($stmt === false) {
            $response = new Response(500, "Errore interno del server.");
            $response->send();
            die("Errore preparazione query: " . $this->conn->error);
        }
        $stmt->bind_param("s", $uuid);
        $stmt->execute();
        if ($stmt->error) {
            $response = new Response(500, "Errore interno del server.");
            $response->send();
            die("Errore esecuzione query: " . $stmt->error);
        }
        $stmt->close();
        $this->conn->close();
        $response = new Response(200, "Logout avvenuto con successo.");
        $response->send();
    }

    public function validateToken($token){
        $query = "SELECT * FROM sessioni_login WHERE token = ?";
        $smtp = $this->conn->prepare($query);
        if($smtp === false){
            $response = new Response(500, "Errore interno del server.");
            $response->send();
            die("Errore preparazione query: " . $this->conn->error); 
        }
        $smtp->bind_param("s", $token);
        $smtp->execute();
        if($smtp->error){
            $response = new Response(500, "Errore interno del server");
            $response->send();
        }
        $result = $smtp->get_result();
        if($result->num_rows > 0){
            $utente = $result->fetch_assoc();
            $query = "UPDATE sessioni_login SET data_accesso = NOW() WHERE token = ?";
            $smtp = $this->conn->prepare($query);
            if($smtp === false){
                $response = new Response(500, "Errore interno del server.");
                $response->send();
                die("Errore preparazione query: " . $this->conn->error);
            }
            $smtp->bind_param("s", $token);
            $smtp->execute();
            if($smtp->error){
                $response = new Response(500, "Errore interno del server.");
                $response->send();
                die("Errore esecuzione query: " . $smtp->error);
            }
            $query = "SELECT * FROM utenti WHERE uuid = ?";
            $smtp = $this->conn->prepare($query);
            if($smtp === false){
                $response = new Response(500, "Errore interno del server.");
                $response->send();
                die("Errore preparazione query: " . $this->conn->error);
            }
            $smtp->bind_param("s", $utente['utente_uuid']);
            $smtp->execute();
            if($smtp->error){
                $response = new Response(500, "Errore interno del server.");
                $response->send();
                die("Errore esecuzione query: " . $smtp->error);
            }
            $result = $smtp->get_result();
            if($result->num_rows > 0){
                $utente = $result->fetch_assoc();
                $response = new Response(200, "Token valido");
                $response->setData([
                    'uuid' => $utente['uuid'],
                    'username' => $utente['username'],
                    'nome' => $utente['nome'],
                    'cognome' => $utente['cognome'],
                    'email' => $utente['email'],
                    'data_nascita' => isset($utente['data_nascita']) ? $utente['data_nascita'] : null,
                    'sesso' => isset($utente['sesso']) ? $utente['sesso'] : null,
                ]);
                $response->send();
            }else{
                $response = new Response(401, "Token non valido");
                $response->send();
            }
        }
    }

    public function updateUserData($uuid, $nome, $cognome, $data_nascita, $sesso, $old_password, $new_password): void{
        $result = $this->changePassword($uuid, $old_password, $new_password);
        $fields = [];
        $params = [];
        $types = '';

        if ($nome !== null) {
            $fields[] = "nome = ?";
            $params[] = $nome;
            $types .= 's';
        }
        if ($cognome !== null) {
            $fields[] = "cognome = ?";
            $params[] = $cognome;
            $types .= 's';
        }
        if ($data_nascita !== null) {
            $fields[] = "data_nascita = ?";
            $params[] = $data_nascita;
            $types .= 's';
        }
        if ($sesso !== null) {
            $fields[] = "sesso = ?";
            $params[] = $sesso;
            $types .= 's';
        }

        if (!empty($fields)) {
            $query = "UPDATE utenti SET " . implode(', ', $fields) . " WHERE uuid = ?";
            $params[] = $uuid;
            $types .= 's';

            $stmt = $this->conn->prepare($query);
            if ($stmt === false) {
                $response = new Response(500, "Errore interno del server.");
                $response->send();
                return;
            }
            $stmt->bind_param($types, ...$params);
            $stmt->execute();
            if ($stmt->error) {
                $response = new Response(500, "Errore durante l'aggiornamento dei dati.");
                $response->send();
                return;
            }
            $stmt->close();
        }
        
        $response = new Response(200, "Dati aggiornati con successo.");
        $response->send();
    }

    public function changePassword($uuid, $old_password, $new_password) {
        $query = "SELECT * FROM utenti WHERE uuid = ?";
        $stmt = $this->conn->prepare($query);

        if ($stmt === false) {
            return false;
        }
        $stmt->bind_param("s", $uuid);
        $stmt->execute();
        if ($stmt->error) {
            return false;
        }

        $result = $stmt->get_result();

        if ($result->num_rows > 0) {
            $utente = $result->fetch_assoc();
            if (password_verify($old_password, $utente['password_hash'])) {
                $query = "UPDATE utenti SET password_hash = ? WHERE uuid = ?";
                $stmt = $this->conn->prepare($query);
                if ($stmt === false) {
                    return false;
                }
                $new_password_hash = password_hash($new_password, PASSWORD_BCRYPT);
                $stmt->bind_param("ss", $new_password_hash, $uuid);
                $stmt->execute();
                if ($stmt->error) {
                    return false;
                }
                $stmt->close();
                return true;
            } else {
                return false;
            }
        } else {
            return false;
        }
    }
}

?>