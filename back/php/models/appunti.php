<?php
// Modello per la gestione degli appunti nel database
include_once __DIR__ . '/../utilz/Database.php';

class Appunti {
    // Proprietà dell'appunto
    private String $appunto_uuid;
    private String $titolo;
    private String $contenuto;
    private int $markdown;
    private String $visibilta;
    private String $autore_uuid;
    private String $materia_uuid;

    /**
     * Costruttore della classe Appunti
     */
    public function __construct(String $titolo, String $contenuto, int $markdown, String $visibilita, String $autore_uuid, String $materia_uuid) {
        $this->titolo = $titolo;
        $this->contenuto = $contenuto;
        $this->markdown = $markdown;
        $this->visibilta = $visibilita;
        $this->autore_uuid = $autore_uuid;
        $this->materia_uuid = $materia_uuid;
    }

    /**
     * Inserisce un nuovo appunto nel database
     */
    public function inserisciAppunti() {
        $conn = Database::getConnection();
        $query = "INSERT INTO appunti (uuid, titolo, contenuto, markdown, visibilita, autore_uuid, materia_uuid) VALUES (UUID(), ?, ?, ?, ?, ?, ?)";
        $stmt = $conn->prepare($query);
        if($stmt === false){
            $response = new Response(500, "Errore lato server riprovare più tardi");
            $response->send();
            die("Errore lato server". $conn->error ."");
        }
        $stmt->bind_param("ssisss", $this->titolo, $this->contenuto, $this->markdown, $this->visibilta, $this->autore_uuid, $this->materia_uuid);
        $stmt->execute();
        if(!$stmt->error === false){
            $response = new Response(500, "Errore lato server riprovare più tardi");
            $response->send();
            die("Errore lato server ". $stmt->error ."");
        }

        $stmt->close();
        $conn->close();
        $response = new Response(201, "Appunto inserito con successo");
        $response->send();
    }

    /**
     * Recupera tutti gli appunti dal database
     */
    public static function getAppunti() {
        $conn = database::getConnection();
        $query = "SELECT * FROM appunti";
        $stmt = $conn->prepare($query);
        if ($stmt === false) {
            $response = new Response(500, "Errore lato server riprovare più tardi");
            $response->send();
        }
        $stmt->execute();
        if ($stmt->error) {
            $response = new Response(500, "Errore lato server riprovare più tardi");
            $response->send();
        }
        $result = $stmt->get_result();
        if ($result->num_rows == 0) {
            $stmt->close();
            $conn->close();
            $response = new Response(404, "Nessuna appunto trovato");
            $response->send();
            return;
        }

        $appunti = [];
        while($row = $result->fetch_assoc()){
            $appunti[] = [
                'uuid' => $row['uuid'],
                'titolo' => $row['titolo'],
                'contenuto' => $row['contenuto'],
                'markdown' => $row['markdown'],
                'visibilita' => $row['visibilita'],
                'autore_uuid' => $row['autore_uuid'],
                'materia_uuid' => $row['materia_uuid'],
                'data_creazione' => $row['data_creazione'],
                'stato'=> $row['stato']
            ];
        }

        $response = new Response(200, "appunti recuperati con successo");
        $response->setData($appunti);
        $response->send();
    }

    /**
     * Recupera un appunto tramite il suo UUID
     */
    public static function getAppuntiById(string $appunto_uuid) {
        $conn = Database::getConnection();
        $query = "SELECT * FROM appunti WHERE appunto_uuid = ?";
        $stmt = $conn->prepare($query);
        if($stmt === false){
            die("Errore lato server". $conn->error ."");
        }
        $stmt->bind_param("s", $appunto_uuid);
        $stmt->execute();
        if(!$stmt->error === false){
            die("Errore lato server". $stmt->error ."");
        }

        $result = $stmt->get_result();
        if ($result->num_rows == 0) {
            $stmt->close();
            $conn->close();
            $response = new Response(404, "Nessun appunto trovato");
            $response->send();
            return;
        }

        while($row = $result->fetch_assoc()){
            $appunti[] = [
                'appunto_uuid' => $row['uuid'],
                'titolo' => $row['titolo'],
                'contenuto' => $row['contenuto'],
                'markdown' => $row['markdown'],
                'visibilita' => $row['visibilita'],
                'autore_uuid' => $row['autore_uuid'],
                'materia_uuid' => $row['materia_uuid'],
                'data_creazione' => $row['data_creazione'],
                'stato'=> $row['stato']
            ];
        }
        $response = new Response(200, "appunto by id recuperato con successo");
        $response->setData($appunti);
    }

