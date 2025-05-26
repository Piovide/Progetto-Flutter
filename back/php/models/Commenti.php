<?php
/**
 * Modello per la gestione dei commenti agli appunti nel database.
 */
class Commenti {
    // UUID del commento
    private string $uuid;
    // UUID dell'appunto a cui si riferisce il commento
    private string $appunto_uuid;
    // UUID dell'autore del commento
    private string $autore_uuid;
    // Testo del commento
    private string $testo;
    // Data del commento (opzionale)
    private ?string $data_commento;

    /**
     * Costruttore della classe Commenti
     */
    public function __construct(string $uuid, string $appunto_uuid, string $autore_uuid, string $testo, ?string $data_commento = null) {
        $this->uuid = $uuid;
        $this->appunto_uuid = $appunto_uuid;
        $this->autore_uuid = $autore_uuid;
        $this->testo = $testo;
        $this->data_commento = $data_commento;
    }

    /**
     * Inserisce un nuovo commento nel database
     */
    public function inserisciCommento() {
        $conn = Database::getConnection();
        $query = "INSERT INTO commenti (uuid, appunto_uuid, autore_uuid, testo, data_commento) VALUES (uuid(), ?, ?, ?, ?)";
        $stmt = $conn->prepare($query);

        if ($stmt === false) {
            die("Errore lato server: " . $conn->error);
        }

        $stmt->bind_param("ssss",  $this->appunto_uuid, $this->autore_uuid, $this->testo, $this->data_commento);

        $stmt->execute();

        if ($stmt->error) {
            die("Errore lato server: " . $stmt->error);
        }

        $stmt->close();
        $conn->close();
    }
}
?>
