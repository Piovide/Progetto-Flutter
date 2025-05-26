import 'package:flutter/material.dart';
import 'package:wiki_appunti/component/HeaderComp.dart';

/// Pagina informativa dell'applicazione.
/// 
/// Mostra una descrizione di WikiAppunti, gli autori, le tecnologie usate
/// e gli obiettivi principali del progetto.
class InformationPage extends StatelessWidget {
  const InformationPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HeaderComp(context, false),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: ListView(
          children: const [
            Center(
              child: Text(
                'Informazioni sull\'applicazione:',
                style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 40),
            Text(
              'WikiAppunti è una piattaforma pensata per facilitare la condivisione di appunti scolastici tra studenti e insegnanti. '
              'L\'obiettivo principale è creare un punto di riferimento unico dove è possibile trovare e caricare materiale utile per lo studio, '
              'suddiviso per materie, argomenti e livelli scolastici.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),

            Text(
              'Chi siamo:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              '- Ceolin Giovanni\n'
              '- Furlan Marco\n'
              '- Piovesan Davide',
              style: TextStyle(fontSize: 16),
            ),  
            SizedBox(height: 10),
            Text(
              'Siamo tre studenti di informatica che hanno realizzato questo progetto per migliorare la collaborazione e la comunicazione nella scuola.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),

            Text(
              'Tecnologie utilizzate:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              '- Flutter: per lo sviluppo dell\'interfaccia utente.\n'
              '- PHP: per la logica lato server.\n'
              '- MySQL: per la gestione e archiviazione dei dati.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),

            Text(
              'Obiettivi principali:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              '- Fornire uno spazio comune per studenti e docenti.\n'
              '- Supportare una vasta gamma di materie scolastiche.\n'
              '- Offrire un\'interfaccia semplice, accessibile e intuitiva.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),

            Text(
              'Una wiki per la scuola:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'SchoolNotes Wiki è più di una semplice raccolta di file: è una vera e propria wiki scolastica, collaborativa e in continua evoluzione, '
              'che punta a diventare uno strumento indispensabile per la vita scolastica quotidiana.',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}