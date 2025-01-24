import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:layout/firebase_options.dart';
import 'package:layout/screen/add_menu.dart';
import 'package:layout/screen/category_screen.dart';
import 'package:layout/screen/login.dart';
import 'package:layout/screen/registraion.dart';
import 'package:layout/screen/select_category.dart';

void main() async {
  //initialize firebase
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  //check if user is logged in
  // if (FirebaseAuth.instance.currentUser != null) {

  // } else {
  //   runApp(const LoginScreen());
  // }

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
          useMaterial3: true,
          colorSchemeSeed: const Color.fromARGB(255, 202, 8, 209),
        ),
        home: const CategoryScreen(),
        routes: {
          '/login': (context) => const LoginScreen(),
          '/select_category': (context) => const SelectCategoryScreen(),
          '/registration': (context) => const RegistrationScreen(),
          '/category': (context) => const CategoryScreen(),
        });
  }
}
