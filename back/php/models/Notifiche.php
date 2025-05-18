<?php
class Notifica {
    private string $uuid;
    private string $utente_uuid;
    private string $messaggio;
    private bool $letta;
    private string $tipo;
    private ?string $data_invio;

    public function __construct(string $uuid = null, string $utente_uuid, string $messaggio, string $tipo, bool $letta = false, ?string $data_invio = null) {
        $this->uuid = $uuid;
        $this->utente_uuid = $utente_uuid;
        $this->messaggio = $messaggio;
        $this->letta = $letta;
        $this->tipo = $tipo;
        $this->data_invio = $data_invio;
    }

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

    public static function getNotifiche($utente_uuid) {
        // $conn = Database::getConnection();
        // $query = "SELECT * FROM notifiche WHERE utente_uuid = ? ORDER BY data_invio DESC";
        // $stmt = $conn->prepare($query);

        // if ($stmt === false) {
        //     die("Errore lato server: " . $conn->error);
        // }

        // $stmt->bind_param("s", $utente_uuid);
        // $stmt->execute();

        // if ($stmt->error) {
        //     die("Errore lato server: " . $stmt->error);
        // }

        // $result = $stmt->get_result();
        // if ($result->num_rows == 0) {
            // $stmt->close();
            // $conn->close();
            // $response = new Response(404, "Nessuna notifica trovata");
            // $response->send();
            // return;
        // }

        // $notifiche = [];
        // while ($row = $result->fetch_assoc()) {
        //     $notifiche[] = [
        //         'uuid' => $row['uuid'],
        //         'utente_uuid' => $row['utente_uuid'],
        //         'messaggio' => $row['messaggio'],
        //         'letta' => $row['letta'] == 1,
        //         'tipo' => $row['tipo'],
        //         'data_invio' => $row['data_invio']
        //     ];
        // }
        // $stmt->close();
        // $conn->close();
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
            'messaggio' => 'Hai un nuovo messaggio.',
            'letta' => false,
            'tipo' => 'messaggio',
            'data_invio' => '2024-06-02 12:30:00'
            ],
            [
            'uuid' => '1a2b3c4d-0000-0000-0000-000000000003',
            'utente_uuid' => $utente_uuid,
            'messaggio' => 'La tua password è stata aggiornata.',
            'letta' => true,
            'tipo' => 'sicurezza',
            'data_invio' => '2024-06-03 09:15:00'
            ]
        ]);
        // $response->setData($notifiche);
        $response->send();
    }

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
