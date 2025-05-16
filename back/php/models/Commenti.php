<?php
class Commenti {
    private string $uuid;
    private string $appunto_uuid;
    private string $autore_uuid;
    private string $testo;
    private ?string $data_commento;

    public function __construct(string $uuid, string $appunto_uuid, string $autore_uuid, string $testo, ?string $data_commento = null) {
        $this->uuid = $uuid;
        $this->appunto_uuid = $appunto_uuid;
        $this->autore_uuid = $autore_uuid;
        $this->testo = $testo;
        $this->data_commento = $data_commento;
    }

    public function inserisciCommento() {
        $conn = Database::getConnection();
        $query = "INSERT INTO commenti (uuid, appunto_uuid, autore_uuid, testo, data_commento) VALUES (uuid(), ?, ?, ?, ?)";
        $stmt = $conn->prepare($query);

        if ($stmt === false) {
            die("Errore lato server: " . $conn->error);
        }

        $stmt->bind_param("sssss",  $this->appunto_uuid, $this->autore_uuid, $this->testo, $this->data_commento);

        $stmt->execute();

        if ($stmt->error) {
            die("Errore lato server: " . $stmt->error);
        }

        $stmt->close();
        $conn->close();
    }
}
?>
