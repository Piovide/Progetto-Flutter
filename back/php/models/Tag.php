<?php
class Tag {
    private string $uuid;
    private string $nome;
    private ?string $descrizione;

    public function __construct(string $uuid, string $nome, ?string $descrizione) {
        $this->uuid = $uuid;
        $this->nome = $nome;
        $this->descrizione = $descrizione;
    }

    public function inserisciTag() {
        $conn = Database::getConnection();
        $query = "INSERT INTO tag (uuid, nome, descrizione) VALUES (uuid(), ?, ?)";
        $stmt = $conn->prepare($query);

        if ($stmt === false) {
            die("Errore lato server: " . $conn->error);
        }

        $stmt->bind_param("ss", $this->nome, $this->descrizione);
        $stmt->execute();

        if ($stmt->error) {
            die("Errore lato server: " . $stmt->error);
        }

        $stmt->close();
        $conn->close();
    }
}
?>
