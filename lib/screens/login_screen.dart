import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
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
              fontSize: 35,
            ),
          ),
          const SizedBox(
            height: 70,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 50, right: 50),
            child: MaterialButton(
              color: const Color.fromARGB(255, 255, 255, 255),
              elevation: 10,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    height: 40.0,
                    width: 40.0,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                          image: NetworkImage(
                              'https://cdn-icons-png.flaticon.com/512/2991/2991148.png'),
                          fit: BoxFit.cover),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(
                    width: 40,
                  ),
                  Text(
                    "Sign In with Google",
                    style: TextStyle(
                      color: Colors.indigo[900],
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
              onPressed: () async {},
            ),
          ),
        ],
      ),
    );
  }
}
