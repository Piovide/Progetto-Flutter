<?php
class SessioneLogin {
    private string $uuid;
    private string $utente_uuid;
    private string $token;
    private string $data_accesso;

    public function __construct(string $uuid, string $utente_uuid, string $token, string $data_accesso = null) {
        $this->uuid = $uuid;
        $this->utente_uuid = $utente_uuid;
        $this->token = $token;
        $this->data_accesso = $data_accesso;
    }

    public function inserisciSessione() {
        $conn = Database::getConnection();
        $query = "INSERT INTO sessioni_login (uuid, utente_uuid, token, data_accesso) VALUES (uuid(), ?, ?, ?)";
        $stmt = $conn->prepare($query);

        if ($stmt === false) {
            die("Errore lato server: " . $conn->error);
        }

        $stmt->bind_param("sss",$this->utente_uuid, $this->token, $this->data_accesso);

        $stmt->execute();

        if ($stmt->error) {
            die("Errore lato server: " . $stmt->error);
        }

        $stmt->close();
        $conn->close();
    }
}
?>
