<?php
use Symfony\Component\Mailer\Transport;
use Symfony\Component\Mailer\Mailer;
use Symfony\Component\Mime\Email;

//require '../../../vendor/autoload.php';
require 'Progetto-TPS-Flutter/Progetto-Flutter/vendor/autoload.php';


$config = require 'config.php';
class AppuntiMailer{

    private $mailer;
    private $transport;

    public function __construct() {
        global $config;

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
        global $config;

        $confirmationLink = 'https://tuosito.it/verify.php?token=' . urlencode($token);

        $email = (new Email())
            ->from(sprintf('%s <%s>', $config['from_name'], $config['smtp_user']))
            ->to($toEmail)
            ->subject('Conferma il tuo account')
            ->html("
                <h2>Ciao $toName!</h2>
                <p>Grazie per esserti registrato.</p>
                <p>Clicca <a href='$confirmationLink'>qui</a> per confermare il tuo account:</p>
                <p>Se non sei stato tu, ignora questa email.</p>
            ")
            ->text("Clicca sul seguente link per confermare il tuo account: $confirmationLink");

        try {
            $this->mailer->send($email);
            return true;
        } catch (\Throwable $e) {
            error_log('Errore invio email: ' . $e->getMessage());
            return false;
        }
    }
}
