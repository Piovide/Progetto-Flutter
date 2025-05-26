<?php
/**
 * Modello per la gestione dei log di invio email nel database.
 */
class InvioEmail {
    // UUID del log di invio
    private string $uuid;
    // Indirizzo IP da cui è partita la richiesta
    private string $ip;
    // Data dell'invio (opzionale)
    private string $data;

    /**
     * Costruttore della classe InvioEmail
     */
    public function __construct(string $ip, string $data = null) {
        $this->ip = $ip;
        $this->data = $data;
    }

    /**
     * Registra un nuovo invio email nel database
     */
    public function registraInvio() {
        $conn = Database::getConnection();
        $query = "INSERT INTO invii_email (uuid, ip, data) VALUES (uuid(), ?, ?)";
        $stmt = $conn->prepare($query);

        if ($stmt === false) {
            die("Errore lato server: " . $conn->error);
        }

        $stmt->bind_param("ss", $this->ip, $this->data);

        $stmt->execute();

        if ($stmt->error) {
            die("Errore lato server: " . $stmt->error);
        }

        $stmt->close();
        $conn->close();
    }
}
?>
