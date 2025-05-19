import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../utilz/Utilz.dart';

class ProfilePageFormWidget extends StatefulWidget {
  @override
  _EnableFormState createState() => _EnableFormState();
}

class _EnableFormState extends State<ProfilePageFormWidget> {
  bool setEnabled = false;
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {

    return FutureBuilder(
      future: getUserData(),
      builder: (context, snapshot) {
        // final userData = snapshot.data!;
        // final nome = userData['nome'] as String;
        // final cognome = userData['cognome'] as String;
        // final dataNascita = userData['dataNascita'] as String;
        // final sesso = userData['sesso'] as String;
        // final password = userData['password'] as String;

        // print(userData);

        return Form(
          child: Column(
            children: [
              TextFormField(
                controller: _controller,
                enabled: setEnabled,
                // enableInteractiveSelection: false,
                focusNode: FocusNode(),
                decoration: InputDecoration(
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(100)),
                  disabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(100),
                    borderSide: BorderSide(color: black),
                  ),
                  label: Text("nome", style: TextStyle(color: black)),
                  prefixIcon: Icon(Icons.person, color: black),
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _controller,
                enabled: setEnabled,
                focusNode: FocusNode(),
                decoration: InputDecoration(
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(100)),
                  disabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(100),
                    borderSide: BorderSide(color: black),
                  ),
                  label: Text("cognome", style: TextStyle(color: black)),
                  prefixIcon: Icon(Icons.email_outlined, color: black),
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _controller,
                enabled: setEnabled,
                focusNode: FocusNode(),
                decoration: InputDecoration(
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(100)),
                  disabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(100),
                    borderSide: BorderSide(color: black),
                  ),
                  label: Text("dataNascita", style: TextStyle(color: black)),
                  prefixIcon: Icon(Icons.date_range_rounded, color: black),
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _controller,
                enabled: setEnabled,
                focusNode: FocusNode(),
                decoration: InputDecoration(
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(100)),
                  disabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(100),
                    borderSide: BorderSide(color: black),
                  ),
                  label: Text("sesso", style: TextStyle(color: black)),
                  prefixIcon: Icon(Icons.male_rounded, color: black),
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _controller,
                enabled: setEnabled,
                focusNode: FocusNode(),
                decoration: InputDecoration(
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(100)),
                  disabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(100),
                    borderSide: BorderSide(color: black),
                  ),
                  label: Text("Password", style: TextStyle(color: black)),
                  prefixIcon: Icon(Icons.lock_outline_rounded, color: black),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: 200,
                child: ElevatedButton(
                  onPressed: (){
                    setState(() {
                      setEnabled = !setEnabled;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: teal,
                    side: BorderSide.none,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                  child: Text("Modifica profilo", style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),
        );
      }
    );
  }
}