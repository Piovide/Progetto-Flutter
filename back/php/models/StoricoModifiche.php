<?php
/**
 * Modello per la gestione dello storico delle modifiche degli appunti nel database.
 */
class StoricoModifiche {
    // UUID della modifica
    private string $uuid;
    // Titolo dell'appunto modificato
    private string $titolo;
    // Contenuto dell'appunto modificato
    private string $contenuto;
    // Indica se il contenuto è in markdown
    private bool $markdown;
    // Visibilità dell'appunto (opzionale)
    private ?string $visibilita;
    // Stato dell'appunto (es: bozza, pubblicato)
    private string $stato;
    // Data della modifica (opzionale, può essere gestita dal DB)
    private ?string $data_modifica;

    /**
     * Costruttore della classe StoricoModifiche
     */
    public function __construct(string $uuid, string $titolo, string $contenuto, bool $markdown = true, ?string $visibilita = null, string $stato = 'bozza', ?string $data_modifica = null) {
        $this->uuid = $uuid;
        $this->titolo = $titolo;
        $this->contenuto = $contenuto;
        $this->markdown = $markdown;
        $this->visibilita = $visibilita;
        $this->stato = $stato;
        $this->data_modifica = $data_modifica;
    }

    /**
     * Inserisce una nuova modifica nello storico nel database
     */
    public function inserisciModifica() {
        $conn = Database::getConnection();
        $query = "INSERT INTO storico_modifiche (uuid, titolo, contenuto, markdown, visibilita, stato, data_modifica)
                  VALUES (uuid(), ?, ?, ?, ?, ?, ?)";
        $stmt = $conn->prepare($query);

        if ($stmt === false) {
            die("Errore lato server: " . $conn->error);
        }
        $markdownVal = $this->markdown ? '1' : '0';
        $stmt->bind_param(
            "ssssss",
            $this->titolo,
            $this->contenuto,
            $markdownVal,
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