    /**
     * Recupera tutti gli appunti di un autore tramite il suo UUID
     */
    public static function getAppuntiByAutore(string $autore_uuid) {
        $conn = Database::getConnection();
        $query = "SELECT * FROM appunti WHERE autore_uuid = ?";
        $stmt = $conn->prepare($query);
        if($stmt === false){
            $response = new Response(500, "Errore lato server riprovare più tardi");
            $response->send();
            die("Errore lato server". $conn->error ."");
        }
        $stmt->bind_param("s", $autore_uuid);
        $stmt->execute();
        if(!$stmt->error === false){
            $response = new Response(500, "Errore lato server riprovare più tardi");
            $response->send();
            die("Errore lato server". $stmt->error ."");
        }

        $result = $stmt->get_result();
        if ($result->num_rows == 0) {
            $stmt->close();
            $conn->close();
            $response = new Response(404, "Nessun appunto trovato");
            $response->send();
            return;
        }

        while($row = $result->fetch_assoc()){
            $appunti[] = [
                'uuid' => $row['uuid'],
                'titolo' => $row['titolo'],
                'contenuto' => $row['contenuto'],
                'markdown' => $row['markdown'],
                'visibilita' => $row['visibilita'],
                'autore_uuid' => $row['autore_uuid'],
                'materia_uuid' => $row['materia_uuid'],
                'data_creazione' => $row['data_creazione'],
                'stato'=> $row['stato']
            ];
        }
        $response = new Response(200, "appunto by autore recuperato con successo");
        $response->setData($appunti);
        $response->send();
        return;
    }

    /**
     * Recupera tutti gli appunti di una materia e classe specifica
     */
    public static function getAppuntiByMateria(string $materia_uuid, string $classe) {
        $conn = Database::getConnection();
        $query = "SELECT * FROM appunti A INNER JOIN materie M ON A.materia_uuid = M.uuid WHERE M.nome = ? AND M.classe = ?";
        $stmt = $conn->prepare($query);
        if($stmt === false){
            $response = new Response(500, "Errore lato server riprovare più tardi");
            $response->send();
            die("Errore lato server". $conn->error ."");
        }
        $stmt->bind_param("ss", $materia_uuid, $classe);
        $stmt->execute();
        if(!$stmt->error === false){
            $response = new Response(500, "Errore lato server riprovare più tardi");
            $response->send();
            die("Errore lato server". $stmt->error ."");
        }

        $result = $stmt->get_result();
        if ($result->num_rows == 0) {
            $stmt->close();
            $conn->close();
            $response = new Response(404, "Nessun appunto trovato");
            $response->send();
            return;
        }

        while($row = $result->fetch_assoc()){
            $appunti[] = [
                'uuid' => $row['uuid'],
                'titolo' => $row['titolo'],
                'contenuto' => $row['contenuto'],
                'markdown' => $row['markdown'],
                'visibilita' => $row['visibilita'],
                'autore_uuid' => $row['autore_uuid'],
                'materia_uuid' => $row['materia_uuid'],
                'data_creazione' => $row['data_creazione'],
                'stato'=> $row['stato']
            ];
        }
        $response = new Response(200, "appunti recuperato con successo");
        $response->setData($appunti);
        $response->send();
        return;
    }

    /**
     * Aggiorna titolo e contenuto di un appunto tramite il suo UUID
     */
    public static function updateAppunto($titolo, $contenuto, $appunto_uuid) {
        $conn = Database::getConnection();
        $query = "UPDATE appunti SET titolo = ?, contenuto = ? WHERE uuid = ?";
        $stmt = $conn->prepare($query);
        if($stmt === false){
            $response = new Response(500, "Errore lato server riprovare più tardi");
            $response->send();
            return;
        }
        $stmt->bind_param("sss", $titolo, $contenuto, $appunto_uuid);
        $stmt->execute();
        if(!$stmt->error === false){
            $response = new Response(500, "Errore lato server riprovare più tardi");
            $response->send();
            return;
        }
        if($stmt->affected_rows === 0){
            $stmt->close();
            $conn->close();
            $response = new Response(404, "Nessun appunto trovato con l'uuid specificato".$appunto_uuid);
            $response->send();
            return;
        }
        $stmt->close();
        $conn->close();
        $response = new Response(200, "Appunto aggiornato con successo".$contenuto);
        $response->send();
        return;
    }

    public static function deleteAppunto($appunto_uuid) {
        $conn = Database::getConnection();
        $query = "DELETE FROM appunti WHERE uuid = ?";
        $stmt = $conn->prepare($query);
        if($stmt === false){
            $response = new Response(500, "Errore lato server riprovare più tardi");
            $response->send();
            return;
        }
        $stmt->bind_param("s", $appunto_uuid);
        $stmt->execute();
        if(!$stmt->error === false){
            $response = new Response(500, "Errore lato server riprovare più tardi");
            $response->send();
            return;
        }
        if($stmt->affected_rows === 0){
            $stmt->close();
            $conn->close();
            $response = new Response(404, "Nessun appunto trovato con l'uuid specificato".$appunto_uuid);
            $response->send();
            return;
        }
        $stmt->close();
        $conn->close();
        $response = new Response(200, "Appunto eliminato con successo");
        $response->send();
    }
}
?>
