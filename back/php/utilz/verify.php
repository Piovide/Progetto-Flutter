<?php
header('Content-Type: application/json');
require_once dirname(__DIR__) . '/models/Utente.php';
require_once dirname(__DIR__) . '/utilz/database.php';

// Recupera il token dalla query string
$token = $_GET['token'] ?? null;

if (!$token) {
    http_response_code(400);
    echo json_encode(['status' => 400, 'message' => 'Token mancante']);
    exit;
}

$conn = Database::getConnection();

// Cerca l'utente temporaneo con quel token
$query = "SELECT * FROM utenti_temporanei WHERE token_verifica = ?";
$stmt = $conn->prepare($query);
$stmt->bind_param("s", $token);
$stmt->execute();
$result = $stmt->get_result();

if ($result->num_rows === 0) {
    http_response_code(404);
    echo json_encode(['status' => 404, 'message' => 'Token non valido o già usato']);
    $stmt->close();
    $conn->close();
    exit;
}

$tempUser = $result->fetch_assoc();
//print_r($tempUser);
$Utente = new Utente    (
    $tempUser['username'],
    $tempUser['nome'],
    $tempUser['cognome'],
    $tempUser['email'],
    $tempUser['password_hash']);


$stmt->close();

// Crea l'utente definitivo
$Utente->createUser();

// Elimina l'utente temporaneo
$delStmt = $conn->prepare("DELETE FROM utenti_temporanei WHERE token_verifica = ?");
$delStmt->bind_param("s", $token);
$delStmt->execute();
$delStmt->close();

$conn->close();


// Risposta di successo
echo json_encode(['status' => 200, 'message' => 'Account confermato con successo! Ora puoi effettuare il login.']);
exit;