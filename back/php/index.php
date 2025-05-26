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
                $username = $_POST['username'] ?? null;
                $nome = $_POST['name'] ?? null;
                $cognome = $_POST['surname'] ?? null;
                $email = $_POST['email'] ?? null;
                $password = password_hash($_POST['password'], PASSWORD_BCRYPT) ?? null;
                if(!$username || !$nome || !$cognome || !$email || !$password){
                    $response = new Response(400, "Missing parameters");
                    $response->send();
                    exit;
                }
                $auth = new Auth();
                $auth->register($username, $nome, $cognome, $email, $password);
            }else if($action === 'LOGOUT'){
                $token = $_POST['token'] ?? null;
                $uuid = $_POST['uuid'] ?? null;
                $auth = new Auth();
                $auth->logout($uuid);
            }else if($action ===  'VALIDATE_TOKEN'){
                $token = $_POST['token'] ?? null;
                if(!$token){
                    $response = new Response(400, "Missing token");
                    $response->send();
                    exit;
                }else{
                    $auth->validateToken($token);
                }
            }else if($action === 'CHANGE_PASSWORD'){
                $token = $_POST['token'] ?? null;
                $uuid = $_POST['uuid'] ?? null;
                $old_password = $_POST['old_password'] ?? null;
                $new_password = $_POST['new_password'] ?? null;
                if(!$token || !$uuid || !$old_password || !$new_password){
                    $response = new Response(400, "Missing parameters");
                    $response->send();
                    exit;
                }
                $auth->changePassword($uuid, $old_password, $new_password);
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
                if (!$titolo || !$contenuto || !$autore_uuid /*|| !$materia_uuid'*/) {
                    $response = new Response(400, 
                      "titolo: $titolo, contenuto: $contenuto, autore_uuid: $autore_uuid, materia_uuid: $materia_uuid");
                    $response->send();
                    exit;
                }
                $appunto = new Appunti( $titolo, $contenuto, $markdown, $visibilta, $autore_uuid, $materia_uuid);
                $appunto->inserisciAppunti();
            } else if ($action === 'GET_BY_UUID') {
                $uuid = $_POST['uuid'] ?? null;
                if (!$uuid) {
                    $response = new Response(400, "Missing uuid");
                    $response->send();
                    exit;
                }
                Appunti::getAppuntiByAutore($uuid);
            } else if ($action === 'GET_BY_SUBJECT'){
                $materia = $_POST['materia'];
                $classe = $_POST['classe'];
                if(!$materia || !$classe){
                    $response = new Response(400, "Missing materia or classe");
                    $response->send();
                    exit;
                }
                Appunti::getAppuntiByMateria($materia, $classe);
            }
            break;
        default:
            $response = new Response(400, "endpoint not implemented ".$endpoint);
            $response->send();
            exit;
    }
} catch (Exception $e) {
    $response = new Response(500, "Internal server error: " . $e->getMessage());
    $response->send();
    exit;
}

?>