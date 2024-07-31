import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googledriveclone/Widgets/Drawer.dart';
import 'package:googledriveclone/screens/upload.dart';
import 'package:googledriveclone/widgets/delete_dailog.dart';
import 'package:googledriveclone/widgets/information_dailog.dart';
import 'login_screen.dart';

class HomeScreen extends StatefulWidget {
  final String url;

  HomeScreen({
    Key? key,
    required this.url,
  }) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late GoogleSignIn _googleSignIn;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final CollectionReference _ref =
      FirebaseFirestore.instance.collection('users');

  @override
  void initState() {
    super.initState();
    _googleSignIn = GoogleSignIn();
  }

  @override
  Widget build(BuildContext context) {
    User? user = _auth.currentUser;
    final Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .collection('folders')
        .snapshots();

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
        ),
        title: const Text(
          'Drive Clone',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 25,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () async {
              await _googleSignIn.signOut();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const LoginScreen(),
                ),
              );
            },
            icon: const Icon(
              Icons.logout,
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          StreamBuilder<QuerySnapshot>(
            stream: _usersStream,
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return const Center(child: Text('Something went wrong'));
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: Text("Loading"));
              }

              return ListView(
                children: snapshot.data!.docs.map((DocumentSnapshot document) {
                  Map<String, dynamic> data =
                      document.data()! as Map<String, dynamic>;
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Upload(),
                        ),
                      );
                    },
                    child: ListTile(
                      leading: Icon(
                        Icons.folder,
                        color: Colors.amber[300],
                        size: 50,
                      ),
                      trailing: IconButton(
                        icon: const Icon(
                          Icons.delete,
                          color: Colors.red,
                        ),
                        onPressed: () async {
                          await showDeleteConfirmationDialog(
                              context, document.id);
                        },
                      ),
                      title: Text(data['name']),
                      subtitle: Text(data['type']),
                    ),
                  );
                }).toList(),
              );
            },
          ),
          Positioned(
            bottom: 30,
            right: 10,
            child: Center(
              child: FloatingActionButton(
                onPressed: () async {
                  await showInformationDialog(context, _ref);
                },
                child: const Icon(
                  Icons.add,
                ),
              ),
            ),
          ),
        ],
      ),
      drawer: CustomDrawer(
        user: user,
        googleSignIn: _googleSignIn,
      ),
    );
  }
}
