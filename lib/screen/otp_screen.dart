import 'dart:async';
import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:layout/provider/cafe_provider.dart';
import 'package:pinput/pinput.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class OtpScreen extends StatefulWidget {
  static const String id = 'checkOtp';
  const OtpScreen({super.key});
  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final mobileController = TextEditingController();
  String code = "";
  bool isLoading = false;
  int durationTimeout = 60;
  final oneSecTick = const Duration(seconds: 1);
  Timer? _timer;
  startTimer() {
    _timer = Timer.periodic(oneSecTick, (timer) {
      if (mounted) {
        setState(() {
          durationTimeout--;
        });
      }

      if (durationTimeout <= 0) {
        timer.cancel();
        // Navigator.pop(context);

        // HelperMethods.animatedBar(
        //     context, 'OTP Timeout...', FontAwesomeIcons.circleInfo);

        // Navigator.pushReplacement(NavigationService.navKey.currentContext!,
        //     MaterialPageRoute(builder: (c) => const LoginPage()));
      }
    });
  }

  @override
  void dispose() {
    if (_timer != null) {
      _timer!.cancel();
    }
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: const TextStyle(
          fontSize: 20,
          color: Color.fromRGBO(30, 60, 87, 1),
          fontWeight: FontWeight.w600),
      decoration: BoxDecoration(
        border: Border.all(color: const Color.fromRGBO(234, 239, 243, 1)),
        borderRadius: BorderRadius.circular(20),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(color: const Color.fromRGBO(114, 178, 238, 1)),
      borderRadius: BorderRadius.circular(8),
    );

    // final submittedPinTheme = defaultPinTheme.copyWith(
    //   decoration: defaultPinTheme.decoration?.copyWith(
    //     color: const Color.fromRGBO(234, 239, 243, 1),
    //   ),
    // );

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.purple,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios_rounded,
            color: Colors.white,
          ),
        ),
        elevation: 2,
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              margin: const EdgeInsets.only(left: 25, right: 25),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 25,
                        ),
                        Image.asset('images/dur/otp.png'),
                        Text(
                          "Please enter OTP sent to ${Provider.of<CafeProvider>(context, listen: false).userMobile}",
                          style: const TextStyle(
                            fontSize: 16,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        Pinput(
                          length: 6,
                          focusedPinTheme: focusedPinTheme,
                          onChanged: (value) {
                            setState(() {
                              code = value;
                            });
                          },
                          showCursor: true,
                          // androidSmsAutofillMethod:
                          //     AndroidSmsAutofillMethod.smsRetrieverApi,
                          // onCompleted: (pin) => _verifyOTP(pin)
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text('0:$durationTimeout'),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            isLoading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : TextButton(
                    onPressed: () async {
                      _verifyOTP();
                    },
                    child: const Text('Submit'))
          ],
        ),
      ),
    );
  }

  _verifyOTP() async {
    if (code == '') {
      // HelperMethods.animatedBar(
      //     context, 'Please enter OTP', FontAwesomeIcons.circleInfo);
      return;
    }

    setState(() {
      isLoading = true;
    });
    FirebaseAuth fAuth = FirebaseAuth.instance;
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId:
              Provider.of<CafeProvider>(context, listen: false).getOtpCode(),
          smsCode: code);
      fAuth.signInWithCredential(credential).then((value) async {
        AnimatedSnackBar.material(
          'Login successful',
          duration: const Duration(seconds: 6),
          type: AnimatedSnackBarType.success,
        ).show(context);
      }).onError((error, stackTrace) {
        setState(() {
          isLoading = false;
        });
        if (error.toString().contains('invalid-verification-code')) {
          // HelperMethods.animatedBar(context, 'The entered OTP is incorrect.',
          //     FontAwesomeIcons.circleInfo);
          return;
        } else if (error.toString().contains('too-many-requests')) {
          // HelperMethods.animatedBar(
          //     context,
          //     'Too many attempts. Please try again later.',
          //     FontAwesomeIcons.circleInfo);
          return;
        }
        // HelperMethods.animatedBar(
        //     context,
        //     'Too many attempts. Please try again later.',
        //     FontAwesomeIcons.circleInfo);
        // Navigator.pushReplacement(NavigationService.navKey.currentContext!,
        //     MaterialPageRoute(builder: (c) => const LoginPage()));
        return;
      });
    } catch (e, stackTrace) {}
  }
}
