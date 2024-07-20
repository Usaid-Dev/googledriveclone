import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:googledriveclone/screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
        apiKey: 'AIzaSyCfP1MphWuL07k1txaHwVpBv-pd9W9cxHY',
        appId: '1:759812020345:android:cb370f3f89a6069aa09ca8',
        messagingSenderId: '',
        projectId: 'drive--clone'),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Google Drive Clone',
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}
