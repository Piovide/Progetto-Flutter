<?php
/**
 * Endpoint per la verifica dell'email tramite token.
 * Riceve un token via GET, controlla se esiste un utente temporaneo associato,
 * crea l'utente definitivo e rimuove l'utente temporaneo.
 */

header('Content-Type: application/json');
require_once dirname(__DIR__) . '/models/Utente.php';
require_once dirname(__DIR__) . '/utilz/database.php';

// Recupera il token dalla query string
$token = $_GET['token'] ?? null;

// Controlla che il token sia presente
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

// Se il token non è valido o già usato
if ($result->num_rows === 0) {
    http_response_code(404);
    echo json_encode(['status' => 404, 'message' => 'Token non valido o già usato']);
    $stmt->close();
    $conn->close();
    exit;
}

// Recupera i dati dell'utente temporaneo
$tempUser = $result->fetch_assoc();

// Crea l'utente definitivo
$Utente = new Utente(
    $tempUser['username'],
    $tempUser['nome'],
    $tempUser['cognome'],
    $tempUser['email'],
    $tempUser['password_hash']
);

$stmt->close();

// Inserisce l'utente definitivo nel database
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