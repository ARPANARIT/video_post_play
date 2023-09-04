import 'package:cloud_firestore/cloud_firestore.dart';

class Video {
  String? userID;
  String? videoId;
  String? title;
  String? address;
  String? videoUrl;
  String? thumbnailUrl;
  Video(
      {this.videoId,
      this.title,
      this.address,
      this.thumbnailUrl,
      this.userID,
      this.videoUrl});

  Map<String, dynamic> toJson() => {
        'userID': userID,
        'videoId': videoId,
        'title': title,
        'address': address,
        'videoUrl': videoUrl,
        'thumbnailUrl': thumbnailUrl
      };
  static Video fromDocumentSnapshot(DocumentSnapshot snapshot) {
    var data = snapshot.data() as Map<String, dynamic>;
    return Video(
        userID: data['userID'],
        videoId: data['videoId'],
        title: data['title'],
        address: data['address'],
        videoUrl: data['videoUrl'],
        thumbnailUrl: data['thumbnailUrl']);
  }
}
