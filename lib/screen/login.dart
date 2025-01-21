import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String? _email;
  String? _password;
  final GlobalKey<FormState> _loginFormKey = GlobalKey<FormState>();

  @override
  void initState() {
    _email = 'test@t.com';
    _password = 'pppppp';
    print('this is the init state');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Login',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.purple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Form(
              key: _loginFormKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextFormField(
                    initialValue: _email,
                    autocorrect: false,
                    enableSuggestions: false,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      _email = value;
                    },
                  ),
                  TextFormField(
                    initialValue: _password,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'Password',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      _password = value;
                    },
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    child: const Text('Login'),
                    onPressed: () async {
                      if (_loginFormKey.currentState!.validate()) {
                        String? response = await loginWithEmailAndPassword();
                        // Navigator.pushReplacementNamed(context, '/category');
                        if (response == null) {
                          // login success
                          Navigator.pushNamed(context, '/category');
                        } else {
                          AnimatedSnackBar.material(
                            mobileSnackBarPosition:
                                MobileSnackBarPosition.bottom,
                            response.toString(),
                            type: AnimatedSnackBarType.warning,
                          ).show(context);
                        }
                      }
                    },
                  ),
                  TextButton(
                    child: const Text('Don\'t have an account? Register'),
                    onPressed: () {
                      // Navigate to registration screen
                      Navigator.pushNamed(context, '/registration');
                    },
                  ),
                ],
              )),
        ),
      ),
    );
  }

  Future<String?> loginWithEmailAndPassword() async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: _email!, password: _password!);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return ' User does not exist.';
      } else if (e.code == 'wrong-password') {
        return 'Invalid credentials.';
      } else {
        return e.message;
      }
    } catch (e) {
      return 'unexpected error. Please try again.';
    }
    return null;
  }
}
