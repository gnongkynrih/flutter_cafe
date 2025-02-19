import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MyDrawer extends StatefulWidget {
  const MyDrawer({super.key});

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: ListView(
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.white,
            ),
            child: Text(
              'Menu',
              style: TextStyle(color: Colors.purple),
            ),
          ),
          ListTile(
            title: const Text(
              'Categories',
              style: TextStyle(color: Colors.purple),
            ),
            onTap: () {
              Navigator.pushNamed(context, '/category');
            },
          ),
          ListTile(
            title: const Text(
              'Dashboard',
              style: TextStyle(color: Colors.purple),
            ),
            leading: const Icon(
              Icons.dashboard,
              color: Colors.purple,
            ),
            onTap: () {
              Navigator.pushNamed(context, '/dashboard');
            },
          ),
          ListTile(
            title: const Text(
              'Add Menu',
              style: TextStyle(color: Colors.purple),
            ),
            onTap: () {
              Navigator.pushNamed(context, '/select_category');
            },
          ),
          ListTile(
            leading: const Icon(
              Icons.table_restaurant,
              color: Colors.purple,
            ),
            title: const Text(
              'Add Tables',
              style: TextStyle(color: Colors.purple),
            ),
            onTap: () {
              Navigator.pushNamed(context, '/add_table');
            },
          ),
          ListTile(
            title: const Text(
              'Logout',
              style: TextStyle(color: Colors.purple),
            ),
            leading: const Icon(
              Icons.logout,
              color: Colors.purple,
            ),
            onTap: () {
              //logout
              FirebaseAuth.instance.signOut();
              Navigator.pushNamedAndRemoveUntil(
                  context, '/login', (route) => false);
            },
          ),
        ],
      ),
    );
  }
}
