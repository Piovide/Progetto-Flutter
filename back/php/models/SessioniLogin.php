<?php
/**
 * Modello per la gestione delle sessioni di login nel database.
 */
class SessioneLogin {
    // UUID della sessione di login
    private string $uuid;
    // UUID dell'utente che ha effettuato l'accesso
    private string $utente_uuid;
    // Token della sessione
    private string $token;
    // Data e ora dell'accesso (opzionale)
    private string $data_accesso;

    /**
     * Costruttore della classe SessioneLogin
     */
    public function __construct(string $uuid, string $utente_uuid, string $token, string $data_accesso = null) {
        $this->uuid = $uuid;
        $this->utente_uuid = $utente_uuid;
        $this->token = $token;
        $this->data_accesso = $data_accesso;
    }

    /**
     * Inserisce una nuova sessione di login nel database
     */
    public function inserisciSessione() {
        $conn = Database::getConnection();
        $query = "INSERT INTO sessioni_login (uuid, utente_uuid, token, data_accesso) VALUES (uuid(), ?, ?, ?)";
        $stmt = $conn->prepare($query);

        if ($stmt === false) {
            die("Errore lato server: " . $conn->error);
        }

        $stmt->bind_param("sss", $this->utente_uuid, $this->token, $this->data_accesso);

        $stmt->execute();

        if ($stmt->error) {
            die("Errore lato server: " . $stmt->error);
        }

        $stmt->close();
        $conn->close();
    }
}
?>
