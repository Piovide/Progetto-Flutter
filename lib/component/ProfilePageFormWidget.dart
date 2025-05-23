import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../utilz/Utilz.dart';

// TODO: modify the form to make a double check on the password (check with if-else statements)

class ProfilePageFormWidget extends StatefulWidget {
  @override
  _EnableFormState createState() => _EnableFormState();
}

class _EnableFormState extends State<ProfilePageFormWidget> {
  bool setEnabled = false;
  bool showSaveButton = false;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _surnameController = TextEditingController();
  final TextEditingController _dateOfBirthController = TextEditingController();
  final TextEditingController _genreController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getUserData(),
        builder: (context, snapshot) {
          final userData = snapshot.data;
          if (userData == null) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          final name = userData['nome'] as String? ?? '';
          final surname = userData['cognome'] as String? ?? '';
          final dateOfBirth = userData['data_nascita'] != null
              ? userData['data_nascita'] as String
              : '';
          final genre = userData['sesso'] != null
              ? userData['sesso'] as String
              : 'Seleziona il tuo genere';

          final List<String> genderItems = ['maschio', 'femmina', 'altro'];
          _nameController.text = name;
          _surnameController.text = surname;
          _dateOfBirthController.text = dateOfBirth;
          _genreController.text = genre;

          return Form(
            child: Column(
              children: [
                TextFormField(
                  controller: _nameController,
                  enabled: setEnabled,
                  // enableInteractiveSelection: false,
                  focusNode: FocusNode(),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(100)),
                    disabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(100),
                      borderSide: BorderSide(color: black),
                    ),
                    label: Text("Name", style: TextStyle(color: black)),
                    prefixIcon: Icon(Icons.person, color: black),
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _surnameController,
                  enabled: setEnabled,
                  focusNode: FocusNode(),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(100)),
                    disabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(100),
                      borderSide: BorderSide(color: black),
                    ),
                    label: Text("Surname", style: TextStyle(color: black)),
                    prefixIcon: Icon(Icons.email_outlined, color: black),
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _dateOfBirthController,
                  enabled: setEnabled,
                  focusNode: FocusNode(),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(100)),
                    disabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(100),
                      borderSide: BorderSide(color: black),
                    ),
                    label:
                        Text("Date of birth", style: TextStyle(color: black)),
                    prefixIcon: Icon(Icons.date_range_rounded, color: black),
                  ),
                ),
                const SizedBox(height: 20),
                DropdownButtonFormField<String>(
                  value: _genreController.text.isNotEmpty
                      ? _genreController.text
                      : null,
                  items: genderItems
                      .map((String value) => DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          ))
                      .toList(),
                  onChanged: setEnabled
                      ? (String? newValue) {
                          setState(() {
                            _genreController.text = newValue ?? '';
                          });
                        }
                      : null,
                  decoration: InputDecoration(
                    enabled: setEnabled,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(100)),
                    disabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(100),
                      borderSide: BorderSide(color: black),
                    ),
                    label: Text("Genre", style: TextStyle(color: black)),
                    prefixIcon: Icon(Icons.male_rounded, color: black),
                  ),
                  dropdownColor: Colors.white,
                  isExpanded: true,
                  menuMaxHeight: 200,
                  alignment: AlignmentDirectional
                      .topStart, // Ensures menu appears below
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _passwordController,
                  enabled: setEnabled,
                  focusNode: FocusNode(),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(100)),
                    disabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(100),
                      borderSide: BorderSide(color: black),
                    ),
                    label: Text("Password", style: TextStyle(color: black)),
                    prefixIcon: Icon(Icons.lock_outline_rounded, color: black),
                  ),
                ),
                const SizedBox(height: 20),
                showSaveButton
                    ? SizedBox(
                        width: 200,
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              showSaveButton = !showSaveButton;
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
                          child: Text("Salva",
                              style: TextStyle(color: Colors.white)),
                        ),
                      )
                    : SizedBox(
                        width: 200,
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              setEnabled = !setEnabled;
                              showSaveButton = !showSaveButton;
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: teal,
                            side: BorderSide.none,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                          ),
                          child: Text("Modifica profilo",
                              style: TextStyle(color: Colors.white)),
                        ),
                      ),
              ],
            ),
          );
        });
  }
}
