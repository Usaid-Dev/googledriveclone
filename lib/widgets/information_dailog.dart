import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Make sure to pass the necessary variables or handle them differently if required.
Future<void> showInformationDialog(
    BuildContext context, CollectionReference ref) async {
  final TextEditingController titleController = TextEditingController();
  String _currentItemSelected = "PDF";
  final List<String> options = ['PDF', 'Image', 'video'];

  return await showDialog(
    barrierDismissible: false,
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            content: Form(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: titleController,
                    decoration:
                        const InputDecoration(hintText: "Please Enter Text"),
                  ),
                  const SizedBox(height: 50),
                  DropdownButton<String>(
                    dropdownColor: const Color.fromARGB(255, 255, 255, 255),
                    isDense: true,
                    isExpanded: false,
                    iconEnabledColor: const Color.fromARGB(255, 0, 0, 0),
                    items: options.map((String dropDownStringItem) {
                      return DropdownMenuItem<String>(
                        value: dropDownStringItem,
                        child: Text(
                          dropDownStringItem,
                          style: const TextStyle(
                            color: Color.fromARGB(255, 0, 0, 0),
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                      );
                    }).toList(),
                    onChanged: (newValueSelected) {
                      setState(() {
                        _currentItemSelected = newValueSelected!;
                      });
                    },
                    value: _currentItemSelected,
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
            actions: <Widget>[
              InkWell(
                child: const Text('Cancel'),
                onTap: () {
                  Navigator.of(context).pop();
                },
              ),
              const SizedBox(width: 40),
              InkWell(
                child: const Text('Create'),
                onTap: () {
                  if (titleController.text.isNotEmpty) {
                    User? user = FirebaseAuth.instance.currentUser;
                    if (user != null) {
                      ref.doc(user.uid).collection('folders').add({
                        'name': titleController.text,
                        'type': _currentItemSelected,
                      });
                      titleController.clear();
                      Navigator.of(context).pop();
                    }
                  }
                },
              ),
              const SizedBox(width: 40),
            ],
          );
        },
      );
    },
  );
}
