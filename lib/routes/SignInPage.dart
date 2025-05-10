import 'package:flutter/material.dart';
import '../main.dart';
import '../utilz/WebUtilz.dart';

class SignInPage extends StatefulWidget {
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _isObscure = true;
  String errorMessage = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign In'),
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
                  style: TextStyle(color: Colors.blue),
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
                  backgroundColor: Colors.blue),
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
    String email = emailController.text;
    String password = passwordController.text;
    bool success = false;
    if (email.isEmpty || password.isEmpty) {
      setErrorMessage('Please fill in all fields');
    } else {
      setErrorMessage('');
      final api = WebUtilz();

      void loginUser() async {
        final result = await api.request(
          endpoint: 'LOGIN',
          method: 'POST',
          body: {
            'email': email,
            'password': password,
          },
        );
        if (result['status'] == 200) {
          success = true;
        } else {
          success = false;
          if (result['status'] == 401) {
            setErrorMessage("Invalid email or password");
          } else if (result['status'] == 500) {
            setErrorMessage("Server error. Please try again later.");
          } else {
            setErrorMessage("Login failed. Please try again.");
          }
          setErrorMessage(result['message']);
        }
        if (success) {
          // ignore: use_build_context_synchronously
          navigateToPage(context, 'home', true);
        }
      }

      loginUser();
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
