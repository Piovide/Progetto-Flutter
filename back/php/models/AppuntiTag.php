<?php
/**
 * Modello per la gestione dell'associazione tra appunti e tag nel database.
 */
class AppuntiTag {
    // UUID dell'appunto
    private string $appunto_uuid;
    // UUID del tag
    private string $tag_uuid;

    /**
     * Costruttore della classe AppuntiTag
     */
    public function __construct(string $appunto_uuid, string $tag_uuid) {
        $this->appunto_uuid = $appunto_uuid;
        $this->tag_uuid = $tag_uuid;
    }

    /**
     * Inserisce una nuova associazione tra appunto e tag nel database
     */
    public function inserisciAppuntiTag() {
        $conn = Database::getConnection();
        $query = "INSERT INTO appunti_tag (appunto_uuid, tag_uuid) VALUES (?, ?)";
        $stmt = $conn->prepare($query);

        if ($stmt === false) {
            die("Errore lato server: " . $conn->error);
        }

        $stmt->bind_param("ss", $this->appunto_uuid, $this->tag_uuid);

        $stmt->execute();

        if ($stmt->error) {
            die("Errore lato server: " . $stmt->error);
        }

        $stmt->close();
        $conn->close();
    }
}
?>
