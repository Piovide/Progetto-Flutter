<?php

class Response {
    private $status;
    private $message;
    private $data;
    private $headers;

    public function __construct($status, $message, $data = null) {
        $this->status = $status;
        $this->message = $message;
        $this->data = $data;
    }

    private function toJson() {
        return json_encode([
            'status' => $this->status,
            'message' => $this->message,
            'data' => $this->data
        ]);
    }

    public function setStatus($status) {
        $this->status = $status;
    }
    public function setMessage($message) {
        $this->message = $message;
    }
    public function setData($data) {
        $this->data = $data;
    }

    public function setHeaders($headers) {
        $this->headers = $headers;
    }

    public function getStatus() {
        return $this->status;
    }
    public function getMessage() {
        return $this->message;
    }
    public function getData() {
        return $this->data;
    }

    public function send() {
        header('Content-Type: application/json');
        if (isset($this->headers)) {   
            foreach ($this->headers as $key => $value) {
                header(header: "$key: $value");
            }
        }
        $this->statusCode();
        echo $this->toJson();
        exit;
    }

    public function statusCode() {
        http_response_code($this->status);
    }
}

?>