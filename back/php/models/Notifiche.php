<?php
/**
 * Modello per la gestione delle notifiche nel database.
 */
class Notifica {
    // UUID della notifica
    private string $uuid;
    // UUID dell'utente destinatario
    private string $utente_uuid;
    // Messaggio della notifica
    private string $messaggio;
    // Stato di lettura della notifica
    private bool $letta;
    // Tipo della notifica (es: info, messaggio, sicurezza)
    private string $tipo;
    // Data di invio della notifica (opzionale)
    private ?string $data_invio;

    /**
     * Costruttore della classe Notifica
     */
    public function __construct(string $uuid = null, string $utente_uuid, string $messaggio, string $tipo, bool $letta = false, ?string $data_invio = null) {
        $this->uuid = $uuid;
        $this->utente_uuid = $utente_uuid;
        $this->messaggio = $messaggio;
        $this->letta = $letta;
        $this->tipo = $tipo;
        $this->data_invio = $data_invio;
    }

    /**
     * Inserisce una nuova notifica nel database
     */
    public function inserisciNotifica() {
        $conn = Database::getConnection();
        $query = "INSERT INTO notifiche (uuid, utente_uuid, messaggio, letta, tipo, data_invio) VALUES (uuid(), ?, ?, ?, ?, ?)";
        $stmt = $conn->prepare($query);

        if ($stmt === false) {
            die("Errore lato server: " . $conn->error);
        }

        $lettaVal = $this->letta ? '1' : '0';
        $stmt->bind_param("sssss", $this->utente_uuid, $this->messaggio, $lettaVal, $this->tipo, $this->data_invio);

        $stmt->execute();

        if ($stmt->error) {
            die("Errore lato server: " . $stmt->error);
        }

        $stmt->close();
        $conn->close();

        $response = new Response(201, "Notifica inserita con successo");
        $response->send();
    }

    /**
     * Recupera tutte le notifiche di un utente (esempio con dati fittizi)
     */
    public static function getNotifiche($utente_uuid) {
        // Esempio di risposta mock, sostituire con query reale se necessario
        $response = new Response(200, "Notifiche recuperate con successo");
        $response->setData([
            [
                'uuid' => '1a2b3c4d-0000-0000-0000-000000000001',
                'utente_uuid' => $utente_uuid,
                'messaggio' => 'Benvenuto nella nostra app!',
                'letta' => false,
                'tipo' => 'info',
                'data_invio' => '2024-06-01 10:00:00'
            ],
            [
                'uuid' => '1a2b3c4d-0000-0000-0000-000000000002',
                'utente_uuid' => $utente_uuid,
                'messaggio' => 'Account creato con successo.',
                'letta' => false,
                'tipo' => 'miscellanea',
                'data_invio' => '2024-06-02 12:30:00'
            ],
            [
                'uuid' => '1a2b3c4d-0000-0000-0000-000000000003',
                'utente_uuid' => $utente_uuid,
                'messaggio' => 'Completa il tuo profilo.',
                'letta' => true,
                'tipo' => 'sicurezza',
                'data_invio' => '2024-06-03 09:15:00'
            ]
        ]);
        $response->send();
    }

    /**
     * Segna una notifica come letta tramite il suo UUID
     */
    public static function markAsRead($uuid){
        $conn = Database::getConnection();
        $query = "UPDATE notifiche SET letta = 1 WHERE uuid = ?";
        $stmt = $conn->prepare($query);

        if ($stmt === false) {
            die("Errore lato server: " . $conn->error);
        }

        $stmt->bind_param("s", $uuid);
        $stmt->execute();

        if ($stmt->error) {
            die("Errore lato server: " . $stmt->error);
        }

        $stmt->close();
        $conn->close();
        $response = new Response(204, "Notifica letta con successo");
        $response->send();
        return true;
    }

    /**
     * Elimina una notifica tramite il suo UUID
     */
    public static function deleteNotifica($uuid) {
        $conn = Database::getConnection();
        $query = "DELETE FROM notifiche WHERE uuid = ?";
        $stmt = $conn->prepare($query);

        if ($stmt === false) {
            die("Errore lato server: " . $conn->error);
        }

        $stmt->bind_param("s", $uuid);
        $stmt->execute();

        if ($stmt->error) {
            die("Errore lato server: " . $stmt->error);
        }

        $stmt->close();
        $conn->close();
        $response = new Response(204, "Notifica eliminata con successo");
        $response->send();
        return true;
    }
}
?>
