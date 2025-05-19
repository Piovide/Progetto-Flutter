import 'package:flutter/material.dart';
import 'package:progetto_flutter/constants/colors.dart';
import 'package:progetto_flutter/utilz/Utilz.dart';
import '../utilz/WebUtilz.dart';

// TODO: *PER CEO* style the text fields like the profile page

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
            //Email TextField
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
              ),
              child: TextField(
                controller: emailUsernameController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.email),
                  border: OutlineInputBorder(),
                  hintText: 'Email or Username',
                ),
              ),
            ),

            //SizedBox for spacing
            SizedBox(
              height: 16,
            ),

            //Password TextField
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
              ),
              child: TextField(
                controller: passwordController,
                keyboardType: TextInputType.visiblePassword,
                obscureText: _isObscure,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.lock),
                  suffixIcon: IconButton(
                    icon: Icon(
                        _isObscure ? Icons.visibility_off : Icons.visibility),
                    onPressed: () {
                      _isObscure = !_isObscure;
                      (context as Element).markNeedsBuild();
                    },
                  ),
                  border: OutlineInputBorder(),
                  hintText: 'Password',
                ),
              ),
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
        saveSessionToken('dffdsgfddsfsafdfasdfdsf');
        String? token = await getSessionToken();

        final result = await api.request(
          endpoint: 'AUTH',
          action: 'LOGIN',
          method: 'POST',
          body: {
            (isUsername ? 'username' : 'email'): emailOrUsername,
            'password': password,
            if (token != null) 'token': token,
          },
        );
        if (result['status'] == 200) {
          success = true;
          // if (result['UUID'] != null) {
          //   saveUUID(result['UUID']);
          // }
          dati = result['data'];
          // TODO: Delete this when sql is implemented
          if (dati['username'] != null) {
            saveUUID(dati['username']);
            String? username = await getUUID();
            print("questo é lo username: " + username.toString());
          }

          if (dati['token'] != null) {
            saveSessionToken(dati['token']);
            token = await getSessionToken();
            print("questo é il token: " + token.toString());
          }
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
