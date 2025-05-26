<?php
/**
 * Modello per la gestione delle materie nel database.
 */
include_once __DIR__ . '/../utilz/Database.php';

class Materie {
    // UUID della materia
    private string $uuid;
    // Nome della materia
    private string $nome;
    // Descrizione della materia (opzionale)
    private ?string $descrizione;
    // Classe a cui appartiene la materia
    private string $classe;

    /**
     * Costruttore della classe Materie
     */
    public function __construct(string $uuid, string $nome, ?string $descrizione, string $classe) {
        $this->uuid = $uuid;
        $this->nome = $nome;
        $this->descrizione = $descrizione;
        $this->classe = $classe;
    }

    /**
     * Inserisce una nuova materia nel database
     */
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

    /**
     * Recupera tutte le materie di una classe specifica dal database
     */
    public static function getMaterie($classe) {
        $conn = Database::getConnection();
        $query = "SELECT * FROM materie WHERE classe = ?";
        $stmt = $conn->prepare($query);

        if ($stmt === false) {
            die("Errore lato server: " . $conn->error);
        }

        $stmt->bind_param("s", $classe);
        $stmt->execute();

        if ($stmt->error) {
            die("Errore lato server: " . $stmt->error);
        }

        $result = $stmt->get_result();
        $materie = [];

        // Cicla su tutte le materie trovate e le aggiunge all'array
        while ($row = $result->fetch_assoc()) {
            $materie[] = [
                'uuid' => $row['uuid'],
                'nome' => $row['nome'],
                'descrizione' => $row['descrizione'],
                'classe' => $row['classe'],
                'professore' => $row['professore']
            ];
        }

        $stmt->close();
        $conn->close();

        // Restituisce la risposta con tutte le materie trovate
        $response = new Response(200, "Materie recuperate con successo", $materie);
        $response->send();
    }
}
?>
