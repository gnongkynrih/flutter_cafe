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
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _loginFormKey = GlobalKey<FormState>();
  bool isLoading = false;
  @override
  void initState() {
    _emailController.text = 'test@t.com';
    _passwordController.text = 'pppppp';
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
                    controller: _emailController,
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
                  ),
                  TextFormField(
                    controller: _passwordController,
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
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    child: isLoading
                        ? const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: CircularProgressIndicator(
                              color: Colors.greenAccent,
                            ),
                          )
                        : const Text('Login'),
                    onPressed: () async {
                      if (_loginFormKey.currentState!.validate()) {
                        String? response = await loginWithEmailAndPassword();
                        // Navigator.pushReplacementNamed(context, '/category');
                        if (response == null) {
                          // login success
                          Navigator.pushReplacementNamed(context, '/category');
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
      setState(() {
        isLoading = true;
      });
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailController.text, password: _passwordController.text);
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
    } finally {
      setState(() {
        isLoading = false;
      });
    }
    return null;
  }
}
