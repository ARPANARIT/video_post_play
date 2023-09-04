import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class PostSuccessful extends StatefulWidget {
  const PostSuccessful({Key? key}) : super(key: key);

  @override
  State<PostSuccessful> createState() => _PostSuccessfulState();
}

class _PostSuccessfulState extends State<PostSuccessful> {
  final _firestore = FirebaseFirestore.instance;
  late String videoUrl;
  String? thumbnailUrl;

  VideoPlayerController? _controller;

  void listUrls() async {
    final snapshots = await _firestore.collection('videos').get();
    for (var snapshot in snapshots.docs) {
      thumbnailUrl = snapshot.data()['thumbnailUrl'];
      videoUrl = snapshot.data()['videoUrl'] ?? '';
      print('This is the video url : $videoUrl');
    }
    Uri uri = Uri.parse(videoUrl);
    print('This is the video Uri $uri');
  }

  @override
  void initState() {
    super.initState();
    videoUrl = '';
    listUrls();

    // _controller = VideoPlayerController.networkUrl(uri);
    // print(_controller!.value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Center(
            child: Text(
              'Video Posted Successfully',
              style: TextStyle(fontSize: 30),
            ),
          ),
          // Display the video thumbnail
          //Image.network(thumbnailUrl!),
          // Center(
          //   child: _controller!.value.isInitialized
          //       ? AspectRatio(
          //           aspectRatio: _controller!.value.aspectRatio,
          //           child: VideoPlayer(_controller!),
          //         )
          //       : CircularProgressIndicator(), // Loading indicator until video is initialized.
          // ),
        ],
      ),
    );
  }
}
