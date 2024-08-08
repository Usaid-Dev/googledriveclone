import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:googledriveclone/screens/home_screen.dart';
import 'package:googledriveclone/widgets/imageview.dart';
import 'package:googledriveclone/widgets/pdfview.dart';
import 'package:googledriveclone/widgets/videoplayer.dart';

class Upload extends StatefulWidget {
  final String did;
  final String type;
  final String url;

  const Upload({
    super.key,
    required this.did,
    required this.type,
    required this.url,
  });

  @override
  _UploadState createState() => _UploadState();
}

class _UploadState extends State<Upload> {
  late String did;
  late String type;
  late String url;
  late List<String> allowedExtensions;
  late Icon leadingIcon;
  final TextEditingController titleController = TextEditingController();
  final CollectionReference ref =
      FirebaseFirestore.instance.collection('users');
  File? file;
  String fileName = "";
  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    did = widget.did;
    type = widget.type;
    url = widget.url;

    switch (type) {
      case 'PDF':
        allowedExtensions = ['pdf'];
        leadingIcon = const Icon(
          Icons.picture_as_pdf,
          color: Color.fromARGB(255, 181, 0, 45),
          size: 40,
        );
        break;
      case 'Image':
        allowedExtensions = ['jpg', 'png'];
        leadingIcon = const Icon(
          Icons.image,
          color: Color.fromARGB(255, 0, 91, 181),
          size: 40,
        );
        break;
      case 'video':
        allowedExtensions = ['mp4'];
        leadingIcon = const Icon(
          Icons.play_circle,
          color: Color.fromARGB(255, 181, 0, 45),
          size: 50,
        );
        break;
      default:
        allowedExtensions = [];
        leadingIcon = const Icon(Icons.file_present, size: 40);
    }
  }

  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return const Scaffold(
        body: Center(child: Text('User not logged in')),
      );
    }

    final Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('folders')
        .doc(did)
        .collection(type)
        .snapshots();

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        centerTitle: true,
        title: const Text(
          'Drive Clone',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 25,
          ),
        ),
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
                return const Center(child: Text('Loading'));
              }

              final documents = snapshot.data?.docs ?? [];
              return ListView(
                children: documents.map((DocumentSnapshot document) {
                  final data = document.data() as Map<String, dynamic>;
                  return GestureDetector(
                    onTap: () {
                      if (type == 'Image') {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => (ImageView(
                              url: data['url'],
                            )),
                          ),
                        );
                      }
                      if (type == 'PDF') {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => (PdfView(
                              url: data['url'],
                            )),
                          ),
                        );
                      }
                      if (type == 'video') {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => (VideoPlay(
                              url: data['url'],
                            )),
                          ),
                        );
                      }
                    },
                    child: ListTile(
                      leading: leadingIcon,
                      title: Text(data['name']),
                      trailing: IconButton(
                        icon: const Icon(
                          Icons.delete,
                          color: Color.fromARGB(255, 255, 0, 64),
                        ),
                        onPressed: () => _deleteFile(document.id),
                      ),
                    ),
                  );
                }).toList(),
              );
            },
          ),
          Center(
            child: Visibility(
              visible: isLoading,
              child: const CircularProgressIndicator(color: Colors.indigo),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _pickFile,
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> _deleteFolder() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      final catalogues = await ref
          .doc(user.uid)
          .collection('folders')
          .doc(did)
          .collection(type)
          .get();

      for (var doc in catalogues.docs) {
        await doc.reference.delete();
      }

      await ref
          .doc(user.uid)
          .collection('folders')
          .doc(did)
          .delete()
          .whenComplete(() {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomeScreen(url: url),
          ),
        );
      });
    }
  }

  Future<void> _deleteFile(String documentId) async {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      await ref
          .doc(user.uid)
          .collection('folders')
          .doc(did)
          .collection(type)
          .doc(documentId)
          .delete();
    }
  }

  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: allowedExtensions,
    );

    if (result != null) {
      setState(() {
        file = File(result.files.single.path ?? '');
        fileName = result.names.single!;
        isLoading = true;
      });

      await _uploadFile();
    }
  }

  Future<void> _uploadFile() async {
    try {
      final storageRef =
          FirebaseStorage.instance.ref().child(type).child(fileName);
      final uploadTask = storageRef.putFile(file!);
      final snapshot = await uploadTask;
      final downloadUrl = await snapshot.ref.getDownloadURL();

      final user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        await ref
            .doc(user.uid)
            .collection('folders')
            .doc(did)
            .collection(type)
            .add({
          'url': downloadUrl,
          'name': fileName,
        });

        setState(() {
          isLoading = false;
        });

        Fluttertoast.showToast(
          msg: "Upload successful",
          textColor: Colors.green,
        );
      }
    } on Exception catch (e) {
      Fluttertoast.showToast(
        msg: e.toString(),
        textColor: Colors.red,
      );

      setState(() {
        isLoading = false;
      });
    }
  }
}
