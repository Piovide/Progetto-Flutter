<?php
/**
 * Modello per la gestione dei tag nel database.
 */
class Tag {
    // UUID del tag
    private string $uuid;
    // Nome del tag
    private string $nome;
    // Descrizione del tag (opzionale)
    private ?string $descrizione;

    /**
     * Costruttore della classe Tag
     */
    public function __construct(string $uuid, string $nome, ?string $descrizione) {
        $this->uuid = $uuid;
        $this->nome = $nome;
        $this->descrizione = $descrizione;
    }

    /**
     * Inserisce un nuovo tag nel database
     */
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
