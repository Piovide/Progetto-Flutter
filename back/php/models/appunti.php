<?php
class appunti{
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
}

?>
