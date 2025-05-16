<?php
class Revisione {
    private string $uuid;
    private string $appunto_uuid;
    private ?string $revisore_uuid;
    private ?string $commento;
    private ?string $data_revisionamento;

    public function __construct(string $uuid, string $appunto_uuid, ?string $revisore_uuid = null, ?string $commento = null, ?string $data_revisionamento = null) {
        $this->uuid = $uuid;
        $this->appunto_uuid = $appunto_uuid;
        $this->revisore_uuid = $revisore_uuid;
        $this->commento = $commento;
        $this->data_revisionamento = $data_revisionamento;
    }

    public function inserisciRevisione() {
        $conn = Database::getConnection();
        $query = "INSERT INTO revisioni (uuid, appunto_uuid, revisore_uuid, commento, data_revisionamento) VALUES (?, ?, ?, ?, ?)";
        $stmt = $conn->prepare($query);

        if ($stmt === false) {
            die("Errore lato server: " . $conn->error);
        }

        $stmt->bind_param("sssss", $this->uuid, $this->appunto_uuid, $this->revisore_uuid, $this->commento, $this->data_revisionamento);

        $stmt->execute();

        if ($stmt->error) {
            die("Errore lato server: " . $stmt->error);
        }

        $stmt->close();
        $conn->close();
    }
}
?>
