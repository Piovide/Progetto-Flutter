<?php
class AppuntiCondivisi {
    private string $uuid;
    private string $appunto_uuid;
    private string $utente_uuid;
    private ?string $data_condivisione;

    public function __construct(string $uuid, string $appunto_uuid, string $utente_uuid, ?string $data_condivisione = null) {
        $this->uuid = $uuid;
        $this->appunto_uuid = $appunto_uuid;
        $this->utente_uuid = $utente_uuid;
        $this->data_condivisione = $data_condivisione;
    }

    public function inserisciCondivisione() {
        $conn = Database::getConnection();
        $query = "INSERT INTO appunti_condivisi (uuid, appunto_uuid, utente_uuid, data_condivisione) VALUES (?, ?, ?, ?)";
        $stmt = $conn->prepare($query);

        if ($stmt === false) {
            die("Errore lato server: " . $conn->error);
        }

        $stmt->bind_param("ssss", $this->uuid, $this->appunto_uuid, $this->utente_uuid, $this->data_condivisione);

        $stmt->execute();

        if ($stmt->error) {
            die("Errore lato server: " . $stmt->error);
        }

        $stmt->close();
        $conn->close();
    }
}
?>
