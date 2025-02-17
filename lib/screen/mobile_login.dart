import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:layout/provider/cafe_provider.dart';
import 'package:provider/provider.dart';

class MobileLogin extends StatefulWidget {
  const MobileLogin({super.key});

  @override
  State<MobileLogin> createState() => _MobileLoginState();
}

class _MobileLoginState extends State<MobileLogin> {
  final TextEditingController mobileNo = TextEditingController();
  final GlobalKey<FormState> _loginFormKey = GlobalKey<FormState>();
  bool isLoading = false;
  @override
  void initState() {
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
                  Row(
                    children: [
                      Container(
                        color: Colors.grey.shade300,
                        width: 30,
                        child: const Text('+91'),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextFormField(
                          controller: mobileNo,
                          autocorrect: false,
                          enableSuggestions: false,
                          keyboardType: TextInputType.phone,
                          decoration: const InputDecoration(
                            labelText: 'Mobile Number',
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your mobile number';
                            }
                            if (value.length != 10) {
                              return 'Please enter a valid mobile number';
                            }
                            return null;
                          },
                        ),
                      )
                    ],
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
                        : const Text('Continue'),
                    onPressed: () async {
                      if (_loginFormKey.currentState!.validate()) {
                        sendOTP();
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

  sendOTP() async {
    setState(() {
      isLoading = true;
    });
    try {
      mobileNo.text = '+91${mobileNo.text}';
      Provider.of<CafeProvider>(context, listen: false)
          .setMobileNo(mobileNo.text);
      await FirebaseAuth.instance.verifyPhoneNumber(
          phoneNumber: mobileNo.text,
          timeout: const Duration(seconds: 5),
          verificationCompleted: (authCredential) {},
          verificationFailed: (authException) {
            AnimatedSnackBar.material(
              authException.message.toString(),
              duration: const Duration(seconds: 6),
              type: AnimatedSnackBarType.error,
            ).show(context);
            if (mounted) {
              setState(() {
                isLoading = false;
              });
            }
          },
          codeAutoRetrievalTimeout: (verificationId) {
            if (mounted) {
              setState(() {
                isLoading = false;
              });
            }
          },
          // called when the SMS code is sent
          codeSent: (String verificationId, int? resendToken) {
            Provider.of<CafeProvider>(context, listen: false)
                .setOtpCode(verificationId.toString());
            Navigator.pop(context);
            Navigator.pushNamed(context, '/otp');
          });
    } catch (e, stackTrace) {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }
}
