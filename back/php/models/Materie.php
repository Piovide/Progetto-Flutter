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

    public static function getMaterie($classe) {
        // $conn = Database::getConnection();
        // $query = "SELECT * FROM materie WHERE classe = ?";
        // $stmt = $conn->prepare($query);

        // if ($stmt === false) {
        //     die("Errore lato server: " . $conn->error);
        // }

        // $stmt->bind_param("s", $classe);
        // $stmt->execute();

        // if ($stmt->error) {
        //     die("Errore lato server: " . $stmt->error);
        // }

        // $result = $stmt->get_result();
        // $materie = [];

        // while ($row = $result->fetch_assoc()) {
        //     $materie[] = new Materie($row['uuid'], $row['nome'], $row['descrizione'], $row['classe']);
        // }

        // $stmt->close();
        // $conn->close();
        $materie = [
            ['uuid' => '1', 'nome' => 'Matematica', 'professore' => 'Chieppa', 'descrizione' => 'Studio dei numeri e delle forme', 'classe' => '5BII'],
            ['uuid' => '2', 'nome' => 'TPS', 'professore' => 'Frigo', 'descrizione' => 'Tecnologie progettazione sistemi informatici', 'classe' => '5BII'],
            ['uuid' => '3', 'nome' => 'Storia','professore' => 'Leone', 'descrizione' => 'Studio della storia mondiale', 'classe' => '5BII'],
            ['uuid' => '4', 'nome' => 'Informatica', 'professore' => 'Mongelli', 'descrizione' => 'Studio dei computer e della programmazione', 'classe' => '5BII']
        ];
        $response = new Response(200, "Materie recuperate con successo", $materie);
        $response->send();

    }
}
?>
