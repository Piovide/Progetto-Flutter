<?php
class InvioEmail {
    private string $uuid;
    private string $ip;
    private string $data;

    public function __construct(string $ip, string $data = null) {
        $this->ip = $ip;
        $this->data = $data;
    }

    public function registraInvio() {
        $conn = Database::getConnection();
        $query = "INSERT INTO invii_email (uuid,ip,data) VALUES (uuid(),?, ?)";
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
