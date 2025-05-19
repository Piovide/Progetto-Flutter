<?php
class Appunti{
    private String $appunto_uuid;
    private String $titolo;
    private String $contenuto;
    private int $markdown;
    private String $visibilta;
    private String $autore_uuid;
    private String $materia_uuid;
    private String $data_creazione;
    private String $data_ultima_modifica;
    private String $stato;

    public function Appunti(String $appunto_uuid, String $titolo, String $contenuto, int $markdown, String $visibilita, String $autore_uuid, String $materia_uuid, String $data_creazione, String $stato ){
        $this->appunto_uuid = $appunto_uuid;
        $this->titolo = $titolo;
        $this->contenuto = $contenuto;
        $this->markdown = $markdown;
        $this->visibilta = $visibilita;
        $this->autore_uuid = $autore_uuid;
        $this->materia_uuid = $materia_uuid;
        $this->data_creazione = $data_creazione;
        $this->stato = $stato;
    }

    public function inserisciAppunti(){
        $conn = Database::getConnection();
        $query = "INSERT INTO appunti values(?,?,?,?,?,?,?,'null',?,?,?)"; 
        $stmt = $conn->prepare($query);
        if($stmt === false){
            die("Errore lato server". $conn->error ."");
        }
        $stmt->bind_param("sssisssss", $this->appunto_uuid, $this->titolo, $this->contenuto, $this->markdown, $this->visibilta, $this->autore_uuid, $this->materia_uuid, $this->data_creazione, $this->stato);
        $stmt->execute();
        if(!$stmt->error === false){
            die("Errore lato server". $stmt->error ."");
        }

        $stmt->close();
        $conn->close();
    }

    static function getAppunti(){
        // $conn = database::getConnection();
        // $query = "SELECT * FROM appunti";
        // $ris = $conn->query($query);
        // if ($stmt === false) {
        //     die("Errore lato server: " . $conn->error);
        // }

        // $result = $stmt->get_result();
        // if ($result->num_rows == 0) {
            // $stmt->close();
            // $conn->close();
            // $response = new Response(404, "Nessuna notifica trovata");
            // $response->send();
            // return;
        // }

        /*$appunti = [];
        while($row = $ris->fetch_assoc){
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
        }*/

         $response = new Response(200, "appunti recuperati con successo");
         $response->setData([
                    [
                        'appunto_uuid' =>'9233df1c-3410-11f0-ad98-088fc32680d9',
                        'titolo' => 'gli appunti di piero',
                        'contenuto' => 'contenuto bello',
                        'markdown' => '<title>daje</title>',
                        'visibilita' => 'visibile',
                        'autore_uuid' => 'f9588744-3410-11f0-ad98-088fc32680d9',
                        'materia_uuid' => '0b196c51-3411-11f0-ad98-088fc32680d9',
                        'data_creazione' => '2025-05-18 21:56:24',
                        'stato'=>'revisionato'
                    ],
                    [
                        'appunto_uuid' =>'9233df1c-3410-11f0-ad98-088fc32680d9',
                        'titolo' => 'gli appunti di piero',
                        'contenuto' => 'contenuto bello',
                        'markdown' => '<title>ceOLin</title>',
                        'visibilita' => 'visibile',
                        'autore_uuid' => 'f9588754-3410-11f0-ad98-088fc32680d9',
                        'materia_uuid' => '0b194c51-3411-11f0-ad98-088fc32680d9',
                        'data_creazione' => '2025-05-18 21:56:24',
                        'stato'=>'non so'
                    ]
                    ]);
                    $response->send();
    }
    static function getAppuntiById(string $appunto_uuid){
        $conn = database::getConnection();
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

        while($row = $stmt->fetch_assoc){
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
        $response = new Response(200, "appunto by id recuperato con successo");
        $response->setData($appunti);
    }

    static function getAppuntiByMateria(string $materia_uuid){
        $conn = database::getConnection();
        $query = "SELECT * FROM appunti WHERE materia_uuid = ?";
        $stmt = $conn->prepare($query);
        if($stmt === false){
            die("Errore lato server". $conn->error ."");
        }
        $stmt->bind_param("s", $materia_uuid);
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

        while($row = $stmt->fetch_assoc){
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
        $response = new Response(200, "appunto by materia recuperato con successo");
        $response->setData($appunti);
    }
}
?>
