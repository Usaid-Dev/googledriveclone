import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:googledriveclone/screens/home_screen.dart';
import 'package:googledriveclone/services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
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
                          height: 50.0,
                          width: 50.0,
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
                    onPressed: () async {
                      UserCredential? userCredential =
                          await _authService.signInWithGoogle();
                      if (userCredential != null) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => HomeScreen(
                              url: userCredential.user?.photoURL ??
                                  '', // Ensure you pass valid data
                            ),
                          ),
                        );
                      } else {
                        // Handle sign-in failure
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content:
                                  Text('Sign-In failed. Please try again.')),
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(bottom: 50),
            child: Column(
              children: [
                Text(
                  'Made By',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                  ),
                ),
                Text(
                  'Usaid Asif',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 35,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
