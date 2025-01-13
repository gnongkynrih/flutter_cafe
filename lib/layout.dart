import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LayoutScreen extends StatelessWidget {
  const LayoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text(
            'Cafe',
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          backgroundColor: Colors.brown),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: Column(
            children: [
              Image.asset('images/code.png'),
              const Align(
                  alignment: AlignmentDirectional.topStart,
                  child: Text(
                    'Lion King - Mufasa',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  )),
              const Row(
                children: [
                  Expanded(
                    child: Text(
                      'Date: 10/01/2025',
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ),
                  FaIcon(FontAwesomeIcons.solidHeart, color: Colors.red),
                ],
              ),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      FaIcon(
                        FontAwesomeIcons.floppyDisk,
                        size: 40,
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text('Save'),
                    ],
                  ),
                  Column(
                    children: [
                      FaIcon(FontAwesomeIcons.shareNodes, size: 40),
                      SizedBox(
                        height: 5,
                      ),
                      Text('Share'),
                    ],
                  ),
                  Column(
                    children: [
                      FaIcon(FontAwesomeIcons.paperPlane, size: 40),
                      SizedBox(
                        height: 5,
                      ),
                      Text('Send'),
                    ],
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
