import 'package:flutter/material.dart';
import '../main.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController surnameController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController repeatPasswordController = TextEditingController();
  String errorMessage = '';
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
            //Surname TextField
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
              ),
              child: TextField(
                controller: surnameController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.email),
                  border: OutlineInputBorder(),
                  hintText: 'Surname',
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
                controller: nameController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.email),
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
                  'You don\'t have an account? Register',
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
              style: TextStyle(color: Colors.red),
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
    String surname = surnameController.text;
    String name = nameController.text;
    String email = emailController.text;
    String password = passwordController.text;
    String repeatPassword = repeatPasswordController.text;
    if (surname.isEmpty ||
        name.isEmpty ||
        email.isEmpty ||
        password.isEmpty ||
        repeatPassword.isEmpty) {
      setErrorMessage('Please fill in all fields');
    } else if (password != repeatPassword) {
      setErrorMessage('Passwords do not match');
    } else {
      if (password.length < 6) {
        setErrorMessage('Password must be at least 6 characters long');
        return;
      }

      // Navigate to the home page
      navigateToPage(context, 'home', true);
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
