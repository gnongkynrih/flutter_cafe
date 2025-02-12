import 'dart:async';

import 'package:appwrite/appwrite.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:layout/firebase_options.dart';
import 'package:layout/provider/cafe_provider.dart';
import 'package:layout/screen/NoInternet.dart';
import 'package:layout/screen/category_screen.dart';
import 'package:layout/screen/dashboard_screen.dart';
import 'package:layout/screen/login.dart';
import 'package:layout/screen/occupied_table.dart';
import 'package:layout/screen/registraion.dart';
import 'package:layout/screen/select_category.dart';
import 'package:layout/screen/show_order.dart';
import 'package:layout/screen/table_screen.dart';
import 'package:layout/screen/take_order.dart';
import 'package:provider/provider.dart';

void main() async {
  //initialize firebase
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  bool hasInternet = await checkConnectivity();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  Client client = Client();
  client.setProject('67ac1c09002d41191574');

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => CafeProvider()),
    ],
    child: MyApp(hasInternet: hasInternet),
  ));
}

Future<bool> checkConnectivity() async {
  var connectivityResult = await Connectivity().checkConnectivity();
  return connectivityResult != ConnectivityResult.none;
}

class MyApp extends StatefulWidget {
  MyApp({super.key, required this.hasInternet});
  bool hasInternet;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    startListening();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  void startListening() async {
    _connectivitySubscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      setState(() {
        widget.hasInternet = result != ConnectivityResult.none;
      });
    });
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    if (widget.hasInternet) {
      return MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            useMaterial3: true,
            colorSchemeSeed: const Color.fromARGB(255, 202, 8, 209),
          ),
          home: const DashboardScreen(),
          routes: {
            '/take_order': (context) => const TakeOrderScreen(),
            '/login': (context) => const LoginScreen(),
            '/select_category': (context) => const SelectCategoryScreen(),
            '/registration': (context) => const RegistrationScreen(),
            '/category': (context) => const CategoryScreen(),
            '/add_table': (context) => const TableScreen(),
            '/dashboard': (context) => const DashboardScreen(),
            '/occupied_tables': (context) => const OccupiedTableScreen(),
            '/show_order': (context) => const ShowOrderScreen(),
          });
    } else {
      return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            fontFamily: 'Roboto-Regular',
            primarySwatch: Colors.blue,
          ),
          home: const Scaffold(
            body: Center(
              child: NoInternetScreen(),
            ),
          ));
    }
  }
}
