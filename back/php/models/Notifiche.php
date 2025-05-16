<?php
class Notifica {
    private string $uuid;
    private string $utente_uuid;
    private string $messaggio;
    private bool $letta;
    private string $tipo;
    private ?string $data_invio;

    public function __construct(string $uuid, string $utente_uuid, string $messaggio, string $tipo, bool $letta = false, ?string $data_invio = null) {
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
    }
}
?>
