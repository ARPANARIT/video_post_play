import 'package:http/http.dart' as http;
import 'package:video_recorder/class/location.dart';
import 'dart:convert';

void getLocation() async {
  // create the location object
  double? longitude;
  double? latitude;
  Location location = Location();
  await location.getCurrentLocation(); // Future
  longitude = location.longitude!;
  latitude = location.latitude!;
  print(longitude);
  print(latitude);
  print('Parsing started');
  var url = Uri.parse(
      'https://api.api-ninjas.com/v1/reversegeocoding?lat=$longitude&lon=$latitude&X-Api-Key=6Shp8lF5d9yquQxE3i9Kcw==wtCphDYnCWV4VIsu');
  print(url);
  Map<String, String> headers = {
    'X-Api-Key': '6Shp8lF5d9yquQxE3i9Kcw==wtCphDYnCWV4VIsu',
    "Content-Type": "application/json",
    "Accept": "application/json",
  };
  http.Response response = await http.get(url, headers: headers);
  if (response.statusCode == 200) {
    String data = response.body;
    var decodedData = jsonDecode(data);
    print(decodedData);
  } else {
    print(response.statusCode);
  }
}
