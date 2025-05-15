<?php
// login.php

// Abilita CORS per tutti i domini (solo per test, poi limita con l'IP o dominio)
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST, GET, OPTIONS");
header("Access-Control-Allow-Credentials: true");
header("Access-Control-Allow-Headers: *");
// Gestisce preflight OPTIONS per richieste CORS
if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    http_response_code(200);
    exit();
}

header('Content-Type: application/json');

$endpoint = $_SERVER['HTTP_X_ENDPOINT'] ?? '';

if (!$endpoint) {
    echo json_encode(['success' => false, 'message' => 'Missing X-Endpoint header']);
    exit;
}

$endpoint = strtoupper($endpoint);

// Verifica se l'endpoint è valido
$validEndpoints = [
    'LOGIN',
    'REGISTER',
    'LOGOUT',
    'FORGOT_PASSWORD',
    'CHANGE_PASSWORD', 
    'UPDATE_PROFILE', 
    'DELETE_ACCOUNT'
];

if (!in_array($endpoint, $validEndpoints)) {
    echo json_encode(['success' => false, 'message' => 'Invalid endpoint - ' . $endpoint]);
    exit;
}

switch ($endpoint) {
    case 'LOGIN':
        include_once './utilz/Auth.php';
        $password = $_POST['password'] ?? '';
        $auth = new Auth();
        $token = $_POST['token'] ?? null;
        if(isset($_POST['email'])){
            $email = $_POST['email'] ?? '';
            $auth->login($email, $password, 'email', $token);
        }else if(isset($_POST['username'])){
            $username = $_POST['username'] ?? '';
            $auth->login($username, $password, 'username', $token);
        }else{
            echo json_encode(['success' => false, 'message' => 'Missing email or username']);
            exit;
        }
        break;
    case 'REGISTER':
        include_once './utilz/Auth.php';
        
        $username = $_POST['username'] ?? '';
        $nome = $_POST['name'] ?? '';
        $cognome = $_POST['surname'] ?? '';
        $email = $_POST['email'] ?? '';
        $password = password_hash($_POST['password'], PASSWORD_BCRYPT) ?? '';
        $auth = new Auth();
        $auth->register($username, $nome, $cognome, $email, $password);
        break;
    case 'LOGOUT':
        include_once './utilz/Auth.php';
        $token = $_POST['token'] ?? null;
        $uuid = $_POST['uuid'] ?? null;
        $auth = new Auth();
        $auth->logout($uuid);
        break;
    default:
        echo json_encode(['success' => false, 'message' => 'Invalid endpoint']);
        exit;
}



if ($email === 'test@example.com' && $password === '1234') {
    echo json_encode(['success' => true, 'message' => 'Login ok']);
} else {
    echo json_encode(['success' => false, 'message' => 'Credenziali errate']);
}

$requestMethod = $_SERVER['REQUEST_METHOD'];
$endpoint = $_SERVER['HTTP_X_ENDPOINT'] ?? null;

// if (!$endpoint) {
//     (new Response(400, "Missing X-Endpoint header"))->send();
//     exit;
// }
?>