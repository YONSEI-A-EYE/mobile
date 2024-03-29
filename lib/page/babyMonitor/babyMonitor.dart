import "dart:convert";
import "dart:typed_data";

import 'package:aeye/asset/url.dart';
import "package:aeye/component/common/app_bar.dart";
import 'package:aeye/controller/localNotificationController.dart';
import "package:flutter/material.dart";
import "package:get/get.dart";
import "package:http/http.dart" as http;
import "package:video_player/video_player.dart";
import 'package:web_socket_channel/io.dart';

class Monitor extends StatefulWidget {
  const Monitor({Key? key}) : super(key: key);

  @override
  State<Monitor> createState() => _MonitorState();
}

class _MonitorState extends State<Monitor> {
  LocalNotificationController localNotificationController = Get.find();

  _asyncMethod() async {
    Uri endPoint = Uri.parse('http://detect.a-eye.co.kr/baby/video');
    String token = localNotificationController.token;
    var bodyEncoded = json.encode({"token": token});

    http.Response response =
        await http.post(endPoint, body: bodyEncoded, headers: {
      "Content-Type": "application/json",
    });
    dynamic result = utf8.decode(response.bodyBytes);
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _asyncMethod();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: Header(curDate: null, curPath: "babyMonitor"),
        body: Container(
            width: double.infinity,
            height: double.infinity,
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Container(child: VideoViewer()),
            ])));
  }
}

class VideoStreaming extends StatefulWidget {
  const VideoStreaming({Key? key}) : super(key: key);

  @override
  State<VideoStreaming> createState() => _VideoStreamingState();
}

class _VideoStreamingState extends State<VideoStreaming> {
  late IOWebSocketChannel _channel;

  @override
  void initState() {
    super.initState();
    _channel = IOWebSocketChannel.connect('$HOST_URL');
  }

  @override
  void dispose() {
    _channel.sink.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _channel.stream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          Uint8List videoFrame = snapshot.data as Uint8List;
          return Image.memory(videoFrame);
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}

class VideoViewer extends StatefulWidget {
  const VideoViewer({Key? key}) : super(key: key);

  @override
  State<VideoViewer> createState() => _VideoViewerState();
}

class _VideoViewerState extends State<VideoViewer> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset('assets/videos/aeye_test.mp4');

    _controller.addListener(() {
      setState(() {});
    });
    _controller.setLooping(true);
    _controller.initialize().then((_) => setState(() {}));
    _controller.play();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: _controller.value.aspectRatio,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: <Widget>[
          VideoPlayer(_controller),
          VideoProgressIndicator(_controller, allowScrubbing: true),
        ],
      ),
    );
  }
}
