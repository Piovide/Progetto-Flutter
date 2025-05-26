import 'package:flutter/material.dart';
import '../constants/colors.dart';
import 'package:wiki_appunti/utilz/WebUtilz.dart';
import '../utilz/Utilz.dart';

/// Un widget che mostra un modulo per visualizzare e modificare i dati del profilo utente.
/// Permette di modificare nome, cognome, data di nascita, genere e password.
/// Mostra i dati correnti dell'utente e consente di aggiornarli tramite un pulsante.
/// Include la conferma della nuova password e controlli di validazione base.
class ProfilePageFormWidget extends StatefulWidget {
  @override
  _EnableFormState createState() => _EnableFormState();
}

class _EnableFormState extends State<ProfilePageFormWidget> {
  bool setEnabled = false;
  bool showSaveButton = false;
  bool showPasswordConfirmation = false;
  bool _isInitialized = false;
  bool _isObscure = true;
  bool _isObscureNew = true;
  bool _isObscureConfirm = true;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _surnameController = TextEditingController();
  final TextEditingController _dateOfBirthController = TextEditingController();
  final TextEditingController _genreController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

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

          // _nameController.text = name;
          // _surnameController.text = surname;
          // _genreController.text = genre;
          // _dateOfBirthController.text = dateOfBirth;

          if (!_isInitialized) {
            _nameController.text = name;
            _surnameController.text = surname;
            _genreController.text = genre;
            _dateOfBirthController.text = dateOfBirth;
            _isInitialized = true;
          }
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
                TextField(
                  controller: _dateOfBirthController,
                  enabled: setEnabled,
                  readOnly: true,
                  onTap: () async {
                    if (setEnabled) {
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(1900),
                        lastDate: DateTime.now(),
                      );
                      if (pickedDate != null) {
                        setState(() {
                          _dateOfBirthController.text =
                              "${pickedDate.year}-${pickedDate.month}-${pickedDate.day}";
                        });
                      }
                    }
                  },
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
                  keyboardType: TextInputType.visiblePassword,
                  obscureText: _isObscure,
                  enabled: setEnabled,
                  focusNode: FocusNode(),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(100)),
                    disabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(100),
                      borderSide: BorderSide(color: black),
                    ),
                    label: Text("Old password", style: TextStyle(color: black)),
                    prefixIcon: Icon(Icons.lock_outline_rounded, color: black),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isObscure ? Icons.visibility_off : Icons.visibility,
                      ),
                      onPressed: () {
                        setState(() {
                          _isObscure = !_isObscure;
                        });
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                if (showPasswordConfirmation)
                  Column(
                    children: [
                      TextFormField(
                        controller: _newPasswordController,
                        keyboardType: TextInputType.visiblePassword,
                        obscureText: _isObscure,
                        enabled: setEnabled,
                        focusNode: FocusNode(),
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(100)),
                          disabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(100),
                            borderSide: BorderSide(color: black),
                          ),
                          label: Text("New Password",
                              style: TextStyle(color: black)),
                          prefixIcon:
                              Icon(Icons.lock_outline_rounded, color: black),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _isObscureNew
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                            ),
                            onPressed: () {
                              setState(() {
                                _isObscureNew = !_isObscureNew;
                              });
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _confirmPasswordController,
                        keyboardType: TextInputType.visiblePassword,
                        obscureText: _isObscureConfirm,
                        focusNode: FocusNode(),
                        enabled: setEnabled,
                        onChanged: (value) {
                          setState(() {
                            checkPasswordInput(value);
                          });
                        },
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(100),
                            borderSide: BorderSide(
                              color: checkPasswordInput(
                                  _confirmPasswordController.text),
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(100),
                            borderSide: BorderSide(
                              color: checkPasswordInput(
                                  _confirmPasswordController.text),
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(100),
                            borderSide: BorderSide(
                              color: checkPasswordInput(
                                  _confirmPasswordController.text),
                            ),
                          ),
                          label: Text('Repeat Password',
                              style: TextStyle(color: black)),
                          prefixIcon:
                              Icon(Icons.lock_outline_rounded, color: black),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _isObscureConfirm
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                            ),
                            onPressed: () {
                              setState(() {
                                _isObscureConfirm = !_isObscureConfirm;
                              });
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                showSaveButton
                    ? SizedBox(
                        width: 200,
                        child: ElevatedButton(
                          onPressed: () {
                            checkInputsAndChange();
                            setState(() {
                              showSaveButton = !showSaveButton;
                              setEnabled = !setEnabled;
                              showPasswordConfirmation =
                                  !showPasswordConfirmation;
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
                              showPasswordConfirmation =
                                  !showPasswordConfirmation;
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

  Color checkPasswordInput(value) {
    String password = _newPasswordController.text;
    String repeatPassword = value;
    Color borderColor = Colors.grey;
    if (value.toString().isNotEmpty) {
      if (password == repeatPassword) {
        borderColor = Colors.green;
      } else {
        borderColor = Colors.red;
      }
    }
    return borderColor;
  }

  Future<void> checkInputsAndChange() async {
    String name = _nameController.text;
    String surname = _surnameController.text;
    String dateOfBirth = _dateOfBirthController.text;
    String genre = _genreController.text;
    String password = _passwordController.text;
    String newPassword = _newPasswordController.text;
    String confirmPassword = _confirmPasswordController.text;

    if (name.isNotEmpty ||
        surname.isNotEmpty ||
        dateOfBirth.isNotEmpty ||
        genre.isNotEmpty ||
        (password.isNotEmpty &&
            newPassword.isNotEmpty &&
            confirmPassword.isNotEmpty)) {
      if (newPassword == _confirmPasswordController.text ||
          newPassword.isEmpty) {
        if (newPassword != password || password.isEmpty) {
          final api = WebUtilz();
          String? uuid = await getUUID();
          final result = await api.request(
            endpoint: 'AUTH',
            action: 'UPDATE',
            method: 'POST',
            body: {
              'uuid': uuid,
              'nome': name != '' ? name : null,
              'cognome': surname != '' ? surname : null,
              'data_nascita': dateOfBirth != '' ? dateOfBirth : null,
              'sesso': genre != 'Seleziona il tuo genere' ? genre : null,
              'password': password != '' ? password : null,
              'new_password': newPassword != '' ? newPassword : null,
            },
          );
          if (result['status'] == 200) {
            if (mounted) {
              Navigator.of(context).pop();
              showSnackBar(
                context,
                "Profilo aggiornato con successo",
                2,
              );
            }
            refreshUserData();
            saveUserData({
              'nome': name,
              'cognome': surname,
              'data_nascita': dateOfBirth,
              'sesso': genre,
            });
          }
        } else {
          showSnackBar(
            context,
            "La nuova password non può essere uguale alla vecchia",
            2,
            backgroundColor: Colors.blueGrey,
          );
        }
      } else {
        showSnackBar(
          context,
          "Le password non corrispondono",
          2,
          backgroundColor: Colors.blueGrey,
        );
      }
    } else {
      showSnackBar(
        context,
        "Riempire almeno un campo per procedere",
        2,
        backgroundColor: Colors.blueGrey,
      );
    }
  }
}
