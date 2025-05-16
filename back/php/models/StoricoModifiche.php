<?php
class StoricoModifiche {
    private string $uuid;
    private string $titolo;
    private string $contenuto;
    private bool $markdown;
    private ?string $visibilita;
    private string $stato;
    private ?string $data_modifica; // Opzionale se si lascia gestire al DB

    public function __construct(string $uuid, string $titolo, string $contenuto, bool $markdown = true, ?string $visibilita = null, string $stato = 'bozza', ?string $data_modifica = null) {
        $this->uuid = $uuid;
        $this->titolo = $titolo;
        $this->contenuto = $contenuto;
        $this->markdown = $markdown;
        $this->visibilita = $visibilita;
        $this->stato = $stato;
        $this->data_modifica = $data_modifica;
    }

    public function inserisciModifica() {
        $conn = Database::getConnection();
        $query = "INSERT INTO storico_modifiche (uuid, titolo, contenuto, markdown, visibilita, stato, data_modifica)
                  VALUES (uuid(), ?, ?, ?, ?, ?, ?)";
        $stmt = $conn->prepare($query);

        if ($stmt === false) {
            die("Errore lato server: " . $conn->error);
        }

        $stmt->bind_param(
            "ssssss",
            $this->titolo,
            $this->contenuto,
            //assolutamente zero idee su come funziona sta roba
            $markdown = $this->markdown ? '1' : '0',
            $this->visibilita,
            $this->stato,
            $this->data_modifica
        );

        $stmt->execute();

        if ($stmt->error) {
            die("Errore lato server: " . $stmt->error);
        }

        $stmt->close();
        $conn->close();
    }
}
?>
