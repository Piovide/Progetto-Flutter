<?php
class Database {
    private static $instance = null;
    private $connection;

    private function __construct() {
        $this->connection = new mysqli('localhost', 'user', 'password', 'wiki_db');
        if ($this->connection->connect_error) {
            die("Errore connessione: " . $this->connection->connect_error);
        }
    }

    public static function getConnection() {
        return $connection = new mysqli('localhost', 'root', '', 'wiki_db');
    }

    public function close() {
        if ($this->connection) {
            $this->connection->close();
            self::$instance = null;
        }
    }

}
?>