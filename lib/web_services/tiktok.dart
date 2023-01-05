import 'dart:convert' show json, utf8;

import 'package:http/http.dart' as http;

class TiktokVideoDownloader {
//https://twitter.com/Rabipirzada/status/1420795095805317128?s=20
  static downloadVideo(String link) async {
    var request = http.Request(
        'GET',
        Uri.parse(
            'https://youtube4kdownloader.com/ajax/getLinks.php?video=$link&rand=7a6d56d6659b6'));

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var res = await response.stream.bytesToString();
      if (res.isNotEmpty) {
        var myDoc;
        try {
          var decoded = json.decode(res);

          ///Working
          myDoc = decoded['data']['av'];
          myDoc = myDoc[myDoc.length - 1]['url'];

          print(myDoc);
          return myDoc;

          ///working

        } catch (e) {}
      } else {
        //  return "";
      }
    } else {
      print(response.reasonPhrase);
    }
  }
}
