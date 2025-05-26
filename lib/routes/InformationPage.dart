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
      body: const Center(
        child: Text('This is the Information Page'),
      ),
    );
  }
}