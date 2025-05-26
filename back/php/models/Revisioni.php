<?php
/**
 * Modello per la gestione delle revisioni degli appunti nel database.
 */
class Revisione {
    // UUID della revisione
    private string $uuid;
    // UUID dell'appunto revisionato
    private string $appunto_uuid;
    // UUID del revisore (opzionale)
    private ?string $revisore_uuid;
    // Commento della revisione (opzionale)
    private ?string $commento;
    // Data della revisione (opzionale)
    private ?string $data_revisionamento;

    /**
     * Costruttore della classe Revisione
     */
    public function __construct(string $uuid, string $appunto_uuid, ?string $revisore_uuid = null, ?string $commento = null, ?string $data_revisionamento = null) {
        $this->uuid = $uuid;
        $this->appunto_uuid = $appunto_uuid;
        $this->revisore_uuid = $revisore_uuid;
        $this->commento = $commento;
        $this->data_revisionamento = $data_revisionamento;
    }

    /**
     * Inserisce una nuova revisione nel database
     */
    public function inserisciRevisione() {
        $conn = Database::getConnection();
        $query = "INSERT INTO revisioni (uuid, appunto_uuid, revisore_uuid, commento, data_revisionamento) VALUES (UUID(), ?, ?, ?, ?)";
        $stmt = $conn->prepare($query);

        if ($stmt === false) {
            die("Errore lato server: " . $conn->error);
        }

        $stmt->bind_param("ssss", $this->appunto_uuid, $this->revisore_uuid, $this->commento, $this->data_revisionamento);

        $stmt->execute();

        if ($stmt->error) {
            die("Errore lato server: " . $stmt->error);
        }

        $stmt->close();
        $conn->close();
    }
}
?>
