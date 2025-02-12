import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class NoInternetScreen extends StatelessWidget {
  const NoInternetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FaIcon(
              FontAwesomeIcons.wifi,
              size: 40,
            ),
            SizedBox(
              height: 20,
            ),
            Text('No Internet'),
            SizedBox(
              height: 20,
            ),
            Text(
              'Please check your internet connection',
              style: TextStyle(fontSize: 10),
            )
          ],
        ),
      ),
    );
  }
}
