<?php
include_once __DIR__ . '/../utilz/Database.php';

class Appunti{
    private String $appunto_uuid ;
    private String $titolo;
    private String $contenuto;
    private int $markdown;
    private String $visibilta;
    private String $autore_uuid;
    private String $materia_uuid;

    public function __construct( String $titolo, String $contenuto, int $markdown, String $visibilita, String $autore_uuid, String $materia_uuid){
       // $this->appunto_uuid = $appunto_uuid;
        $this->titolo = $titolo;
        $this->contenuto = $contenuto;
        $this->markdown = $markdown;
        $this->visibilta = $visibilita;
        $this->autore_uuid = $autore_uuid;
        $this->materia_uuid = $materia_uuid;
    }

    public function inserisciAppunti(){
        $conn = Database::getConnection();
        $query = "INSERT INTO appunti (uuid, titolo, contenuto, markdown, visibilita, autore_uuid, materia_uuid) VALUES (UUID(), ?, ?, ?, ?, ?, ?)";
        $stmt = $conn->prepare($query);
        if($stmt === false){
            // $response = new Response(500, "Errore lato server". $conn->error ."");
            $response = new Response(500, "Errore lato server riprovare più tardi");
            $response->send();
            die("Errore lato server". $conn->error ."");
        }
        $stmt->bind_param("ssisss", $this->titolo, $this->contenuto, $this->markdown, $this->visibilta, $this->autore_uuid, $this->materia_uuid);
        $stmt->execute();
        if(!$stmt->error === false){
            // $response = new Response(500, "Errore lato server". $stmt->error ."");
            $response = new Response(500, "Errore lato server riprovare più tardi");
            $response->send();
            die("Errore lato server ". $stmt->error ."");
        }

        $stmt->close();
        $conn->close();
        $response = new Response(201, "Appunto inserito con successo");
        $response->send();
    }

    public static function getAppunti(){
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
            $appunti[]=[
                'uuid' =>$row['uuid'],
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
        // $response->setData([[
        //                     'appunto_uuid' =>'9233df1c-3410-11f0-ad98-088fc32680d9',
        //                     'titolo' => 'gli appunti di piero',
        //                     'contenuto' => 'contenuto bello',
        //                     'markdown' => '<title>daje</title>',
        //                     'visibilita' => 'visibile',
        //                     'autore_uuid' => 'f9588744-3410-11f0-ad98-088fc32680d9',
        //                     'materia_uuid' => '0b196c51-3411-11f0-ad98-088fc32680d9',
        //                     'data_creazione' => '2025-05-18 21:56:24',
        //                     'stato'=>'revisionato'
        // ],
        // [
        //                     'appunto_uuid' =>'9233df1c-3410-11f0-ad98-088fc32680d9',
        //                     'titolo' => 'gli appunti di franco',
        //                     'contenuto' => 'contenuto bello',
        //                     'markdown' => '<title>daje</title>',
        //                     'visibilita' => 'visibile',
        //                     'autore_uuid' => '114759b3-37b0-11f0-a062-505a65fbd4fe',
        //                     'materia_uuid' => '0b196c51-3411-11f0-ad98-088fc32680d9',
        //                     'data_creazione' => '2025-05-18 21:56:24',
        //                     'stato'=>'revisionato'
        // ]]);

        $response->send();
    }
    public static function getAppuntiById(string $appunto_uuid){
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
            $appunti[]=[
                'appunto_uuid' =>$row['uuid'],
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

    public static function getAppuntiByAutore(string $autore_uuid){
        $conn = Database::getConnection();
        $query = "SELECT * FROM appunti WHERE autore_uuid = ?";
        $stmt = $conn->prepare($query);
        if($stmt === false){
            // $response = new Response(500, "Errore lato server". $conn->error ."");
            $response = new Response(500, "Errore lato server riprovare più tardi");
            $response->send();
            die("Errore lato server". $conn->error ."");
        }
        $stmt->bind_param("s", $autore_uuid);
        $stmt->execute();
        if(!$stmt->error === false){
            // $response = new Response(500, "Errore lato server". $stmt->error ."");
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
            $appunti[]=[
                'uuid' =>$row['uuid'],
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

    public static function getAppuntiByMateria(string $materia_uuid, string $classe){
        $conn = Database::getConnection();
        $query = "SELECT * FROM appunti A INNER JOIN materie M WHERE materia_uuid = ? AND M.classe = ?";
        $stmt = $conn->prepare($query);
        if($stmt === false){
            // $response = new Response(500, "Errore lato server". $conn->error ."");
            $response = new Response(500, "Errore lato server riprovare più tardi");
            $response->send();
            die("Errore lato server". $conn->error ."");
        }
        $stmt->bind_param("ss", $materia_uuid, $classe);
        $stmt->execute();
        if(!$stmt->error === false){
            // $response = new Response(500, "Errore lato server". $stmt->error ."");
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
            $appunti[]=[
                'appunto_uuid' =>$row['appunto_uuid'],
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
    }

    public static function updateAppunto($titolo, $contenuto, $appunto_uuid){
        $conn = Database::getConnection();
        $query = "UPDATE appunti SET titolo = ?, contenuto = ? WHERE uuid = ?";
        $stmt = $conn->prepare($query);
        if($stmt === false){
            // $response = new Response(500, "Errore lato server". $conn->error ."");
            $response = new Response(500, "Errore lato server riprovare più tardi");
            $response->send();
            return;
        }
        $stmt->bind_param("sss", $titolo, $contenuto, $appunto_uuid);
        $stmt->execute();
        if(!$stmt->error === false){
            // $response = new Response(500, "Errore lato server". $stmt->error ."");
            $response = new Response(500, "Errore lato server riprovare più tardi");
            $response->send();
            return;
        }

        $stmt->close();
        $conn->close();
        $response = new Response(200, "Appunto aggiornato con successo".$contenuto);
        $response->send();
        return;
    }

}
?>
