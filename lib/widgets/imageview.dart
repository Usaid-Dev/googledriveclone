import 'package:flutter/material.dart';

class ImageView extends StatelessWidget {
  final String url;

  const ImageView({super.key, required this.url});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Image View',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 25,
          ),
        ),
      ),
      body: Center(
        child: Image.network(url),
      ),
    );
  }
}
