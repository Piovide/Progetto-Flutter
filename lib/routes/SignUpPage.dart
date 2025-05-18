import 'package:flutter/material.dart';
import 'package:progetto_flutter/utilz/Utilz.dart';
import '../utilz/WebUtilz.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController surnameController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController repeatPasswordController =
      TextEditingController();
  String errorMessage = '';
  Color errorColor = Colors.red;
  bool _isObscure = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Up'),
        backgroundColor: Colors.blue,
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
            //Username TextField
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
              ),
              child: TextField(
                controller: usernameController,
                keyboardType: TextInputType.name,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.person),
                  border: OutlineInputBorder(),
                  hintText: 'Username',
                ),
              ),
            ),

            //SizedBox for spacing
            SizedBox(
              height: 16,
            ),

            //Surname TextField
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
              ),
              child: TextField(
                controller: surnameController,
                keyboardType: TextInputType.name,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.badge),
                  border: OutlineInputBorder(),
                  hintText: 'Surname',
                ),
              ),
            ),

            //SizedBox for spacing
            SizedBox(
              height: 16,
            ),

            //Name TextField
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
              ),
              child: TextField(
                controller: nameController,
                keyboardType: TextInputType.name,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.badge),
                  border: OutlineInputBorder(),
                  hintText: 'Name',
                ),
              ),
            ),

            //SizedBox for spacing
            SizedBox(
              height: 16,
            ),

            //Email TextField
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
              ),
              child: TextField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.email),
                  border: OutlineInputBorder(),
                  hintText: 'Email',
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

            //Repeat Password TextField
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
              ),
              child: TextField(
                controller: repeatPasswordController,
                keyboardType: TextInputType.visiblePassword,
                onChanged: (value) {
                  checkPasswordInput(value);
                },
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
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                        color:
                            checkPasswordInput(repeatPasswordController.text)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color:
                            checkPasswordInput(repeatPasswordController.text)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color:
                            checkPasswordInput(repeatPasswordController.text)),
                  ),
                  hintText: 'Repeat Password',
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
                  navigateToPage(context, 'signin', true);
                },
                child: Text(
                  'Already have an account? Sign In',
                  style: TextStyle(color: Colors.blue),
                ),
              ),
            ),

            //SizedBox for spacing
            SizedBox(
              height: 16,
            ),

            //SignUp Button
            ElevatedButton(
              onPressed: () {
                checkInputsAndLogin();
              },
              style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  backgroundColor: Colors.blue),
              child: Text(
                'Sign Up',
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
              style: TextStyle(
                color: errorColor,
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );

  Color checkPasswordInput(value) {
    String password = passwordController.text;
    String repeatPassword = value;
    Color borderColor = Colors.grey;
    setState(() {
      if (!value.isEmpty) {
        if (password == repeatPassword) {
          borderColor = Colors.green;
        } else {
          borderColor = Colors.red;
        }
      }
    });

    return borderColor;
  }

  void checkInputsAndLogin() {
    String username = usernameController.text;
    String surname = surnameController.text;
    String name = nameController.text;
    String email = emailController.text;
    String password = passwordController.text;
    String repeatPassword = repeatPasswordController.text;
    bool success = false;

    if (surname.isEmpty ||
        name.isEmpty ||
        surname.isEmpty ||
        email.isEmpty ||
        password.isEmpty ||
        repeatPassword.isEmpty) {
      setErrorMessage('Please fill in all fields');
    } else if (password != repeatPassword) {
      setErrorMessage('Passwords do not match');
    } else if (password.length < 6) {
      setErrorMessage('Password must be at least 6 characters long');
      return;
    } else {
      setErrorMessage('');
      final api = WebUtilz();

      Future<bool> registerUser() async {
        final result = await api.request(
          endpoint: 'AUTH',
          action: 'REGISTER',
          method: 'POST',
          body: {
            'username': username,
            'name': name,
            'surname': surname,
            'email': email,
            'password': password,
          },
        );
        if (result['status'] == 200) {
          success = true;
        } else {
          success = false;
          if (result['status'] == 500) {
            setErrorMessage("Server error. Please try again later.");
          } else {
            setErrorMessage("Login failed. Please try again.");
          }
          setErrorMessage(result['message']);
        }
        if (success) {
          setErrorMessage('Registration successful. Please check your email.',
              color: Colors.green);
          //wait 2 seconds and print another message for spam email
          await Future.delayed(Duration(seconds: 5));
          setErrorMessage(
              'Registration successful. Please check your email.\nIf you do not receive an email, please check your spam folder.',
              color: Colors.green);
        }
        return success;
      }

      registerUser();
    }
  }

  String getErrorMessage() {
    if (errorMessage.isEmpty) return '';
    return errorMessage;
  }

  void setErrorMessage(String message, {Color color = Colors.red}) {
    setState(() {
      errorMessage = message;
      errorColor = color;
    });
  }
}
