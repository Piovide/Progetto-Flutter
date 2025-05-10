<?php
// index.php

require_once 'utilz/database.php';
require_once 'utilz/Response.php';
require_once 'utilz/Auth.php';

$requestMethod = $_SERVER['REQUEST_METHOD'];
$endpoint = $_SERVER['HTTP_X_ENDPOINT'] ?? null;

if (!$endpoint) {
    (new Response(400, "Missing X-Endpoint header"))->send();
    exit;
}
echo $endpoint;
if ($requestMethod === 'POST') {
    if ($endpoint === 'login') {
        $inputData = file_get_contents('php://input');
        $data = json_decode($inputData, true);

        if (json_last_error() !== JSON_ERROR_NONE) {
            $response = new Response(400, "Invalid JSON");
            $response->send();
            exit;
        }

        if (!isset($data['username']) || !isset($data['password'])) {
            $response = new Response(400, "Missing required fields");
            $response->send();
            exit;
        }
        $auth = new Auth();
        $auth->login($data['username'], $data['password']);

    } elseif ($endpoint === 'register') {
        $inputData = file_get_contents('php://input');
        $data = json_decode($inputData, true);

        if (json_last_error() !== JSON_ERROR_NONE) {
            $response = new Response(400, "Invalid JSON");
            $response->send();
            exit;
        }

        if (!isset($data['username']) || !isset($data['nome']) || !isset($data['cognome']) || !isset($data['dataNascita']) || !isset($data['sesso']) || !isset($data['email']) || !isset($data['password'])) {
            $response = new Response(400, "Missing required fields");
            $response->send();
            exit;
        }
        $auth = new Auth();
        $auth->register($data['username'], $data['nome'], $data['cognome'], $data['dataNascita'], $data['sesso'], $data['email'], $data['password']);
    }
} else {
    $response = new Response(405, "Method Not Allowed");
    $response->send();
}
?>