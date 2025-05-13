# Wiki Appunti

## *Ceolin Giovanni, Furlan Marco, Piovesan Davide*

Spunti sulla grafica → [link](http://flutterlibrary.com)

### **Login/Register**

* Possibilità di login automatico (salvataggio token sicuro).  
* conferma account tramite mail.  
* controlli sui campi.

---

### **Profilo**

* Campi modificabili: nome utente, bio, immagine profilo, preferenze tema (chiaro/scuro), notifiche.  
* amici (richieste, ricerca, visualizzazione)  
* Storico attività (modifiche fatte, appunti scritti).  
* Gestione appunti personali (bozze, pubblicati, in revisione).  
* Sistema di ruoli (utente, revisore, admin, docente).

---

### **Dashboard (Home Page)**

* Elenco appunti filtrabile per materia, autore, tag ...  
* Ricerca titoli appunti.  
* Feed personalizzato con i nuovi appunti pubblicati e preferiti.

---

### **Visualizzazione appunti**

* Parsing Markdown lato server o client (usando `flutter_markdown`).  
* Supporto immagini (caricamento \+ compressione prima dell’upload).  
* Visualizzazione link interni con anteprima hover/pop-up (tipo Wikipedia).  
* sezione commenti.

---

### **Modifica appunti**

* Editor live preview markdown.  
* Cronologia delle modifiche.  
* Salvataggio automatico durante la scrittura (in locale e alla fine upload nel server).

---

### **Revisione appunti**

* Area dedicata ai revisori con lista degli appunti in attesa.  
* Possibilità di lasciare commenti visibili solo all'autore.  
* Notifiche a chi ha scritto l'appunto dopo una revisione.

---

### **Collegamenti fra pagine**

* Riconoscimento automatico dei link a pagine esistenti (con suggerimento durante la scrittura).  
* Gestione link rotti con notifica all’autore o revisori.

---

### **Extra:**

* Modalità offline con sincronizzazione successiva (usando cache locale).  
* Plugin estendibili (es. formule LaTeX, quiz integrati, ecc).  
* Ricerca through-text come seconda opzione in caso la prima fallisca.

---

# Struttura del Database (MySQL)

#### **Descrizione generale e relazioni tra tabelle principali:**

* **utenti**: contiene le informazioni principali dell’account. Relazionata con appunti, commenti, revisioni, notifiche, sessioni\_login e amici.  
* **utenti\_temporanei**: gestisce gli utenti non ancora verificati. Dopo la conferma via mail, i dati vengono trasferiti su utenti.  
* **appunti**: ogni appunto è associato a un utente e a una materia. Può avere revisioni e commenti.  
* **appunti\_condivisi**: permette di condividere appunti con altri utenti, mantenendo la tracciabilità.  
* **storico\_modifiche**: memorizza le versioni precedenti degli appunti, utile per il ripristino o la revisione.  
* **appunti\_tag**: tabella ponte per associare più tag agli appunti, permettendo una ricerca più flessibile.  
* **revisioni**: contiene le revisioni effettuate da revisori su appunti, collegate sia a utenti (revisore) che a appunti.  
* **commenti**: legati a utenti e appunti, permettono di discutere pubblicamente sotto gli appunti, oppure lasciare una valutazione agli appunti.  
* **materie**: contiene l’elenco delle materie disponibili, collegate agli appunti.  
* **tag**: sistema flessibile per associare più tag agli appunti tramite una tabella ponte (es. appunti\_tag).  
* **notifiche**: inviate agli utenti in seguito a revisioni, commenti, richieste amicizia, ecc.  
* **sessioni\_login**: memorizza i token attivi per login persistente e tracciamento.  
* **amici**: sistema base per le relazioni sociali tra utenti (richieste, accettazioni, ecc).

## **Struttura backend PHP (OOP)**

`📁 api/`  
`│`  
`├── 📁 controllers/`  
`│   ├── AuthController.php`  
`│   ├── UtentiController.php`  
`│   ├── AppuntiController.php`  
`│   ├── CommentiController.php`  
`│   ├── RevisioneController.php`  
`│   ├── NotificheController.php`  
`│   ├── MaterieController.php`  
`│   ├── TagController.php`  
`│   ├── SessioniController.php`  
`│`  
`├── 📁 models/`  
`│   ├── Utente.php`  
`│   ├── UtenteTemporaneo.php`  
`│   ├── Amico.php`  
`│   ├── Appunto.php`  
`│   ├── Revisione.php`  
`│   ├── Commento.php`  
`│   ├── Materia.php`  
`│   ├── Tag.php`  
`│   ├── Notifica.php`  
`│   ├── Sessione.php`  
`│`  
`├── 📁 utils/`  
`│   ├── Database.php          ← connessione database`  
`│   ├── Response.php          ← risposte standard`  
`│   ├── Auth.php              ← gestione autenticazione`  
`│   ├── Mailer.php            ← invio email`  
`│`  
`├── 📁 routes/`  
`│   ├── auth.php`  
`│   ├── utenti.php`  
`│   ├── appunti.php`  
`│   ├── commenti.php`  
`│   ├── revisione.php`  
`│   ├── notifiche.php`  
`│   ├── materie.php`  
`│   ├── tag.php`  
`│   ├── sessioni.php`  
`│`  
`├── index.php                 ← entry point unico`  
`│`  
`` ├── .htaccess                  ← (opzionale) per riscrivere tutte le richieste su `index.php` ``

---

## **Come funzionerebbe il flusso**

1. **Flutter** fa una richiesta tipo `POST /api/auth/login`.

2. L'`index.php` intercetta tutto.

3. In base all'URL chiama il file dentro `routes/` corrispondente.

4. `routes/auth.php` istanzia `AuthController` e chiama il metodo corretto.

5. I controller si appoggiano ai `models/` per accedere ai dati.



## Setup applicazione

- Clona il repository da GitHub:  
  `gh repo clone Piovide/Progetto-Flutter`

- Importa eventuali file mancanti nel progetto

- Esegui il comandi per installare le dipendenze escluse tramite `.gitignore`:  
  `flutter pub get`
- Esegui i il comando per importare le librerie per inviare le email:
`composer require symfony/mailer symfony/http-client`
