import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../screens/login_screen.dart';

class CustomDrawer extends StatelessWidget {
  final User? user;
  final GoogleSignIn googleSignIn;

  const CustomDrawer({
    super.key,
    this.user,
    required this.googleSignIn,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        padding: const EdgeInsets.only(top: 60),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage(user?.photoURL ?? ''),
            ),
            const SizedBox(height: 16),
            const Divider(),
            Text(
              'Name: ${user?.displayName ?? 'No Name'}',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 8),
            Text(
              'Email: ${user?.email ?? 'No Email'}',
              style: const TextStyle(fontSize: 18),
            ),
            const Divider(),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                await googleSignIn.signOut();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LoginScreen(),
                  ),
                );
              },
              child: const Text('Sign Out'),
            ),
          ],
        ),
      ),
    );
  }
}
