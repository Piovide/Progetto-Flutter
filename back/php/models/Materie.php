<?php
class Materie {
    private string $uuid;
    private string $nome;
    private ?string $descrizione;
    private string $classe;

    public function __construct(string $uuid, string $nome, ?string $descrizione, string $classe) {
        $this->uuid = $uuid;
        $this->nome = $nome;
        $this->descrizione = $descrizione;
        $this->classe = $classe;
    }

    public function inserisciMateria() {
        $conn = Database::getConnection();
        $query = "INSERT INTO materie (uuid, nome, descrizione, classe) VALUES (?, ?, ?, ?)";
        $stmt = $conn->prepare($query);

        if ($stmt === false) {
            die("Errore lato server: " . $conn->error);
        }

        $stmt->bind_param("ssss", $this->uuid, $this->nome, $this->descrizione, $this->classe);
        $stmt->execute();

        if ($stmt->error) {
            die("Errore lato server: " . $stmt->error);
        }

        $stmt->close();
        $conn->close();
    }
}
?>
