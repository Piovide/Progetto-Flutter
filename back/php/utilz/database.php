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
        if (!self::$instance) {
            self::$instance = new Database();
        }
        return self::$instance->connection;
    }

    public function close() {
        if ($this->connection) {
            $this->connection->close();
            self::$instance = null;
        }
    }

    public function performQuery($query, $params) {
        $stmt = $this->connection->prepare($query);
        if ($stmt === false) {
            die("Errore preparazione query: " . $this->connection->error);
        }

        if ($params) {
            $stmt->bind_param(...$params);
        }

        $stmt->execute();
        if ($stmt->error) {
            die("Errore esecuzione query: " . $stmt->error);
        }

        return $stmt->get_result();
    }

}
?>