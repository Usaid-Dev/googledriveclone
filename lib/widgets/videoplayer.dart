import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPlay extends StatefulWidget {
  final String url;

  const VideoPlay({super.key, required this.url});

  @override
  _VideoPlayState createState() => _VideoPlayState();
}

class _VideoPlayState extends State<VideoPlay> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.url)
      ..addListener(() {
        setState(() {});
      })
      ..setLooping(true)
      ..initialize().then((_) => _controller.play());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Video Play',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 25,
          ),
        ),
      ),
      body: Center(
        child: _controller.value.isInitialized
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 400,
                    child: VideoPlayer(_controller),
                  ),
                  const SizedBox(height: 20),
                  VideoProgressIndicator(
                    _controller,
                    allowScrubbing: true,
                    padding: const EdgeInsets.only(top: 5.0),
                  ),
                ],
              )
            : const CircularProgressIndicator(color: Colors.black),
      ),
    );
  }
}
