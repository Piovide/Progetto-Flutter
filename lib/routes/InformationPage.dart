import 'package:flutter/material.dart';
import 'package:wiki_appunti/component/HeaderComp.dart';

class InformationPage extends StatelessWidget {
  const InformationPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HeaderComp(context, false),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          children: [
            Center(
              child: Text(
                'Informazioni',
                style: Theme.of(context).textTheme.headlineLarge,
              ),
            ),
            const SizedBox(height: 80),
            Text(
              'Questa è una pagina informativa.',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        )
      ),
    );
  }
}