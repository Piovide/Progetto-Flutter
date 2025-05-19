<?php
// Abilita CORS per tutti i domini (solo per test, poi limita con l'IP o dominio)
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST, GET, OPTIONS");
header("Access-Control-Allow-Headers: *");
// Gestisce preflight OPTIONS per richieste CORS
if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    http_response_code(200);
    exit();
}

header('Content-Type: application/json');

include_once './utilz/Response.php';

$endpoint = $_SERVER['HTTP_X_ENDPOINT'] ?? '';
$action = $_SERVER['HTTP_X_ACTION'] ?? '';

if (!$endpoint) {
    $response = new Response(400, "Missing X-Endpoint header");
    $response->send();
    exit;
}
if (!$action) {
    $response = new Response(400, "Missing X-Action header");
    $response->send();
    exit;
}

$endpoint = strtoupper($endpoint);
$action = strtoupper($action);
// Verifica se l'endpoint è valido
$validEndpoints = [
    'AUTH',
    'NOTIFICATION',
    'SUBJECT',
    'NOTE',
    'FORGOT_PASSWORD',
    'CHANGE_PASSWORD', 
    'UPDATE_PROFILE', 
    'DELETE_ACCOUNT'
];

if (!in_array($endpoint, $validEndpoints)) {
    $response = new Response(400, "Invalid endpoint");
    $response->send();
    exit;
}
try {
    switch ($endpoint) {
        case 'AUTH':
            include_once './utilz/Auth.php';
            $auth = new Auth();
            if($action === 'LOGIN') {
                $password = $_POST['password'] ?? '';
                $token = $_POST['token'] ?? null;
                if(isset($_POST['email'])){
                    $email = $_POST['email'] ?? '';
                    $auth->login($email, $password, 'email', $token);
                }else if(isset($_POST['username'])){
                    $username = $_POST['username'] ?? '';
                    $auth->login($username, $password, 'username', $token);
                }else{
                    $response = new Response(400, "Missing email or username");
                    $response->send();
                    exit;
                }
            }else if($action === 'REGISTER'){
                $username = $_POST['username'] ?? '';
                $nome = $_POST['name'] ?? '';
                $cognome = $_POST['surname'] ?? '';
                $email = $_POST['email'] ?? '';
                $password = password_hash($_POST['password'], PASSWORD_BCRYPT) ?? '';
                $auth = new Auth();
                $auth->register($username, $nome, $cognome, $email, $password);
            }else if($action === 'LOGOUT'){
                $token = $_POST['token'] ?? null;
                $uuid = $_POST['uuid'] ?? null;
                $auth = new Auth();
                $auth->logout($uuid);
            }else{
                $response = new Response(400, "Missing action");
                $response->send();
                exit;
            }
            break;
        case 'NOTIFICATION':
            include_once './models/Notifiche.php';
            $utente_uuid = $_POST['utente_uuid'] ?? null;
            // if (!$utente_uuid) {
            //     $response = new Response(400, "Missing utente_uuid");
            //     $response->send();
            //     exit;
            // }
            if ($action === 'GET') {
                Notifica::getNotifiche($utente_uuid);
            } else if ($action === 'INSERT') {
                $messaggio = $_POST['messaggio'] ?? '';
                $tipo = $_POST['tipo'] ?? '';
                $letta = $_POST['letta'] ?? false;
                if (!$messaggio || !$tipo) {
                    $response = new Response(400, "Missing messaggio or tipo");
                    $response->send();
                    exit;
                }
                $notifica = new Notifica(null, $utente_uuid, $messaggio, $tipo, $letta, null);
                $notifica->inserisciNotifica();
            } else if ($action === 'DELETE') {
                $uuid = $_POST['uuid'] ?? null;
                if (!$uuid) {
                    $response = new Response(400, "Missing uuid");
                    $response->send();
                    exit;
                }
                Notifica::deleteNotifica($uuid);
            } else {
                $response = new Response(400, "Missing action");
                $response->send();
                exit;
            }
            break;
        case 'SUBJECT':
            include_once './models/Materie.php';
            $classe = $_POST['classe'] ?? null;
            if (!$classe) {
                $response = new Response(400, "Missing classe");
                $response->send();
                exit;
            }
            if ($action === 'GET') {
                Materie::getMaterie($classe);
            } else {
                $response = new Response(400, "Missing action");
                $response->send();
                exit;
            }
            break;
        case 'NOTE':
//     CREATE TABLE appunti (
//     uuid CHAR(36) PRIMARY KEY,
//     titolo VARCHAR(255) NOT NULL,
//     contenuto TEXT NOT NULL,
//     markdown BOOLEAN DEFAULT TRUE,
//     visibilita ENUM('pubblico', 'privato') DEFAULT 'pubblico',
//     autore_uuid CHAR(36),
//     materia_uuid CHAR(36),
//     data_creazione TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
//     data_ultima_modifica TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
//     stato ENUM('bozza', 'pubblicato', 'in_revisione') DEFAULT 'bozza',
//     FOREIGN KEY (autore_uuid) REFERENCES utenti(uuid) ON DELETE SET NULL,
//     FOREIGN KEY (materia_uuid) REFERENCES materie(uuid) ON DELETE SET NULL
// );

            include_once './models/Appunti.php';
            if ($action === 'GET') {
                Appunti::getAppunti();
            } else if ($action === 'INSERT') {
                $titolo = $_POST['titolo'] ?? '';
                $contenuto = $_POST['contenuto'] ?? '';
                $markdown = $_POST['markdown'] ?? 1;
                $visibilta = $_POST['visibilta'] ?? 'pubblico';
                $autore_uuid = $_POST['autore_uuid'] ?? '';
                $materia_uuid = $_POST['materia_uuid'] ?? '';
                $data_creazione = $_POST['data_creazione'] ?? date('Y-m-d H:i:s');
                $stato = $_POST['stato'] ?? 'bozza';
                if (!$titolo || !$contenuto || !$autore_uuid || !$materia_uuid) {
                    $response = new Response(400, "Missing titolo, contenuto, autore_uuid or materia_uuid");
                    $response->send();
                    exit;
                }
                $appunto = new Appunti(null, $titolo, $contenuto, $markdown, $visibilta, $autore_uuid, $materia_uuid, $data_creazione, $stato);
                $appunto->inserisciAppunti();
            }

        default:
            $response = new Response(400, "endpoint not implemented");
            $response->send();
            exit;
    }
} catch (Exception $e) {
    $response = new Response(500, "Internal server error: " . $e->getMessage());
    $response->send();
    exit;
}

?>