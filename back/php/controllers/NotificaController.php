<?php
require_once ROOT . '/models/Notifiche.php';
require_once ROOT . '/utilz/Response.php';

function getNotifiche($utente_uuid) {
    $notifiche = Notifica::getNotifiche($utente_uuid);
    if ($notifiche) {
        $response = new Response(200, "Notifiche recuperate con successo.");
        $response->setData($notifiche);
        $response->send();
    } else {
        $response = new Response(404, "Nessuna notifica trovata.");
        $response->send();
    }
}

function inserisciNotifica($utente_uuid, $messaggio, $tipo, $letta = false, $data_invio = null) {
    $notifica = new Notifica($utente_uuid, $messaggio, $tipo, $letta, $data_invio);
    if ($notifica->inserisciNotifica()) {
        $response = new Response(201, "Notifica inserita con successo.");
        $response->send();
    } else {
        $response = new Response(500, "Errore durante l'inserimento della notifica.");
        $response->send();
    }
}

function eliminaNotifica($uuid) {
    if (Notifica::deleteNotifica($uuid)) {
        $response = new Response(204, "Notifica eliminata con successo.");
        $response->send();
    } else {
        $response = new Response(500, "Errore durante l'eliminazione della notifica.");
        $response->send();
    }
}




?>