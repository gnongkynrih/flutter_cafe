import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:layout/firebase_options.dart';
import 'package:layout/screen/login.dart';
import 'package:layout/screen/registraion.dart';

void main() async {
  //initialize firebase
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const LoginScreen(),
        routes: {
          '/login': (context) => const LoginScreen(),
          '/registration': (context) => const RegistrationScreen(),
        });
  }
}
