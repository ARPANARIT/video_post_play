import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_alt/modal_progress_hud_alt.dart';
import 'package:video_compress/video_compress.dart';
import 'package:video_player/video_player.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:video_recorder/screens/posted_successfully.dart';
import '../constants.dart';
import '../model/video.dart';

class UploadForm extends StatefulWidget {
  @override
  State<UploadForm> createState() => _UploadFormState();
}

class _UploadFormState extends State<UploadForm> {
  final File videoFile = Get.arguments[0];
  final String path = Get.arguments[1];
  var location = Get.arguments[2];
  // Firebase Authentication
  final _auth = FirebaseAuth.instance;

  //
  String? name;
  String? country;
  String? state;
  VideoPlayerController? videoPlayerController;
  TextEditingController? titleController;
  TextEditingController? locationController;
  String? titleP;
  String? locationAddress;
  String? userUid;
  // firebase storage //
  final folderRef = FirebaseStorage.instance.ref().child("videos");
  // progress
  bool wait = false;
  @override
  void initState() {
    super.initState();
    getCurrentUser();
    setState(() {
      videoPlayerController = VideoPlayerController.file(videoFile);
      videoPlayerController!.initialize();
      videoPlayerController!.play();
      videoPlayerController!.setVolume(2);
    });
    name = location['name'];
    country = location['country'];
    state = location['state'];

    locationController =
        TextEditingController(text: '$name, $country, $state ');
    titleController = TextEditingController();
  }

// one method to save video on firebase storage
  void firebaseTest() async {
    // Upload the video file to the videos folder
    final videoFileRef =
        folderRef.child("video_${DateTime.now().millisecondsSinceEpoch}.mp4");
    await videoFileRef.putFile(videoFile);

    print("Video uploaded successfully");
  }

// another method to save video on firebase storage
  uploadVideo(String videoId, String videoPath) async {
    UploadTask videoUpload = FirebaseStorage.instance
        .ref()
        .child('videos')
        .child(videoId)
        .putFile(videoFile);
    TaskSnapshot snapshot = await videoUpload;
    String urlVideo = await snapshot.ref.getDownloadURL();
    return urlVideo;
  }

  // method to save thumbnail video on firebase storage
  uploadThumbnail(String videoId, String videoPath) async {
    UploadTask thumbnailUpload = FirebaseStorage.instance
        .ref()
        .child('Thumbnails')
        .child(videoId)
        .putFile(await getThumbnailImage(videoPath));
    TaskSnapshot snapshot = await thumbnailUpload;
    String urlThumbnail = await snapshot.ref.getDownloadURL();
    return urlThumbnail;
  }

// Firebase database //
  saveVideoInfo(
    String title,
    String address,
    String videoPath,
  ) async {
    try {
      String videoId = DateTime.now().millisecondsSinceEpoch.toString();
      String downloadVideoUrl = await uploadVideo(videoId, videoPath);
      String downloadThumbnailUrl = await uploadThumbnail(videoId, videoPath);
      // save info to firstore database
      Video video = Video(
          userID: userUid,
          videoId: videoId,
          title: titleP,
          address: locationAddress,
          videoUrl: downloadVideoUrl,
          thumbnailUrl: downloadThumbnailUrl);
      await FirebaseFirestore.instance
          .collection('videos')
          .doc(videoId)
          .set(video.toJson());

      Get.to(PostSuccessful());
      Get.snackbar('New Video', 'Video Posted Successfully');
      setState(() {
        wait = false;
      });
    } catch (e) {
      Get.snackbar('Video upload Unsuccessfull', '$e was the error');
    }
  }

  void getCurrentUser() async {
    try {
      final currentuser = await _auth.currentUser!;
      if (currentuser != null) {
        print('Logged in user ${currentuser.uid}');
        userUid = currentuser.uid;
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  getThumbnailImage(String videoPath) async {
    final thumbnailImage = await VideoCompress.getFileThumbnail(videoPath);
    return thumbnailImage;
  }

  @override
  void dispose() {
    videoPlayerController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ModalProgressHUD(
        progressIndicator: CircularProgressIndicator(
          color: Colors.black54,
        ),
        inAsyncCall: wait,
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width / 0.8,
                height: MediaQuery.of(context).size.height / 1.5,
                child: ClipRRect(
                    borderRadius: BorderRadius.all(
                      Radius.circular(30.0),
                    ),
                    child: VideoPlayer(videoPlayerController!)),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: TextField(
                  textAlign: TextAlign.center,
                  enableInteractiveSelection: true,
                  keyboardType: TextInputType.text,
                  controller: titleController,
                  onChanged: (value) {
                    setState(() {
                      titleP = value;
                    });
                  },
                  decoration: textFieldDecor.copyWith(
                      hintText: 'Enter Title',
                      prefixIcon: Icon(Icons.description)),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: TextField(
                  textAlign: TextAlign.center,
                  enableInteractiveSelection: true,
                  keyboardType: TextInputType.text,
                  controller: locationController,
                  onChanged: (value) {
                    setState(() {
                      locationAddress = value;
                    });
                  },
                  decoration: textFieldDecor.copyWith(
                      hintText: 'Enter location', prefixIcon: Icon(Icons.map)),
                ),
              ),
              SizedBox(
                height: 40,
                width: 100,
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      wait = true;
                    });
                    if (titleController!.text.isNotEmpty &&
                        locationController!.text.isNotEmpty) {
                      saveVideoInfo(titleP!, locationAddress!, path!);
                    }
                    //firebaseTest();
                  },
                  child: Text(
                    'Post',
                    style: TextStyle(fontSize: 20),
                  ),
                  style: ElevatedButton.styleFrom(shape: StadiumBorder()),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
