<?php
/**
 * Classe per la gestione della connessione al database.
 */
class Database {
    // Istanza singleton della classe Database
    private static $instance = null;
    // Oggetto di connessione MySQLi
    private $connection;

    /**
     * Costruttore privato per inizializzare la connessione al database
     */
    private function __construct() {
        $this->connection = new mysqli('localhost', 'user', 'password', 'wiki_db');
        if ($this->connection->connect_error) {
            die("Errore connessione: " . $this->connection->connect_error);
        }
    }

    /**
     * Restituisce una nuova connessione al database
     */
    public static function getConnection() {
        return $connection = new mysqli('localhost', 'root', '', 'wiki_db');
    }

    /**
     * Chiude la connessione al database e resetta l'istanza singleton
     */
    public function close() {
        if ($this->connection) {
            $this->connection->close();
            self::$instance = null;
        }
    }
}
?>