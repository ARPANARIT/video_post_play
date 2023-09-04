import 'dart:io';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:video_recorder/screens/login_page.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_recorder/screens/upload_video.dart';
import 'package:http/http.dart' as http;
import 'package:video_recorder/class/location.dart';
import 'dart:convert';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //var locationDataPass;
  getVideoField(ImageSource videoSource) async {
    // Fetch the location data
    var locationData = await getLocation();
    XFile? videoXFile = await ImagePicker().pickVideo(source: videoSource);
    if (videoXFile != null) {
      // Convert XFile to File
      File videoFile = File(videoXFile.path);
      print('Video File: $videoFile');
      print('Path: ${videoXFile.path}');
      print('Location Data: $locationData');
      // using GetX

      Get.to(UploadForm(),
          arguments: [videoFile, videoXFile.path, locationData]);
    }
  }

  Future getLocation() async {
    double? longitude;
    double? latitude;

    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.low);

      longitude = position.longitude;
      latitude = position.latitude;

      print('Longitude: $longitude');
      print('Latitude: $latitude');
      print('Parsing started');

      var url = Uri.parse(
          'https://api.api-ninjas.com/v1/reversegeocoding?lat=$latitude&lon=$longitude');

      Map<String, String> headers = {
        'X-Api-Key': 'rg2hkU3JnXWZs3D1tBbAZXjLjDcPoriUYEaWeo0V',
      };

      http.Response response = await http.get(url, headers: headers);
      if (response.statusCode == 200) {
        String data = response.body;
        var decodedData = jsonDecode(data);
        var locationData = decodedData[0];
        print('This is the decoded data:$decodedData');
        print('from home page:${locationData['name']}');
        print('from home page:${locationData['state']}');
        print('from home page:${locationData['country']}');
        return locationData;
      } else {
        print('Error getting location: ${response.statusCode}');
      }
    } catch (e) {
      print('Error getting location: $e');
    }
  }

  DialogueBoxForVideo() {
    return showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        children: [
          SimpleDialogOption(
            onPressed: () {
              Get.snackbar(
                "GeeksforGeeks",
                "Hello everyone",
                icon: Icon(Icons.person, color: Colors.white),
                snackPosition: SnackPosition.BOTTOM,
              );
              getVideoField(ImageSource.gallery);
            },
            child: Row(
              children: [
                Icon(Icons.image),
                Expanded(
                    child: Padding(
                  padding: EdgeInsets.all(8),
                  child: Text(
                    'Get Video from Gallery',
                    maxLines: 3,
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ))
              ],
            ),
          ),
          SimpleDialogOption(
            onPressed: () async {
              //locationDataPass = await getLocation();
              getVideoField(ImageSource.camera);
            },
            child: Row(
              children: [
                Icon(Icons.camera_alt),
                Expanded(
                    child: Padding(
                  padding: EdgeInsets.all(8),
                  child: Text(
                    'Capture Video from Camera',
                    maxLines: 3,
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ))
              ],
            ),
          ),
          SimpleDialogOption(
            onPressed: () {
              //
              Get.back();
            },
            child: Row(
              children: [
                Icon(Icons.close),
                Expanded(
                    child: Padding(
                  padding: EdgeInsets.all(8),
                  child: Text(
                    'Cancel',
                    maxLines: 3,
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ))
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: SizedBox(
        height: 50,
        width: 120,
        child: FloatingActionButton(
          child: Text(
            'Logout',
            style: TextStyle(fontSize: 20),
          ), //child widget inside this button
          shape: StadiumBorder(),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 100,
              ),
              Image.asset('images/upload.jpeg'),
              TextButton(
                onPressed: DialogueBoxForVideo,
                child: Icon(
                  Icons.add,
                  color: Colors.blue,
                ),
                style: TextButton.styleFrom(
                  shape: RoundedRectangleBorder(),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
