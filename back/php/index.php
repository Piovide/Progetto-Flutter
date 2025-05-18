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
            if (!$utente_uuid) {
                $response = new Response(400, "Missing utente_uuid");
                $response->send();
                exit;
            }
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
        default:
            $response = new Response(400, "Invalid endpoint");
            $response->send();
            exit;
    }
} catch (Exception $e) {
    $response = new Response(500, "Internal server error: " . $e->getMessage());
    $response->send();
    exit;
}

?>