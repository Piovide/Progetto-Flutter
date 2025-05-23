import 'package:flutter/material.dart';
import 'package:wiki_appunti/constants/colors.dart';
import 'package:wiki_appunti/utilz/Utilz.dart';
import '../utilz/WebUtilz.dart';

class SignInPage extends StatefulWidget {
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final TextEditingController emailUsernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _isObscure = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    getSessionToken().then((token) {
      if (token != null) {
        print("questo é il token dafan: " + token.toString());
        validateToken(token);
      } else {
        print("token nullo");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign In'),
        backgroundColor: teal,
        centerTitle: true,
      ),
      body: Center(
        child: body(),
      ),
    );
  }

  Widget body() => Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            //Email TextFormField
            TextFormField(
              controller: emailUsernameController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(100)),
                label:
                    Text('Email or Username', style: TextStyle(color: black)),
                prefixIcon: Icon(Icons.email),
              ),
            ),

            //SizedBox for spacing
            SizedBox(
              height: 16,
            ),

            //Password TextFormField
            TextFormField(
              controller: passwordController,
              keyboardType: TextInputType.visiblePassword,
              obscureText: _isObscure,
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(100)),
                  label: Text('Password', style: TextStyle(color: black)),
                  prefixIcon: Icon(Icons.lock),
                  suffixIcon: IconButton(
                    icon: Icon(
                        _isObscure ? Icons.visibility_off : Icons.visibility),
                    onPressed: () {
                      _isObscure = !_isObscure;
                      (context as Element).markNeedsBuild();
                    },
                  )),
            ),

            //SizedBox for spacing
            SizedBox(
              height: 16,
            ),

            //Toggle Login Register
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
              ),
              child: TextButton(
                onPressed: () {
                  navigateToPage(context, 'signup', true);
                },
                child: Text(
                  'You don\'t have an account? Register',
                  style: TextStyle(color: teal),
                ),
              ),
            ),

            //SizedBox for spacing
            SizedBox(
              height: 16,
            ),

            //Login Button
            ElevatedButton(
              onPressed: () {
                checkInputsAndLogin();
              },
              style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  backgroundColor: teal),
              child: Text(
                'Sign In',
                style: TextStyle(color: Colors.black),
              ),
            ),

            //SizedBox for spacing
            SizedBox(
              height: 16,
            ),

            //Error Message
            Text(
              getErrorMessage(),
              style: TextStyle(color: Colors.red),
            ),
          ],
        ),
      );
  void validateToken(token) async {
    if (token != null) {
      Map<String, dynamic> dati = {};
      final api = WebUtilz();
      final result = await api.request(
        endpoint: 'AUTH',
        action: 'VALIDATE_TOKEN',
        method: 'POST',
        body: {'token': token},
      );
      if (result['status'] == 200) {
        dati = result['data'];

        saveUserData({
          "username": dati['username'],
          "email": dati['email'],
          "nome": dati['nome'],
          "cognome": dati['cognome'],
          "data_nascita": dati['data_nascita'] ?? '',
          "sesso": dati['sesso'] ?? ''
        });
        navigateToPage(context, 'home', true);
      }
    }
  }

  void checkInputsAndLogin() {
    String emailOrUsername = emailUsernameController.text;
    String password = passwordController.text;
    bool isUsername = false;
    Future<bool> result = Future.value(false);

    if (emailOrUsername.isEmpty || password.isEmpty) {
      setErrorMessage('Please fill in all fields');
    } else {
      setErrorMessage('');
      if (emailOrUsername.contains('@')) {
        if (!RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
                .hasMatch(emailOrUsername) &&
            !isUsername) {
          setErrorMessage('Please enter a valid email address');
          return;
        }
      } else {
        isUsername = true;
      }

      final api = WebUtilz();

      Future<bool> loginUser() async {
        bool success = false;
        Map<String, dynamic> dati = {};
        final result = await api.request(
          endpoint: 'AUTH',
          action: 'LOGIN',
          method: 'POST',
          body: {
            (isUsername ? 'username' : 'email'): emailOrUsername,
            'password': password
          },
        );
        if (result['status'] == 200) {
          success = true;
          dati = result['data'];
          if (dati['uuid'] != null) {
            saveUUID(dati['uuid']);
            String? uuid = await getUUID();
            print("questo é lo uuid: " + uuid.toString());
          }

          if (dati['token'] != null) {
            saveSessionToken(dati['token']);
            String? token = await getSessionToken();
            print("questo é il token: " + token.toString());
          }
          saveUserData({
            "username": dati['username'],
            "email": dati['email'],
            "nome": dati['nome'],
            "cognome": dati['cognome'],
            "data_nascita": dati['data_nascita'] ?? '',
            "sesso": dati['sesso'] ?? ''
          });
        } else {
          success = false;
          if (result['status'] == 401) {
            setErrorMessage("Invalid email or password");
          } else if (result['status'] == 500) {
            setErrorMessage("Server error. Please try again later.");
          } else {
            setErrorMessage(result['message']);
            // setErrorMessage("Login failed. Please try again.");
          }
        }

        return success;
      }

      result = loginUser();

      result.then((value) {
        if (value) {
          // ignore: use_build_context_synchronously
          navigateToPage(context, 'home', true);
        }
      });
    }
  }

  String getErrorMessage() {
    if (errorMessage.isEmpty) return '';
    return errorMessage;
  }

  void setErrorMessage(String message) {
    setState(() {
      errorMessage = message;
    });
  }
}
