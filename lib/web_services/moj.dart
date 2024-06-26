import 'dart:convert' show json;

import 'package:http/http.dart' as http;

class MojVideoDownloader {
  static getVideoId(String link) {
    if (link.contains('?referrer=share')) {}
    var links = link.split("/video/");
    var links2;
    if (links[1].contains('?')) {
      links2 = links[1].split("?");
      return links2[0];
    } else {
      return links[1];
    }
  }

//https://twitter.com/Rabipirzada/status/1420795095805317128?s=20
// https://mojapp.in/@piyanka_mongia/video/21594412?referrer=share
  static downloadVideo(String link) async {
    print("Working on MOJ");
    var url =
        'https://moj-apis.sharechat.com/videoFeed?postId=${getVideoId(link)}&firstFetch=true';
    var headers = {
      'X-SHARECHAT-USERID': '72137847101',
      'X-SHARECHAT-SECRET': '9e32d6145bfe53d14a0c',
      'APP-VERSION': '83',
      'PACKAGE-NAME': 'in.mohalla.video',
      'DEVICE-ID': 'ebb088d29e7287b1',
      'CLIENT-TYPE': 'Android:',
      'Content-Type': 'application/json; charset=UTF-8',
      'Host': 'moj-apis.sharechat.com',
      'Connection': 'Keep-Alive:',
      'User-Agent': 'okhttp/3.12.12app-version:83',
      'cache-control': 'no-cache',
      'client-type': 'Android',
      'connection': 'Keep-Alive',
      'content-type': 'application/json;charset=UTF-8',
      'device-id': 'ebb088d29e7287b1',
      'host': 'moj-apis.sharechat.com',
      'package-name': 'in.mohalla.video',
      'postman-token': '37d59a7c-f247-3b70-ab3c-1dedf4079852',
      'user-agent': 'okhttp/3.12.12',
      'x-sharechat-secret': '9e32d6145bfe53d14a0c',
      'x-sharechat-userid': '72137847101'
    };
    var request = http.Request('POST', Uri.parse(url));
    request.body =
        "{\"appVersion\":83,\"bn\":\"broker1\",\"client\":\"android\",\"deviceId\":\"ebb088d29e7287b1\",\"message\":{\"adData\":{\"adsShown\":0,\"firstFeed\":false},\"deviceInfoKey\":\"OSyQoHJLJ4NsXPLyQePkAICh3Q0ih0bveFwm1KEV+vReMuldqo+mSyMjdhb4EeryKxk1ctAbYaDH\\\\nTI+PMRPZVYH5pBccAm7OT2uz69vmD/wPqGuSgWV2aVNMdM75DMb8NZn1JU2b1bo/oKs80baklsvx\\\\n1X7jrFPL6M5EDTdPDhs=\\\\n\",\"deviceInfoPayload\":\"M6g+6j6irhFT/H6MsQ/n/tEhCl7Z5QgtVfNKU8M90zTJHxqljm2263UkjRR9bRXAjmQFXXOTXJ25\\\\nOHRjV7L5Lw+tUCONoYfyUEzADihWfAiUgXJEcKePfZONbdXXuwGgOPeD0k4iSvI7JdzroRCScKXd\\\\n41CkmXFayPaRL9aqgAgs6kSoIncCWBU2gEXiX1lgPVvdmUzCZ+yi2hFA+uFOmv1MJ6dcFKKcpBM6\\\\nHSPIrGV+YtTyfd8nElx0kyUbE4xmjOuMrctkjnJkd2tMdxB8qOFKeYrcLzy4LZJNXyUmzs29XSE+\\\\nhsrMZib8fFPJhJZIyGCWqfWiURut4Bg5HxYhYhg3ejPxFjNyXxS3Ja+/pA+A0olt5Uia7ync/Gui\\\\n58tlDQ4SKPthCzGa1tCVN+2y/PW30+LM79t0ltJ/YrNZivQx4eEnszlM9nwmIuj5z5LPniQghA6x\\\\nrfQ8IqVUZfiitXj/Fr7UjKg1cs/Ajj8g4u/KooRvVkg9tMwWePtJFqrkk1+DU4cylnSEG3XHgfer\\\\nslrzj5NNZessMEi+4Nz0O2D+b8Y+RjqN6HqpwZPDHhZwjz0Iuj2nhZLgu1bgNJev5BwxAr8akDWv\\\\nvKsibrJS9auQOYVzbYZFdKMiBnh+WHq0qO2aW1akYWCha3ZsSOtsnyPnFC+1PnMbBv+FiuJmPMXg\\\\nSODFoRIXfxgA/qaiKBipS+kIyfaPxn6O1i6MOwejVuQiWdAPTO132Spx0cFtdyj2hX6wAMe21cSy\\\\n8rs3KQxiz+cq7Rfwzsx4wiaMryFunfwUwnauGwTFOW98D5j6oO8=\\\\n\",\"lang\":\"Hindi\",\"playEvents\":[{\"authorId\":\"18326559001\",\"networkBitrate\":1900000,\"initialBufferPercentage\":100,\"isRepost\":false,\"sg\":false,\"meta\":\"NotifPostId\",\"md\":\"Stream\",\"percentage\":24.68405,\"p\":\"91484006\",\"radio\":\"wifi\",\"r\":\"deeplink_VideoPlayer\",\"repeatCount\":0,\"timeSpent\":9633,\"duration\":15,\"videoStartTime\":3916,\"t\":1602255552820,\"clientType\":\"Android\",\"i\":79,\"appV\":83,\"sessionId\":\"72137847101_8863b3f5-ad2d-4d59-aa7c-cf1fb9ef32ea\"},{\"authorId\":\"73625124001\",\"networkBitrate\":1900000,\"initialBufferPercentage\":100,\"isRepost\":false,\"sg\":false,\"meta\":\"list2\",\"md\":\"Stream\",\"percentage\":17.766666,\"p\":\"21594412\",\"radio\":\"wifi\",\"r\":\"First Launch_VideoPlayer\",\"repeatCount\":0,\"tagId\":\"0\",\"tagName\":\"\",\"timeSpent\":31870,\"duration\":17,\"videoStartTime\":23509,\"t\":1602218215942,\"clientType\":\"Android\",\"i\":79,\"appV\":83,\"sessionId\":\"72137847101_db67c0c9-a267-4cec-a3c3-4c0fa4ea16e1\"}],\"r\":\"VideoFeed\"},\"passCode\":\"9e32d6145bfe53d14a0c\",\"resTopic\":\"response/user_72137847101_9e32d6145bfe53d14a0c\",\"userId\":\"72137847101\"}";
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var myRes = await response.stream.bytesToString();
      var temp = json.decode(myRes);
      var index = temp['payload']['d'][0]["bandwidthParsedVideos"];

      return index[index.length - 1]['url'];

      ///Working

    } else {
      print(response.reasonPhrase);
    }
  }
}
