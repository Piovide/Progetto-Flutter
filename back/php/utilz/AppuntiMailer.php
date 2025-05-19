<?php
use Symfony\Component\Mailer\Transport;
use Symfony\Component\Mailer\Mailer;
use Symfony\Component\Mime\Email;

define('BASE_DIR', dirname(__DIR__));
require BASE_DIR . '/vendor/autoload.php';

$config = require 'config.php';

class AppuntiMailer{

    private $mailer;
    private $transport;

    public function __construct() {
        // global $config;
        $config = require 'config.php';
        $dsn = sprintf(
            'smtp://%s:%s@%s:%d',
            urlencode($config['smtp_user']),
            urlencode($config['smtp_pass']),
            $config['smtp_host'],
            $config['smtp_port']
        );

        $this->transport = Transport::fromDsn($dsn);
        $this->mailer = new Mailer($this->transport);
    }
    public function sendConfirmationEmail($toEmail, $toName, $token) {

        $config = require 'config.php';
        $confirmationLink = 'http://localhost/Progetto-Flutter/back/php/utilz/verify.php?token=' . $token;

        $email = (new Email())
            ->from(sprintf('%s <%s>', $config['from_name'], $config['smtp_user']))
            ->to($toEmail)
            ->subject('Conferma il tuo account')
            ->html("
                <h2>Ciao $toName!</h2>
                <p>Grazie per esserti registrato</p>
                <p>Clicca <a href='$confirmationLink'>clicca qui!!</a> per confermare il tuo account:</p>
                <p>Se non sei stato tu, ignora questa email.</p>
            ")
            ->text("Clicca sul seguente link per confermare il tuo account: $confirmationLink");

        try {
            $this->mailer->send($email);
            return true;
        } catch (\Throwable $e) {
            error_log( 'Errore:' . $e->getMessage());
            return false;
        }
    }

    private function spamCheck() {
        // // IP dell'utente
        // $ip = $_SERVER['REMOTE_ADDR'];

        // $conn = Database::getConnection();

        // // Conta quante richieste ha fatto oggi
        // $stmt = $conn->prepare("SELECT COUNT(*) FROM invii_email WHERE ip = ? AND data > NOW() - INTERVAL 1 HOUR");
        // $stmt->bind_param("s", $ip);
        // $stmt->execute();
        // $stmt->bind_result($count);
        // $stmt->fetch();

        // if ($count >= 5) {
        //     $stmt->close();
        //     $conn->close();
        //     return true; // Limite raggiunto
        // }

        // // Altrimenti salva la richiesta
        // $stmt = $conn->prepare("INSERT INTO invii_email (ip, data) VALUES (?, NOW())");
        // $stmt->bind_param("s", $ip);
        // $stmt->execute();
        // $stmt->close();
        // $conn->close();
        // return false;


        return false; // Disabilitato per test
    }
}
