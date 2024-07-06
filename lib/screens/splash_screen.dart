import 'dart:async';

import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  // @override
  // void initState() {
  //   Timer(const Duration(seconds: 3), () {
  //     Navigator.push(
  //       context,
  //       MaterialPageRoute(
  //         builder: (context) => LoginScreen(),
  //       ),
  //     );
  //   });
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Image.asset('images/gdrive.png'),
          ),
          const Text(
            'Google Drive Clone',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic,
                fontSize: 35),
          )
        ],
      ),
    );
  }
}
